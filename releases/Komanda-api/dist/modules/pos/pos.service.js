"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.POSService = void 0;
const database_1 = require("../../config/database");
const categoria_entity_1 = require("./domain/categoria.entity");
const receta_entity_1 = require("./domain/receta.entity");
const mesa_entity_1 = require("./domain/mesa.entity");
const pedido_entity_1 = require("./domain/pedido.entity");
const pedido_detalle_entity_1 = require("./domain/pedido-detalle.entity");
const restaurant_entity_1 = require("../signup/domain/restaurant.entity");
const kitchen_socket_1 = require("../kitchen/kitchen.socket");
const accounting_service_1 = require("../accounting/accounting.service");
/** Genera código único por restaurante: R{restaurantId}-PED-YYYYMMDD-0001 */
const generateOrderCode = async (restaurantId) => {
    const today = new Date().toISOString().slice(0, 10).replace(/-/g, "");
    const prefix = `R${restaurantId}-PED-${today}`;
    // Lock-free: count existing codes with this prefix for this restaurant
    const result = await database_1.Conexion.getRepository(pedido_entity_1.Pedido)
        .createQueryBuilder("p")
        .where("p.restaurante_id = :rid", { rid: restaurantId })
        .andWhere("p.codigo LIKE :prefix", { prefix: `${prefix}-%` })
        .getCount();
    const seq = String(result + 1).padStart(4, "0");
    return `${prefix}-${seq}`;
};
class POSService {
    static async getCategories(restaurantId) {
        return database_1.Conexion.getRepository(categoria_entity_1.Categoria).find({
            where: { restaurante_id: restaurantId, activo: true }
        });
    }
    static async getProducts(restaurantId) {
        return database_1.Conexion.getRepository(receta_entity_1.Receta).find({
            where: { restaurante_id: restaurantId, activo: true }
        });
    }
    static async getTables(restaurantId) {
        return database_1.Conexion.getRepository(mesa_entity_1.Mesa).find({
            where: { restaurante_id: restaurantId }
        });
    }
    static async getPaymentMethods(_restaurantId) {
        return database_1.Conexion.query(`SELECT id, nombre, activo FROM core.metodos_pago 
             WHERE activo = true 
             ORDER BY nombre`);
    }
    static async getSales(restaurantId) {
        return database_1.Conexion.query(`SELECT p.id, p.codigo, p.cliente, p.estado, p.estado_cuenta, p.subtotal, p.impuestos, p.total, p.fecha_hora
             FROM operaciones.pedidos p
             WHERE p.restaurante_id = $1
             ORDER BY p.fecha_hora DESC LIMIT 50`, [restaurantId]);
    }
    static async getActiveOrders(restaurantId) {
        return database_1.Conexion.query(`SELECT 
                p.id, p.codigo, p.cliente, p.estado, p.estado_cuenta, 
                p.subtotal, p.total, p.fecha_hora,
                m.numero AS mesa_numero, m.nombre AS mesa_nombre, m.estado AS mesa_estado,
                json_agg(
                    json_build_object(
                        'id', pd.id,
                        'receta_id', pd.receta_id,
                        'nombre', r.nombre,
                        'cantidad', pd.cantidad,
                        'precio_unitario', pd.precio_unitario,
                        'subtotal', pd.subtotal,
                        'notas', pd.notas
                    ) ORDER BY pd.id
                ) AS items
             FROM operaciones.pedidos p
             LEFT JOIN operaciones.mesas m ON m.id = p.mesa_id
             LEFT JOIN operaciones.pedido_detalle pd ON pd.pedido_id = p.id
             LEFT JOIN menu.recetas r ON r.id = pd.receta_id
             WHERE p.restaurante_id = $1
               AND p.estado IN ('pendiente', 'preparando', 'listo')
             GROUP BY p.id, m.numero, m.nombre, m.estado
             ORDER BY p.fecha_hora DESC`, [restaurantId]);
    }
    // Cola del cajero: pedidos con cuenta abierta (sin importar si ya está en cocina)
    static async getReadyOrders(restaurantId) {
        return database_1.Conexion.query(`SELECT 
                p.id, p.codigo, p.cliente, p.estado, p.estado_cuenta,
                p.subtotal, p.impuestos, p.total, p.fecha_hora,
                m.numero AS mesa_numero, m.nombre AS mesa_nombre,
                json_agg(
                    json_build_object(
                        'id', pd.id,
                        'nombre', r.nombre,
                        'cantidad', pd.cantidad,
                        'precio_unitario', pd.precio_unitario,
                        'subtotal', pd.subtotal,
                        'notas', pd.notas
                    ) ORDER BY pd.id
                ) AS items
             FROM operaciones.pedidos p
             LEFT JOIN operaciones.mesas m ON m.id = p.mesa_id
             LEFT JOIN operaciones.pedido_detalle pd ON pd.pedido_id = p.id
             LEFT JOIN menu.recetas r ON r.id = pd.receta_id
             WHERE p.restaurante_id = $1
               AND p.estado_cuenta = 'abierta'
               AND p.estado IN ('pendiente', 'preparando', 'listo')
             GROUP BY p.id, m.numero, m.nombre
             ORDER BY
               CASE p.estado WHEN 'listo' THEN 0 WHEN 'preparando' THEN 1 ELSE 2 END,
               p.fecha_hora ASC`, [restaurantId]);
    }
    static async updateOrderStatus(pedidoId, estado, restaurantId) {
        const validEstados = ['pendiente', 'preparando', 'listo', 'anulado'];
        if (!validEstados.includes(estado))
            throw new Error('Estado inválido');
        const result = await database_1.Conexion.query(`UPDATE operaciones.pedidos 
             SET estado = $1, updated_at = NOW()
             WHERE id = $2 AND restaurante_id = $3
             RETURNING id, codigo, estado, mesa_id`, [estado, pedidoId, restaurantId]);
        if (!result.length)
            throw new Error('Pedido no encontrado');
        return result[0];
    }
    // Reporte de cierre de caja (turno actual o del día)
    static async getCashReport(restaurantId) {
        // Pedidos del día pagados
        const resultPedidos = await database_1.Conexion.query(`SELECT COUNT(id) AS pedidos_cobrados, COALESCE(SUM(total), 0) AS monto_total
             FROM operaciones.pedidos
             WHERE restaurante_id = $1
               AND estado_cuenta = 'pagada'
               AND DATE(created_at) = CURRENT_DATE`, [restaurantId]);
        // Desglose por método de pago del día
        const resultPagos = await database_1.Conexion.query(`SELECT 
                tp.metodo,
                COUNT(tp.id) AS num_transacciones,
                COALESCE(SUM(tp.monto), 0) AS total
             FROM operaciones.transacciones_pago tp
             JOIN operaciones.pedidos p ON p.id = tp.pedido_id
             WHERE tp.restaurante_id = $1
               AND DATE(tp.created_at) = CURRENT_DATE
             GROUP BY tp.metodo
             ORDER BY total DESC`, [restaurantId]);
        return {
            fecha: new Date().toISOString(),
            pedidos_cobrados: parseInt(resultPedidos[0]?.pedidos_cobrados || '0', 10),
            monto_total: parseFloat(resultPedidos[0]?.monto_total || '0'),
            desglose_pagos: resultPagos.map((row) => ({
                metodo: row.metodo,
                num_transacciones: parseInt(row.num_transacciones, 10),
                total: parseFloat(row.total)
            }))
        };
    }
    static async createSale(data, restaurantId, userId) {
        const qr = database_1.Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();
        try {
            // 1. Validar mesa si es provista
            if (data.mesa_id) {
                const mesa = await qr.manager.findOne(mesa_entity_1.Mesa, { where: { id: data.mesa_id, restaurante_id: restaurantId } });
                if (!mesa)
                    throw new Error("La mesa seleccionada no existe o no pertenece al restaurante");
            }
            // 2. Impuesto
            const restaurant = await qr.manager.findOne(restaurant_entity_1.Restaurant, { where: { id: restaurantId } });
            if (!restaurant)
                throw new Error("Restaurante no encontrado");
            const taxRate = Number(restaurant.impuesto_porcentaje || 0) / 100;
            // 3. Precios reales
            const recetaIds = data.items.map(i => i.receta_id);
            const recetas = await qr.manager
                .getRepository(receta_entity_1.Receta)
                .createQueryBuilder("r")
                .where("r.id IN (:...ids)", { ids: recetaIds })
                .andWhere("r.restaurante_id = :rid", { rid: restaurantId })
                .getMany();
            if (recetas.length !== recetaIds.length) {
                throw new Error("Una o más recetas no están disponibles");
            }
            const priceMap = new Map(recetas.map(r => [r.id, Number(r.precio_venta)]));
            // [NUEVO LOGICA: Bloqueo de Stock y Back-flushing]
            const itemsJson = JSON.stringify(data.items.map(i => ({ receta_id: i.receta_id, cantidad: i.cantidad })));
            const stockCheck = await qr.manager.query(`
                WITH required AS (
                    SELECT 
                        ri.ingrediente_id,
                        SUM(ri.cantidad * (i.value->>'cantidad')::numeric) AS cantidad_requerida
                    FROM menu.receta_ingredientes ri
                    CROSS JOIN json_array_elements($1::json) AS i
                    WHERE ri.receta_id = (i.value->>'receta_id')::int
                    AND ri.restaurante_id = $2
                    GROUP BY ri.ingrediente_id
                )
                SELECT 
                    r.ingrediente_id, 
                    r.cantidad_requerida,
                    i.nombre,
                    i.cantidad_disponible,
                    i.costo_promedio
                FROM required r
                JOIN inventario.ingredientes i ON i.id = r.ingrediente_id
                WHERE i.restaurante_id = $2
            `, [itemsJson, restaurantId]);
            let totalCostoVenta = 0;
            // 4. Validar Inventario antes de proseguir
            for (const req of stockCheck) {
                if (Number(req.cantidad_disponible) < Number(req.cantidad_requerida)) {
                    throw new Error(`Stock insuficiente para el ingrediente: ${req.nombre}`);
                }
                totalCostoVenta += Number(req.cantidad_requerida) * Number(req.costo_promedio);
                // Ejecutar Back-flushing
                await qr.manager.query(`UPDATE inventario.ingredientes 
                     SET cantidad_disponible = cantidad_disponible - $1, 
                         updated_at = CURRENT_TIMESTAMP 
                     WHERE id = $2 AND restaurante_id = $3`, [req.cantidad_requerida, req.ingrediente_id, restaurantId]);
            }
            // 5. Calcular detalle
            const detallesData = data.items.map(item => {
                const unitPrice = priceMap.get(item.receta_id);
                const subtotal = Number((unitPrice * item.cantidad).toFixed(2));
                return {
                    receta_id: item.receta_id,
                    cantidad: item.cantidad,
                    precio_unitario: unitPrice,
                    subtotal: subtotal,
                    notas: item.notas || null,
                    restaurante_id: restaurantId
                };
            });
            const subtotal = Number(detallesData.reduce((acc, curr) => acc + curr.subtotal, 0).toFixed(2));
            const impuestos = Number((subtotal * taxRate).toFixed(2));
            const total = Number((subtotal + impuestos).toFixed(2));
            // 6. Validar pagos
            let totalPagado = 0;
            if (data.pagos && data.pagos.length > 0) {
                totalPagado = data.pagos.reduce((acc, p) => acc + p.monto, 0);
            }
            const estado_cuenta = (totalPagado >= total) ? "pagada" : "abierta";
            // 7. Crear Pedido
            const codigo = await generateOrderCode(restaurantId);
            const pedido = qr.manager.create(pedido_entity_1.Pedido, {
                codigo,
                mesa_id: data.mesa_id || null,
                mesero_id: null, // operaciones.meseros es independiente de core.usuarios
                cliente: data.cliente || null,
                estado: "pendiente", // Se envía a cocina como pendiente
                estado_cuenta,
                subtotal,
                descuento: 0,
                impuestos,
                total,
                restaurante_id: restaurantId
            });
            await qr.manager.save(pedido);
            // 8. Insertar Detalle
            const detallesEntities = detallesData.map(d => qr.manager.create(pedido_detalle_entity_1.PedidoDetalle, { ...d, pedido_id: pedido.id }));
            await qr.manager.save(detallesEntities);
            // 9. Ocupar mesa si hay y no está pagada
            if (data.mesa_id) {
                const estadoMesa = estado_cuenta === 'pagada' ? 'libre' : 'ocupada';
                await qr.manager.update(mesa_entity_1.Mesa, { id: data.mesa_id }, { estado: estadoMesa });
            }
            // 10. Registrar transacciones de pago si las hay (Tabla: operaciones.transacciones_pago)
            if (data.pagos && data.pagos.length > 0) {
                const metodosIds = data.pagos.map(p => p.metodo_pago_id);
                const dbMetodos = await qr.manager.query(`SELECT id, nombre FROM core.metodos_pago WHERE id = ANY($1)`, [metodosIds]);
                for (const pago of data.pagos) {
                    const foundMetodo = dbMetodos.find(m => m.id === pago.metodo_pago_id);
                    let enumVal = 'efectivo'; // por defecto
                    if (foundMetodo) {
                        const nom = foundMetodo.nombre.toLowerCase();
                        if (nom.includes('móvil') || nom.includes('movil') || nom.includes('zelle'))
                            enumVal = 'pago_movil';
                        else if (nom.includes('tarjeta') || nom.includes('punto'))
                            enumVal = 'tarjeta';
                        else if (nom.includes('divisa') || nom.includes('dólar') || nom.includes('dolar'))
                            enumVal = 'divisa';
                    }
                    await qr.manager.query(`INSERT INTO operaciones.transacciones_pago 
                        (pedido_id, metodo, monto, referencia, tasa_cambio, usuario_id, restaurante_id) 
                        VALUES ($1, $2, $3, $4, $5, $6, $7)`, [pedido.id, enumVal, pago.monto, pago.referencia || null, 1.0, userId, restaurantId]);
                }
            }
            // 11. Integración Contable -> Generar asientos
            const fechaActual = new Date().toISOString().slice(0, 10);
            let [cuentaInventario] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '1.1.03' LIMIT 1`);
            if (!cuentaInventario)
                [cuentaInventario] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%inventario%' LIMIT 1`);
            let [cuentaCosto] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '5.1.01' LIMIT 1`);
            if (!cuentaCosto)
                [cuentaCosto] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%costo%' LIMIT 1`);
            let [cuentaCaja] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '1.1.01' LIMIT 1`);
            if (!cuentaCaja)
                [cuentaCaja] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%caja%' LIMIT 1`);
            let [cuentaVentas] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '4.1.01' LIMIT 1`);
            if (!cuentaVentas)
                [cuentaVentas] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%ventas%' LIMIT 1`);
            const lineasAsiento = [];
            if (totalCostoVenta > 0) {
                if (!cuentaCosto || !cuentaInventario)
                    throw new Error("No se encontraron las cuentas de Costo o Inventario para registrar la venta.");
                lineasAsiento.push({ cuenta_id: cuentaCosto.id, tipo_movimiento: 'debe', monto: totalCostoVenta, descripcion: 'Costo de Ventas' }, { cuenta_id: cuentaInventario.id, tipo_movimiento: 'haber', monto: totalCostoVenta, descripcion: 'Salida de Inventario' });
            }
            if (estado_cuenta === 'pagada' && total > 0) {
                if (!cuentaCaja || !cuentaVentas)
                    throw new Error("No se encontraron las cuentas de Caja o Ventas para registrar el cobro.");
                lineasAsiento.push({ cuenta_id: cuentaCaja.id, tipo_movimiento: 'debe', monto: total, descripcion: 'Ingreso a Caja/Bancos por Venta' }, { cuenta_id: cuentaVentas.id, tipo_movimiento: 'haber', monto: total, descripcion: 'Ingresos por Ventas' });
            }
            if (lineasAsiento.length > 0) {
                await accounting_service_1.AccountingService.registrarAsientoContable(fechaActual, `Registro Pedido ${pedido.codigo}`, 'venta', lineasAsiento, restaurantId, pedido.id, userId, qr);
            }
            await qr.commitTransaction();
            // Notify Kitchen through WebSocket
            (0, kitchen_socket_1.broadcastNewOrderToKitchen)({ id: pedido.id, codigo: pedido.codigo, restaurante_id: restaurantId });
            return {
                id: pedido.id,
                codigo: pedido.codigo,
                subtotal,
                impuestos,
                total,
                estado_cuenta
            };
        }
        catch (error) {
            await qr.rollbackTransaction();
            throw error;
        }
        finally {
            await qr.release();
        }
    }
    // ─── CHECKOUT: Pagar una orden ya existente (estado: listo → pagada) ───
    static async checkoutOrder(pedidoId, data, restaurantId, userId) {
        const qr = database_1.Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();
        try {
            // 1. Cargar la orden con sus detalles
            const [pedido] = await qr.manager.query(`SELECT p.id, p.estado, p.estado_cuenta, p.total, p.mesa_id, p.subtotal, p.impuestos
                 FROM operaciones.pedidos p
                 WHERE p.id = $1 AND p.restaurante_id = $2`, [pedidoId, restaurantId]);
            if (!pedido)
                throw new Error('Pedido no encontrado');
            if (pedido.estado_cuenta === 'pagada')
                throw new Error('Este pedido ya fue pagado');
            if (!['listo', 'pendiente', 'preparando', 'enviado'].includes(pedido.estado))
                throw new Error('El pedido no tiene un estado válido para cobrar');
            // 2. Validar monto cubierto
            const totalPagado = data.pagos.reduce((acc, p) => acc + p.monto, 0);
            if (totalPagado < Number(pedido.total))
                throw new Error(`Pago insuficiente. Total: ${pedido.total}, Pagado: ${totalPagado.toFixed(2)}`);
            // 3. Resolver metodo_pago_id → enum BD
            const metodosIds = data.pagos.map(p => p.metodo_pago_id);
            const dbMetodos = await qr.manager.query(`SELECT id, nombre FROM core.metodos_pago WHERE id = ANY($1)`, [metodosIds]);
            const toEnum = (id) => {
                const m = dbMetodos.find(x => x.id === id);
                if (!m)
                    return 'efectivo';
                const n = m.nombre.toLowerCase();
                if (n.includes('móvil') || n.includes('movil') || n.includes('zelle'))
                    return 'pago_movil';
                if (n.includes('tarjeta') || n.includes('punto'))
                    return 'tarjeta';
                if (n.includes('divisa') || n.includes('dólar') || n.includes('dolar') || n.includes('usd'))
                    return 'divisa';
                return 'efectivo';
            };
            // 4. Insertar transacciones de pago
            for (const pago of data.pagos) {
                await qr.manager.query(`INSERT INTO operaciones.transacciones_pago
                     (pedido_id, metodo, monto, referencia, tasa_cambio, usuario_id, restaurante_id)
                     VALUES ($1, $2, $3, $4, 1.0, $5, $6)`, [pedidoId, toEnum(pago.metodo_pago_id), pago.monto, pago.referencia || null, userId, restaurantId]);
            }
            // 5. Marcar pedido como pagado y entregado
            await qr.manager.query(`UPDATE operaciones.pedidos
                 SET estado = 'entregado', estado_cuenta = 'pagada', updated_at = NOW()
                 WHERE id = $1 AND restaurante_id = $2`, [pedidoId, restaurantId]);
            // 6. Liberar la mesa si la hay
            if (pedido.mesa_id) {
                await qr.manager.query(`UPDATE operaciones.mesas SET estado = 'libre', updated_at = NOW()
                     WHERE id = $1 AND restaurante_id = $2`, [pedido.mesa_id, restaurantId]);
            }
            // 7. Asientos contables
            const fecha = new Date().toISOString().slice(0, 10);
            let [cuentaCaja] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '1.1.01' LIMIT 1`);
            if (!cuentaCaja)
                [cuentaCaja] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%caja%' LIMIT 1`);
            let [cuentaVentas] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '4.1.01' LIMIT 1`);
            if (!cuentaVentas)
                [cuentaVentas] = await qr.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%ventas%' LIMIT 1`);
            if (pedido.total > 0) {
                if (!cuentaCaja || !cuentaVentas)
                    throw new Error("No se encontraron las cuentas contables (Caja o Ventas) para registrar el cobro.");
                await accounting_service_1.AccountingService.registrarAsientoContable(fecha, `Cobro de Pedido ${pedidoId}`, 'venta', [
                    { cuenta_id: cuentaCaja.id, tipo_movimiento: 'debe', monto: pedido.total, descripcion: 'Cobro de Pedido - Caja' },
                    { cuenta_id: cuentaVentas.id, tipo_movimiento: 'haber', monto: pedido.total, descripcion: 'Ingresos por Ventas' }
                ], restaurantId, pedidoId, userId, qr);
            }
            await qr.commitTransaction();
            return {
                pedido_id: pedidoId,
                total: pedido.total,
                total_pagado: totalPagado,
                vuelto: Number((totalPagado - Number(pedido.total)).toFixed(2)),
                estado: 'entregado',
                estado_cuenta: 'pagada'
            };
        }
        catch (error) {
            await qr.rollbackTransaction();
            throw error;
        }
        finally {
            await qr.release();
        }
    }
    static async closeCashRegister(data, restaurantId, userId) {
        const qr = database_1.Conexion.createQueryRunner();
        await qr.connect();
        await qr.startTransaction();
        try {
            // Se calcula el monto_teorico a partir de las transacciones_pago de los pedidos creados en la última caja abierta
            // Este es un bosquejo para insertar la caja en finanzas.caja
            const result = await qr.manager.query(`INSERT INTO finanzas.caja 
                (fecha_apertura, fecha_cierre, monto_inicial, monto_final, monto_teorico, diferencia, estado, usuario_apertura_id, usuario_cierre_id, observaciones, restaurante_id)
                VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 0, $1, $1, 0, 'cerrada', $2, $2, $3, $4)`, [data.monto_final, userId, data.observaciones || null, restaurantId]);
            await qr.commitTransaction();
            return { caja_id: result[0]?.id, status: "Caja cerrada exitosamente" };
        }
        catch (error) {
            await qr.rollbackTransaction();
            throw error;
        }
        finally {
            await qr.release();
        }
    }
}
exports.POSService = POSService;

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DashboardService = void 0;
const database_1 = require("../../config/database");
class DashboardService {
    /** Estadísticas del administrador */
    static async getAdminStats(restaurantId) {
        // 1. Ventas del día (pedidos pagados)
        const [ventasHoy] = await database_1.Conexion.query(`SELECT 
                COALESCE(SUM(total), 0) AS total_hoy,
                COUNT(id) AS pedidos_hoy
             FROM operaciones.pedidos
             WHERE restaurante_id = $1
               AND estado_cuenta IN ('pagada', 'cerrada')
               AND DATE(fecha_hora) = CURRENT_DATE`, [restaurantId]);
        // 2. Ventas de ayer para variación
        const [ventasAyer] = await database_1.Conexion.query(`SELECT COALESCE(SUM(total), 0) AS total_ayer
             FROM operaciones.pedidos
             WHERE restaurante_id = $1
               AND estado_cuenta IN ('pagada', 'cerrada')
               AND DATE(fecha_hora) = CURRENT_DATE - INTERVAL '1 day'`, [restaurantId]);
        // 3. Top 3 productos más vendidos hoy
        const topProductos = await database_1.Conexion.query(`SELECT r.nombre, SUM(pd.cantidad) AS total_vendido
             FROM operaciones.pedido_detalle pd
             JOIN menu.recetas r ON r.id = pd.receta_id
             JOIN operaciones.pedidos p ON p.id = pd.pedido_id
             WHERE p.restaurante_id = $1
               AND DATE(p.fecha_hora) = CURRENT_DATE
             GROUP BY r.nombre
             ORDER BY total_vendido DESC
             LIMIT 3`, [restaurantId]);
        // 4. Stock crítico: ingredientes bajo el mínimo
        // Columna real: cantidad_minima (no stock_minimo)
        const [stockCritico] = await database_1.Conexion.query(`SELECT COUNT(id) AS cantidad
             FROM inventario.ingredientes
             WHERE restaurante_id = $1
               AND cantidad_disponible <= cantidad_minima`, [restaurantId]);
        // 5. Mermas recientes (últimas 5)
        // Columna real: reportado_por (FK → core.usuarios.id), unidad_id (FK → core.unidad_medida.id)
        const mermas = await database_1.Conexion.query(`SELECT 
                i.nombre AS ingrediente,
                m.cantidad,
                um.abreviatura AS unidad,
                m.razon,
                u.nombre AS reportado_por,
                m.created_at
             FROM inventario.mermas m
             JOIN inventario.ingredientes i ON i.id = m.ingrediente_id
             LEFT JOIN core.unidad_medida um ON um.id = i.unidad_id
             LEFT JOIN core.usuarios u ON u.id = m.reportado_por
             WHERE m.restaurante_id = $1
             ORDER BY m.created_at DESC
             LIMIT 5`, [restaurantId]);
        // 6. Margen de utilidad del día (contabilidad.v_estado_resultados)
        const [contabilidad] = await database_1.Conexion.query(`SELECT 
                COALESCE(SUM(CASE WHEN tipo = 'ingreso' THEN monto ELSE 0 END), 0) AS ingresos,
                COALESCE(SUM(CASE WHEN tipo = 'costo' THEN monto ELSE 0 END), 0) AS costos
             FROM contabilidad.v_estado_resultados
             WHERE restaurante_id = $1
               AND fecha = CURRENT_DATE`, [restaurantId]);
        // 7. Ventas por categoría (hoy)
        const ventasCategoria = await database_1.Conexion.query(`SELECT c.nombre, CAST(COALESCE(SUM(pd.cantidad), 0) AS INTEGER) AS total
             FROM operaciones.pedido_detalle pd
             JOIN menu.recetas r ON r.id = pd.receta_id
             JOIN menu.categorias c ON c.id = r.categoria_id
             JOIN operaciones.pedidos p ON p.id = pd.pedido_id
             WHERE p.restaurante_id = $1
               AND p.estado_cuenta IN ('pagada', 'cerrada')
               AND DATE(p.fecha_hora) = CURRENT_DATE
             GROUP BY c.nombre
             ORDER BY total DESC`, [restaurantId]);
        // 8. Ingresos vs Egresos de los últimos 7 días
        const semanal = await database_1.Conexion.query(`SELECT 
                TO_CHAR(fecha, 'DD/MM') as dia,
                COALESCE(SUM(CASE WHEN tipo = 'ingreso' THEN monto ELSE 0 END), 0) as ingresos,
                COALESCE(SUM(CASE WHEN tipo IN ('costo', 'gasto') THEN monto ELSE 0 END), 0) as egresos
             FROM contabilidad.v_estado_resultados
             WHERE restaurante_id = $1
               AND fecha >= CURRENT_DATE - INTERVAL '6 days'
             GROUP BY fecha
             ORDER BY fecha ASC`, [restaurantId]);
        const totalHoy = parseFloat(ventasHoy.total_hoy);
        const totalAyer = parseFloat(ventasAyer.total_ayer);
        const variacion = totalAyer > 0
            ? (((totalHoy - totalAyer) / totalAyer) * 100).toFixed(1)
            : null;
        const ingresos = parseFloat(contabilidad.ingresos);
        const costos = parseFloat(contabilidad.costos);
        const margen = ingresos > 0
            ? (((ingresos - costos) / ingresos) * 100).toFixed(1)
            : "0.0";
        const totalCategorias = ventasCategoria.reduce((sum, c) => sum + c.total, 0);
        return {
            ventas: {
                total_hoy: totalHoy,
                total_ayer: totalAyer,
                pedidos_hoy: parseInt(ventasHoy.pedidos_hoy),
                variacion_porcentaje: variacion,
            },
            top_productos: topProductos.map((p) => ({
                nombre: p.nombre,
                cantidad: parseInt(p.total_vendido),
            })),
            stock_critico: parseInt(stockCritico.cantidad),
            margen_utilidad: parseFloat(margen),
            mermas_recientes: mermas.map((m) => ({
                ingrediente: m.ingrediente,
                cantidad: `${m.cantidad} ${m.unidad || ''}`.trim(),
                razon: m.razon,
                reportado_por: m.reportado_por || 'Sistema',
                fecha: m.created_at,
            })),
            ventas_por_categoria: ventasCategoria.map((c) => ({
                nombre: c.nombre,
                total: c.total,
                porcentaje: totalCategorias > 0 ? Math.round((c.total / totalCategorias) * 100) : 0
            })),
            ingresos_egresos_semana: semanal.map((s) => ({
                dia: s.dia,
                ingresos: parseFloat(s.ingresos),
                egresos: parseFloat(s.egresos)
            }))
        };
    }
    /** Pedidos activos para el KDS de cocina */
    static async getKitchenOrders(restaurantId) {
        return database_1.Conexion.query(`SELECT 
                p.id, p.codigo, p.estado, p.fecha_hora,
                m.numero AS mesa_numero, m.nombre AS mesa_nombre,
                json_agg(
                    json_build_object(
                        'nombre', r.nombre,
                        'cantidad', pd.cantidad,
                        'notas', pd.notas
                    ) ORDER BY pd.id
                ) AS items
             FROM operaciones.pedidos p
             LEFT JOIN operaciones.mesas m ON m.id = p.mesa_id
             LEFT JOIN operaciones.pedido_detalle pd ON pd.pedido_id = p.id
             LEFT JOIN menu.recetas r ON r.id = pd.receta_id
             WHERE p.restaurante_id = $1
               AND p.estado IN ('pendiente', 'preparando', 'listo')
             GROUP BY p.id, m.numero, m.nombre
             ORDER BY 
               CASE p.estado WHEN 'pendiente' THEN 0 WHEN 'preparando' THEN 1 ELSE 2 END,
               p.fecha_hora ASC`, [restaurantId]);
    }
    /** Mesas con bandera pedido_listo para el mesero */
    static async getWaiterTables(restaurantId) {
        return database_1.Conexion.query(`SELECT 
                m.id, m.numero, m.nombre, m.capacidad, m.estado,
                EXISTS(
                    SELECT 1 FROM operaciones.pedidos p
                    WHERE p.mesa_id = m.id
                      AND p.restaurante_id = $1
                      AND p.estado = 'listo'
                      AND p.estado_cuenta = 'abierta'
                ) AS pedido_listo
             FROM operaciones.mesas m
             WHERE m.restaurante_id = $1
             ORDER BY m.numero ASC`, [restaurantId]);
    }
    /** KPIs del mesero */
    static async getWaiterStats(restaurantId) {
        const [stats] = await database_1.Conexion.query(`SELECT
                COUNT(CASE WHEN estado IN ('pendiente','preparando','listo') AND estado_cuenta = 'abierta' THEN 1 END) AS pedidos_activos,
                COUNT(CASE WHEN estado = 'listo' AND estado_cuenta = 'abierta' THEN 1 END) AS listos_entregar,
                COALESCE(SUM(CASE WHEN estado_cuenta = 'pagada' AND DATE(fecha_hora) = CURRENT_DATE THEN total ELSE 0 END), 0) AS ventas_turno
             FROM operaciones.pedidos
             WHERE restaurante_id = $1`, [restaurantId]);
        const [mesasLibres] = await database_1.Conexion.query(`SELECT COUNT(id) AS libres 
             FROM operaciones.mesas 
             WHERE restaurante_id = $1 AND estado = 'libre'`, [restaurantId]);
        return {
            pedidos_activos: parseInt(stats.pedidos_activos),
            listos_entregar: parseInt(stats.listos_entregar),
            ventas_turno: parseFloat(stats.ventas_turno),
            mesas_libres: parseInt(mesasLibres.libres),
        };
    }
}
exports.DashboardService = DashboardService;

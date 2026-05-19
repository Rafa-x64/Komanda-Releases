"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.InventoryService = void 0;
const database_1 = require("../../config/database");
const inventory_model_1 = require("./inventory.model");
const merma_entity_1 = require("./domain/merma.entity");
const accounting_service_1 = require("../accounting/accounting.service");
class InventoryService {
    repository = database_1.Conexion.getRepository(inventory_model_1.Ingrediente);
    // 1. Obtener inventario con unidad
    async getAllByRestaurant(restauranteId) {
        return await database_1.Conexion.query(`SELECT 
        ingrediente.id AS id,
        ingrediente.nombre AS nombre,
        ingrediente.unidad_id AS unidad_id,
        ingrediente.cantidad_disponible AS cantidad_disponible,
        ingrediente.cantidad_minima AS cantidad_minima,
        ingrediente.costo_promedio AS costo_promedio,
        unidad.abreviatura AS unidad_nombre,
        unidad.abreviatura AS unidad_abrev
       FROM inventario.ingredientes ingrediente
       LEFT JOIN core.unidad_medida unidad ON unidad.id = ingrediente.unidad_id
       WHERE ingrediente.restaurante_id = $1
       ORDER BY ingrediente.nombre ASC`, [restauranteId]);
    }
    // 1.5. Crear nuevo ingrediente
    async createIngredient(data, restauranteId) {
        const ingrediente = this.repository.create({
            ...data,
            restaurante_id: restauranteId,
        });
        await this.repository.save(ingrediente);
        return ingrediente;
    }
    // 2. Actualizar ingrediente (ajustes básicos)
    async updateIngredient(id, data, restauranteId) {
        const ingrediente = await this.repository.findOne({ where: { id, restaurante_id: restauranteId } });
        if (!ingrediente)
            throw new Error("Ingrediente no encontrado");
        Object.assign(ingrediente, data);
        await this.repository.save(ingrediente);
        return ingrediente;
    }
    // 3. Obtener Mermas
    async getMermas(restauranteId) {
        return await database_1.Conexion.query(`SELECT 
        merma.id AS id,
        merma.cantidad AS cantidad,
        merma.tipo AS tipo,
        merma.razon AS razon,
        merma.created_at AS created_at,
        ingrediente.nombre AS ingrediente_nombre,
        ingrediente.costo_promedio AS costo_promedio
       FROM inventario.mermas merma
       INNER JOIN inventario.ingredientes ingrediente ON ingrediente.id = merma.ingrediente_id
       WHERE merma.restaurante_id = $1
       ORDER BY merma.created_at DESC`, [restauranteId]);
    }
    // 4. Crear Merma (Ajuste Negativo) con asiento contable
    async createMerma(data, restauranteId, userId) {
        const queryRunner = database_1.Conexion.createQueryRunner();
        await queryRunner.connect();
        await queryRunner.startTransaction();
        try {
            const ingrediente = await queryRunner.manager.findOne(inventory_model_1.Ingrediente, {
                where: { id: data.ingrediente_id, restaurante_id: restauranteId }
            });
            if (!ingrediente)
                throw new Error("Ingrediente no encontrado");
            const stockActual = Number(ingrediente.cantidad_disponible);
            const cantidadMerma = Number(data.cantidad);
            if (stockActual < cantidadMerma) {
                throw new Error(`Stock insuficiente. Solo hay ${stockActual} disponible.`);
            }
            // Restar stock
            ingrediente.cantidad_disponible = stockActual - cantidadMerma;
            await queryRunner.manager.save(ingrediente);
            // Crear registro de Merma
            const mermaRepo = queryRunner.manager.getRepository(merma_entity_1.Merma);
            const merma = mermaRepo.create({
                ...data,
                reportado_por: userId,
                restaurante_id: restauranteId
            });
            await mermaRepo.save(merma);
            // Crear Asiento Contable (Opcional pero recomendado para robustez)
            // DEBE: Pérdida por Merma | HABER: Inventario de Insumos
            const costoTotalMerma = cantidadMerma * Number(ingrediente.costo_promedio);
            if (costoTotalMerma > 0) {
                const fechaActual = new Date().toISOString().slice(0, 10);
                let [cuentaInventario] = await queryRunner.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE codigo = '1.1.03' LIMIT 1`);
                if (!cuentaInventario)
                    [cuentaInventario] = await queryRunner.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE nombre ILIKE '%inventario%' LIMIT 1`);
                let [cuentaGasto] = await queryRunner.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE tipo = 'gasto' AND es_auxiliar = true LIMIT 1`);
                if (!cuentaGasto)
                    [cuentaGasto] = await queryRunner.manager.query(`SELECT id FROM contabilidad.plan_cuentas WHERE tipo = 'gasto' LIMIT 1`);
                if (!cuentaInventario || !cuentaGasto) {
                    throw new Error("No se encontraron las cuentas contables (Inventario o Gasto) para registrar la merma.");
                }
                await accounting_service_1.AccountingService.registrarAsientoContable(fechaActual, `Merma (${data.tipo}): ${ingrediente.nombre}`, 'ajuste_inventario', [
                    { cuenta_id: cuentaGasto.id, tipo_movimiento: 'debe', monto: costoTotalMerma, descripcion: 'Pérdida por Merma' },
                    { cuenta_id: cuentaInventario.id, tipo_movimiento: 'haber', monto: costoTotalMerma, descripcion: 'Salida de Inventario' }
                ], restauranteId, merma.id, userId, queryRunner);
            }
            await queryRunner.commitTransaction();
            return { success: true, message: "Merma registrada y stock actualizado", data: merma };
        }
        catch (error) {
            await queryRunner.rollbackTransaction();
            throw error;
        }
        finally {
            await queryRunner.release();
        }
    }
}
exports.InventoryService = InventoryService;

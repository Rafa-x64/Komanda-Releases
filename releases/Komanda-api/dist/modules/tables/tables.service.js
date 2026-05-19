"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TablesService = void 0;
const database_1 = require("../../config/database");
const mesa_entity_1 = require("../pos/domain/mesa.entity");
class TablesService {
    static async getTables(restaurantId) {
        return database_1.Conexion.getRepository(mesa_entity_1.Mesa).find({
            where: { restaurante_id: restaurantId },
            order: { numero: 'ASC' }
        });
    }
    static async getTableById(restaurantId, tableId) {
        return database_1.Conexion.getRepository(mesa_entity_1.Mesa).findOne({
            where: { id: tableId, restaurante_id: restaurantId }
        });
    }
    static async createTable(restaurantId, data) {
        const repo = database_1.Conexion.getRepository(mesa_entity_1.Mesa);
        // Verificar que el número de mesa no exista ya en este restaurante
        const existing = await repo.findOne({
            where: { numero: data.numero, restaurante_id: restaurantId }
        });
        if (existing) {
            throw new Error(`La mesa número ${data.numero} ya existe en este restaurante.`);
        }
        const newTable = repo.create({
            ...data,
            restaurante_id: restaurantId
        });
        return await repo.save(newTable);
    }
    static async updateTable(restaurantId, tableId, data) {
        const repo = database_1.Conexion.getRepository(mesa_entity_1.Mesa);
        const table = await repo.findOne({
            where: { id: tableId, restaurante_id: restaurantId }
        });
        if (!table) {
            throw new Error('Mesa no encontrada');
        }
        // Si cambia el número, verificar que no colisione
        if (data.numero && data.numero !== table.numero) {
            const existing = await repo.findOne({
                where: { numero: data.numero, restaurante_id: restaurantId }
            });
            if (existing) {
                throw new Error(`La mesa número ${data.numero} ya existe en este restaurante.`);
            }
        }
        repo.merge(table, data);
        return await repo.save(table);
    }
    static async deleteTable(restaurantId, tableId) {
        const repo = database_1.Conexion.getRepository(mesa_entity_1.Mesa);
        const table = await repo.findOne({
            where: { id: tableId, restaurante_id: restaurantId }
        });
        if (!table) {
            throw new Error('Mesa no encontrada');
        }
        // Desvincular pedidos históricos para poder eliminar la mesa
        await database_1.Conexion.query('UPDATE operaciones.pedidos SET mesa_id = NULL WHERE mesa_id = $1', [tableId]);
        await repo.remove(table);
    }
}
exports.TablesService = TablesService;

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WarehouseService = void 0;
const database_1 = require("../../config/database");
const inventory_model_1 = require("../inventory/inventory.model");
class WarehouseService {
    repo = database_1.Conexion.getRepository(inventory_model_1.Ingrediente);
    async getAll(restauranteId) {
        const rows = await database_1.Conexion.query(`SELECT
        i.id,
        i.nombre,
        i.cantidad_disponible,
        i.cantidad_minima,
        i.costo_promedio,
        i.merma_teorica_porcentaje,
        i.unidad_id,
        u.abreviatura AS unidad_nombre,
        (i.cantidad_disponible <= i.cantidad_minima) AS alerta_critica
       FROM inventario.ingredientes i
       LEFT JOIN core.unidad_medida u ON u.id = i.unidad_id
       WHERE i.restaurante_id = $1
       ORDER BY i.nombre ASC`, [restauranteId]);
        return rows;
    }
    async getUnidades() {
        return database_1.Conexion.query(`SELECT id, nombre, abreviatura FROM core.unidad_medida ORDER BY nombre ASC`);
    }
    async create(data, restauranteId) {
        const existe = await this.repo.createQueryBuilder("i")
            .where("LOWER(i.nombre) = LOWER(:nombre)", { nombre: data.nombre })
            .andWhere("i.restaurante_id = :restauranteId", { restauranteId })
            .getOne();
        if (existe)
            throw new Error(`Ya existe un ingrediente llamado "${data.nombre}"`);
        const nuevo = this.repo.create({
            nombre: data.nombre,
            unidad_id: data.unidad_id,
            cantidad_minima: data.cantidad_minima,
            merma_teorica_porcentaje: data.merma_teorica_porcentaje,
            cantidad_disponible: data.cantidad_disponible ?? 0,
            costo_promedio: data.costo_promedio ?? 0,
            restaurante_id: restauranteId,
        });
        return await this.repo.save(nuevo);
    }
    async update(id, data, restauranteId) {
        const ingrediente = await this.repo.findOne({ where: { id, restaurante_id: restauranteId } });
        if (!ingrediente)
            throw new Error("Ingrediente no encontrado");
        if (data.nombre && data.nombre.toLowerCase() !== ingrediente.nombre.toLowerCase()) {
            const existe = await this.repo.createQueryBuilder("i")
                .where("LOWER(i.nombre) = LOWER(:nombre)", { nombre: data.nombre })
                .andWhere("i.restaurante_id = :restauranteId", { restauranteId })
                .andWhere("i.id != :id", { id })
                .getOne();
            if (existe) {
                throw new Error(`Ya existe otro ingrediente con el nombre "${data.nombre}"`);
            }
        }
        Object.assign(ingrediente, data);
        return await this.repo.save(ingrediente);
    }
    async delete(id, restauranteId) {
        const ingrediente = await this.repo.findOne({ where: { id, restaurante_id: restauranteId } });
        if (!ingrediente)
            throw new Error("Ingrediente no encontrado");
        // Eliminar dependencias primero para evitar error de foreign key
        await database_1.Conexion.query(`DELETE FROM inventario.compra_detalle WHERE ingrediente_id = $1`, [id]);
        await database_1.Conexion.query(`DELETE FROM inventario.mermas WHERE ingrediente_id = $1`, [id]);
        await this.repo.remove(ingrediente);
        return true;
    }
}
exports.WarehouseService = WarehouseService;

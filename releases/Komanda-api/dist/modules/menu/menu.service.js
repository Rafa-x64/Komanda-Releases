"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MenuService = void 0;
const database_1 = require("../../config/database");
const receta_entity_1 = require("../pos/domain/receta.entity");
const categoria_entity_1 = require("../pos/domain/categoria.entity");
exports.MenuService = {
    async getRecipes(restaurantId) {
        const recipes = await database_1.Conexion.getRepository(receta_entity_1.Receta).find({
            where: { restaurante_id: restaurantId },
            order: { nombre: "ASC" },
        });
        for (const recipe of recipes) {
            const ingredients = await database_1.Conexion.query(`SELECT ri.id, ri.ingrediente_id, ri.cantidad, i.nombre as nombre_ingrediente, u.abreviatura as unidad
                 FROM menu.receta_ingredientes ri
                 JOIN inventario.ingredientes i ON i.id = ri.ingrediente_id
                 LEFT JOIN core.unidad_medida u ON u.id = i.unidad_id
                 WHERE ri.receta_id = $1`, [recipe.id]);
            recipe.ingredientes = ingredients;
        }
        return recipes;
    },
    async getCategories(restaurantId) {
        return database_1.Conexion.getRepository(categoria_entity_1.Categoria).find({
            where: { restaurante_id: restaurantId },
            order: { orden: "ASC", nombre: "ASC" },
        });
    },
    async createRecipe(data, restaurantId) {
        const repo = database_1.Conexion.getRepository(receta_entity_1.Receta);
        const newRecipe = repo.create({
            ...data,
            restaurante_id: restaurantId,
            precio_venta: data.precio_venta || 0
        });
        const saved = await repo.save(newRecipe);
        if (data.ingredientes && data.ingredientes.length > 0) {
            for (const ing of data.ingredientes) {
                await database_1.Conexion.query(`INSERT INTO menu.receta_ingredientes (receta_id, ingrediente_id, cantidad, restaurante_id) VALUES ($1, $2, $3, $4)`, [saved.id, ing.ingrediente_id, ing.cantidad, restaurantId]);
            }
        }
        saved.ingredientes = data.ingredientes;
        return saved;
    },
    async updateRecipe(id, data, restaurantId) {
        const repo = database_1.Conexion.getRepository(receta_entity_1.Receta);
        const recipe = await repo.findOne({ where: { id, restaurante_id: restaurantId } });
        if (!recipe)
            throw new Error("Receta no encontrada");
        Object.assign(recipe, data);
        const saved = await repo.save(recipe);
        if (data.ingredientes) {
            await database_1.Conexion.query(`DELETE FROM menu.receta_ingredientes WHERE receta_id = $1`, [id]);
            for (const ing of data.ingredientes) {
                await database_1.Conexion.query(`INSERT INTO menu.receta_ingredientes (receta_id, ingrediente_id, cantidad, restaurante_id) VALUES ($1, $2, $3, $4)`, [id, ing.ingrediente_id, ing.cantidad, restaurantId]);
            }
            saved.ingredientes = data.ingredientes;
        }
        return saved;
    },
    async deleteRecipe(id, restaurantId) {
        const repo = database_1.Conexion.getRepository(receta_entity_1.Receta);
        const recipe = await repo.findOne({ where: { id, restaurante_id: restaurantId } });
        if (!recipe)
            throw new Error("Receta no encontrada");
        await database_1.Conexion.query(`DELETE FROM menu.receta_ingredientes WHERE receta_id = $1`, [id]);
        await repo.remove(recipe);
        return true;
    },
    async createCategory(data, restaurantId) {
        const repo = database_1.Conexion.getRepository(categoria_entity_1.Categoria);
        const maxCat = await repo.findOne({ where: { restaurante_id: restaurantId }, order: { orden: "DESC" } });
        const nextOrder = maxCat ? maxCat.orden + 1 : 1;
        const newCat = repo.create({
            ...data,
            orden: nextOrder,
            restaurante_id: restaurantId,
            activo: true
        });
        return repo.save(newCat);
    }
};

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateCategorySchema = exports.UpdateRecipeSchema = exports.CreateRecipeSchema = exports.RecipeIngredientSchema = void 0;
const zod_1 = require("zod");
exports.RecipeIngredientSchema = zod_1.z.object({
    ingrediente_id: zod_1.z.coerce.number().int().positive(),
    cantidad: zod_1.z.coerce.number().positive(),
    unidad: zod_1.z.string().optional()
});
exports.CreateRecipeSchema = zod_1.z.object({
    nombre: zod_1.z.string().min(2, "Nombre muy corto"),
    descripcion: zod_1.z.string().optional(),
    categoria_id: zod_1.z.coerce.number().nullable().optional(),
    imagen_url: zod_1.z.string().optional(),
    precio_venta: zod_1.z.coerce.number().min(0),
    precio_sugerido: zod_1.z.coerce.number().min(0).optional(),
    costo_produccion: zod_1.z.coerce.number().min(0).optional(),
    margen_utilidad: zod_1.z.coerce.number().optional(),
    activo: zod_1.z.boolean().default(true),
    ingredientes: zod_1.z.array(exports.RecipeIngredientSchema).optional().default([]),
});
exports.UpdateRecipeSchema = exports.CreateRecipeSchema.partial();
exports.CreateCategorySchema = zod_1.z.object({
    nombre: zod_1.z.string().min(2)
});

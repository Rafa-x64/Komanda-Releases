"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.StockAdjustmentSchema = exports.CreateIngredientSchema = void 0;
const zod_1 = require("zod");
exports.CreateIngredientSchema = zod_1.z.object({
    nombre: zod_1.z.string().trim().min(2, "El nombre debe tener al menos 2 caracteres").max(100),
    unidad_id: zod_1.z.coerce.number().int().positive("La unidad de medida es requerida"),
    cantidad_minima: zod_1.z.coerce.number().min(0, "El stock mínimo no puede ser negativo").default(0),
    merma_teorica_porcentaje: zod_1.z.coerce.number().min(0).max(100, "El porcentaje no puede superar 100").default(0),
    cantidad_disponible: zod_1.z.coerce.number().min(0).optional().default(0),
    costo_promedio: zod_1.z.coerce.number().min(0).optional().default(0),
});
exports.StockAdjustmentSchema = zod_1.z.object({
    nombre: zod_1.z.string().trim().min(2).max(100).optional(),
    unidad_id: zod_1.z.coerce.number().int().positive().optional(),
    cantidad_minima: zod_1.z.coerce.number().min(0).optional(),
    merma_teorica_porcentaje: zod_1.z.coerce.number().min(0).max(100).optional(),
    cantidad_disponible: zod_1.z.coerce.number().min(0).optional(),
    costo_promedio: zod_1.z.coerce.number().min(0).optional(),
});

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createMermaSchema = exports.createIngredientSchema = exports.updateIngredientSchema = void 0;
const zod_1 = require("zod");
exports.updateIngredientSchema = zod_1.z.object({
    nombre: zod_1.z.string().min(2, "Nombre requerido").max(100).optional(),
    cantidad_minima: zod_1.z.number().min(0, "La cantidad mínima no puede ser negativa").optional(),
    merma_teorica_porcentaje: zod_1.z.number().min(0).max(100, "El porcentaje no puede superar 100").optional(),
});
exports.createIngredientSchema = zod_1.z.object({
    nombre: zod_1.z.string().min(2, "Nombre requerido").max(100),
    cantidad_minima: zod_1.z.number().min(0, "La cantidad mínima no puede ser negativa").default(0),
    cantidad_disponible: zod_1.z.number().min(0, "La cantidad disponible no puede ser negativa").default(0),
    unidad_id: zod_1.z.number().int().positive().default(1),
    costo_promedio: zod_1.z.number().nonnegative().default(0),
    merma_teorica_porcentaje: zod_1.z.number().min(0).max(100).default(0),
    unidades_por_paquete: zod_1.z.number().positive().default(1),
});
exports.createMermaSchema = zod_1.z.object({
    ingrediente_id: zod_1.z.number().int().positive("ID de ingrediente inválido"),
    cantidad: zod_1.z.number().positive("La cantidad debe ser mayor a 0"),
    tipo: zod_1.z.enum(["desperdicio", "vencimiento", "rotura", "otro"], {
        message: "Tipo de merma no válido"
    }),
    razon: zod_1.z.string().min(3, "Debe especificar una razón").max(255).optional().nullable(),
});

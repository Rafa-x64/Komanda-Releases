"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateProfileSchema = exports.updateRestaurantSchema = void 0;
const zod_1 = require("zod");
exports.updateRestaurantSchema = zod_1.z.object({
    nombre: zod_1.z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
    direccion: zod_1.z.string().optional(),
    telefono: zod_1.z.string().optional(),
    email: zod_1.z.string().email("Correo inválido").optional().or(zod_1.z.literal("")),
    moneda: zod_1.z.string().length(3, "La moneda debe ser 3 caracteres (ej. USD, VES)").optional(),
    impuesto_porcentaje: zod_1.z.number().min(0, "El impuesto no puede ser menor a 0").optional(),
});
exports.updateProfileSchema = zod_1.z.object({
    nombre: zod_1.z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
    email: zod_1.z.string().email("Correo inválido"),
    password: zod_1.z.string().min(6, "La contraseña debe tener mínimo 6 caracteres").optional().or(zod_1.z.literal("")),
});

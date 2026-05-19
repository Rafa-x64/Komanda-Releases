"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateTableSchema = exports.createTableSchema = void 0;
const zod_1 = require("zod");
exports.createTableSchema = zod_1.z.object({
    numero: zod_1.z.number().int().positive("El número de mesa debe ser un entero positivo"),
    nombre: zod_1.z.string().max(50, "El nombre no puede exceder los 50 caracteres").optional().nullable(),
    capacidad: zod_1.z.number().int().positive("La capacidad debe ser mayor a 0"),
    estado: zod_1.z.enum(["libre", "ocupada", "reservada", "inactiva"]).default("libre")
});
exports.updateTableSchema = zod_1.z.object({
    numero: zod_1.z.number().int().positive("El número de mesa debe ser un entero positivo").optional(),
    nombre: zod_1.z.string().max(50, "El nombre no puede exceder los 50 caracteres").optional().nullable(),
    capacidad: zod_1.z.number().int().positive("La capacidad debe ser mayor a 0").optional(),
    estado: zod_1.z.enum(["libre", "ocupada", "reservada", "inactiva"]).optional()
});

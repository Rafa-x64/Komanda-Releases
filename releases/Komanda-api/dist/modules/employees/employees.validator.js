"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateEmployeeSchema = exports.CreateEmployeeSchema = void 0;
const zod_1 = require("zod");
exports.CreateEmployeeSchema = zod_1.z.object({
    nombre: zod_1.z.string().min(2, "Nombre muy corto").max(100),
    email: zod_1.z.string().email("Correo no válido"),
    username: zod_1.z.string().min(3, "Username muy corto").max(50),
    password: zod_1.z.string().min(6, "Contraseña mínimo 6 caracteres"),
    rol_id: zod_1.z.number().int().positive("Debe seleccionar un rol"),
});
exports.UpdateEmployeeSchema = zod_1.z.object({
    nombre: zod_1.z.string().min(2).max(100).optional(),
    email: zod_1.z.string().email().optional(),
    username: zod_1.z.string().min(3).max(50).optional(),
    password: zod_1.z.string().min(6).optional(),
    rol_id: zod_1.z.number().int().positive().optional(),
    activo: zod_1.z.boolean().optional(),
});

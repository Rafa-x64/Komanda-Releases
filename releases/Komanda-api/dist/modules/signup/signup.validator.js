"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.signupSchema = void 0;
const zod_1 = require("zod");
exports.signupSchema = zod_1.z.object({
    restaurant: zod_1.z.object({
        name: zod_1.z.string().min(2, "Nombre del restaurante muy corto"),
        phone: zod_1.z.string().optional(),
        address: zod_1.z.string().optional(),
        email: zod_1.z.string().email("Correo del restaurante no válido").optional().or(zod_1.z.literal("")),
        currency: zod_1.z.string().default("USD"),
        zone: zod_1.z.string().default("America/Caracas"),
        tax: zod_1.z.coerce.string().optional(), // input type="number" manda number, lo convertimos a string
        tip: zod_1.z.coerce.string().optional(), // input type="number" manda number, lo convertimos a string
        restaurantLogo: zod_1.z.string().optional(),
    }),
    admin: zod_1.z.object({
        name: zod_1.z.string().min(2, "Nombre del administrador muy corto"),
        userName: zod_1.z.string().min(3, "El nombre de usuario debe tener al menos 3 caracteres"),
        email: zod_1.z.string().email("Correo del administrador no válido"),
        password: zod_1.z.string().min(6, "La contraseña debe tener al menos 6 caracteres"),
        confirmPassword: zod_1.z.string(),
    }),
}).refine((data) => data.admin.password === data.admin.confirmPassword, {
    message: "Las contraseñas no coinciden",
    path: ["admin", "confirmPassword"],
});

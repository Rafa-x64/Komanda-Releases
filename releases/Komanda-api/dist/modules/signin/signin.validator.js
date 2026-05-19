"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SignInSchema = void 0;
const zod_1 = require("zod");
exports.SignInSchema = zod_1.z.object({
    username: zod_1.z.string().min(3, "El nombre de usuario debe tener al menos 3 caracteres"),
    password: zod_1.z.string().min(3, "La contraseña debe tener al menos 3 caracteres"),
    restaurantName: zod_1.z.string().min(3, "El nombre del restaurante debe tener al menos 3 caracteres"),
});

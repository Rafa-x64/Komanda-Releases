"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SignInController = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const signin_validator_1 = require("./signin.validator");
const signin_service_1 = require("./signin.service");
const auth_middleware_1 = require("../../shared/middleware/auth.middleware");
exports.SignInController = {
    async login(req, res) {
        const parsed = signin_validator_1.SignInSchema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({
                status: "error",
                message: "Datos inválidos",
                errors: parsed.error.flatten().fieldErrors,
            });
        }
        try {
            const { user, restaurant } = await (0, signin_service_1.SignInService)(parsed.data);
            // Generar JWT (expira en 8 horas — un turno de trabajo)
            const token = jsonwebtoken_1.default.sign({ userId: user.id, restaurantId: restaurant.id, role: user.role }, auth_middleware_1.JWT_SECRET, { expiresIn: "8h" });
            return res.status(200).json({
                status: "success",
                message: "Inicio de sesión exitoso",
                data: {
                    token,
                    user: {
                        id: user.id,
                        nombre: user.nombre,
                        username: user.username,
                        email: user.email,
                        role: user.role,
                    },
                    restaurant: {
                        id: restaurant.id,
                        nombre: restaurant.nombre,
                    },
                },
            });
        }
        catch (error) {
            console.error("❌ Error en login:", error);
            const message = error instanceof Error ? error.message : "Error al iniciar sesión";
            return res.status(401).json({ status: "error", message });
        }
    },
};

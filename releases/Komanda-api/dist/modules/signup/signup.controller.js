"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SignupController = void 0;
const signup_validator_1 = require("./signup.validator");
const signup_service_1 = require("./signup.service");
exports.SignupController = {
    async register(req, res) {
        try {
            // 1. Validar entrada con Zod
            const parseResult = signup_validator_1.signupSchema.safeParse(req.body);
            if (!parseResult.success) {
                const errors = parseResult.error.issues.map((e) => e.message);
                return res.status(400).json({
                    status: "error",
                    message: "Datos inválidos",
                    errors,
                });
            }
            // 2. Delegar al servicio
            const result = await signup_service_1.SignupService.register(parseResult.data);
            // 3. Responder éxito
            return res.status(201).json({
                status: "success",
                data: result,
            });
        }
        catch (error) {
            console.error("❌ Error en signup:", error);
            const message = error instanceof Error ? error.message : "Error al registrar";
            return res.status(400).json({
                status: "error",
                message,
            });
        }
    },
};

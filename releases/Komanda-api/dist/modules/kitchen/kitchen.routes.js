"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.kitchenRouter = void 0;
const express_1 = require("express");
const kitchen_controller_1 = require("./kitchen.controller");
const auth_middleware_1 = require("../../shared/middleware/auth.middleware");
exports.kitchenRouter = (0, express_1.Router)();
// Middleware de autenticación global para este router
exports.kitchenRouter.use(auth_middleware_1.authMiddleware);
// Solo usuarios con rol admin o cocina pueden ver la pantalla de KDS 
// Opcionalmente los cajeros si se requiere, pero por enunciado la cocina es para rol 'cocina' o 'admin'
exports.kitchenRouter.get("/", (0, auth_middleware_1.requireRole)('admin', 'cocina'), kitchen_controller_1.getActiveOrders);
// Endpoint para actualizar estado
exports.kitchenRouter.put("/:id/status", (0, auth_middleware_1.requireRole)('admin', 'cocina'), kitchen_controller_1.updateOrderStatus);

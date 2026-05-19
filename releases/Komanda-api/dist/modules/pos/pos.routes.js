"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.posRouter = void 0;
const express_1 = require("express");
const pos_controller_1 = require("./pos.controller");
const auth_middleware_1 = require("../../shared/middleware/auth.middleware");
exports.posRouter = (0, express_1.Router)();
// Todas las rutas de POS requieren autenticación (y proveen userId y restaurantId)
exports.posRouter.use(auth_middleware_1.authMiddleware);
// Catálogos e información
exports.posRouter.get("/categories", pos_controller_1.POSController.getCategories);
exports.posRouter.get("/products", pos_controller_1.POSController.getProducts);
exports.posRouter.get("/tables", pos_controller_1.POSController.getTables);
exports.posRouter.get("/payment-methods", pos_controller_1.POSController.getPaymentMethods);
// Operaciones principales POS
exports.posRouter.get("/sales", pos_controller_1.POSController.getSales);
exports.posRouter.post("/sales", pos_controller_1.POSController.createSale);
exports.posRouter.post("/cash-closures", pos_controller_1.POSController.closeCashRegister);
// Gestión de pedidos activos (mesero + admin)
exports.posRouter.get("/orders", pos_controller_1.POSController.getActiveOrders);
exports.posRouter.patch("/orders/:id/status", pos_controller_1.POSController.updateOrderStatus);
// Cola del cajero y checkout
exports.posRouter.get("/ready-orders", pos_controller_1.POSController.getReadyOrders);
exports.posRouter.post("/orders/:id/checkout", pos_controller_1.POSController.checkoutOrder);
exports.posRouter.get("/cash-report", pos_controller_1.POSController.getCashReport);

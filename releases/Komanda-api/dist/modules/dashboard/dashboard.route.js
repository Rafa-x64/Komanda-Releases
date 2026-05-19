"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.dashboardRouter = void 0;
const express_1 = require("express");
const dashboard_controller_1 = require("./dashboard.controller");
const auth_middleware_1 = require("../../shared/middleware/auth.middleware");
exports.dashboardRouter = (0, express_1.Router)();
exports.dashboardRouter.use(auth_middleware_1.authMiddleware);
// Admin
exports.dashboardRouter.get("/admin/stats", (0, auth_middleware_1.requireRole)("admin"), dashboard_controller_1.DashboardController.adminStats);
// Cocina (KDS)
exports.dashboardRouter.get("/kitchen/orders", (0, auth_middleware_1.requireRole)("admin", "cocina"), dashboard_controller_1.DashboardController.kitchenOrders);
// Mesero
exports.dashboardRouter.get("/waiter/tables", (0, auth_middleware_1.requireRole)("admin", "mesero"), dashboard_controller_1.DashboardController.waiterTables);
exports.dashboardRouter.get("/waiter/stats", (0, auth_middleware_1.requireRole)("admin", "mesero"), dashboard_controller_1.DashboardController.waiterStats);

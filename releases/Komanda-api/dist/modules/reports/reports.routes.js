"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.reportsRouter = void 0;
const express_1 = require("express");
const reports_controller_1 = require("./reports.controller");
const auth_middleware_1 = require("../../shared/middleware/auth.middleware");
exports.reportsRouter = (0, express_1.Router)();
// Todas las rutas de reportes requieren auth + rol admin
exports.reportsRouter.use(auth_middleware_1.authMiddleware, (0, auth_middleware_1.requireRole)("admin"));
exports.reportsRouter.get("/overview", reports_controller_1.ReportsController.getOverview);
exports.reportsRouter.get("/", reports_controller_1.ReportsController.getReport);

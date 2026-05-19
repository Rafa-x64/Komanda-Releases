"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.employeesRouter = void 0;
const express_1 = require("express");
const employees_controller_1 = require("./employees.controller");
const auth_middleware_1 = require("../../shared/middleware/auth.middleware");
exports.employeesRouter = (0, express_1.Router)();
exports.employeesRouter.get("/seed-roles", employees_controller_1.EmployeesController.seedRoles);
// Todas las rutas de empleados requieren auth + rol admin
exports.employeesRouter.use(auth_middleware_1.authMiddleware, (0, auth_middleware_1.requireRole)("admin"));
exports.employeesRouter.get("/", employees_controller_1.EmployeesController.list);
exports.employeesRouter.get("/roles", employees_controller_1.EmployeesController.getRoles);
exports.employeesRouter.post("/", employees_controller_1.EmployeesController.create);
exports.employeesRouter.put("/:id", employees_controller_1.EmployeesController.update);
exports.employeesRouter.delete("/:id", employees_controller_1.EmployeesController.remove);

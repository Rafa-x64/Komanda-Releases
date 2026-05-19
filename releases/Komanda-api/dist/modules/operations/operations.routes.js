"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const operations_controller_1 = require("./operations.controller");
const auth_middleware_1 = require("../../shared/middleware/auth.middleware");
const router = (0, express_1.Router)();
// Todo el módulo de gestión requiere autenticación y rol de admin o cajero
router.use(auth_middleware_1.authMiddleware);
router.use((0, auth_middleware_1.requireRole)("admin", "cajero"));
// Proveedores
router.get("/proveedores", operations_controller_1.OperationsController.getProveedores);
router.post("/proveedores", operations_controller_1.OperationsController.createProveedor);
router.put("/proveedores/:id", operations_controller_1.OperationsController.updateProveedor);
// Unidades de compra (lookup)
router.get("/unidades-compra", operations_controller_1.OperationsController.getUnidadesCompra);
// Gastos Operativos
router.get("/gastos", operations_controller_1.OperationsController.getGastos);
router.post("/gastos", operations_controller_1.OperationsController.createGasto);
// Compras e Inventario
router.get("/compras", operations_controller_1.OperationsController.getCompras);
router.post("/compras", operations_controller_1.OperationsController.createCompra);
// Seed (desarrollo/pruebas)
router.post("/seed", operations_controller_1.OperationsController.seedOperationsData);
exports.default = router;

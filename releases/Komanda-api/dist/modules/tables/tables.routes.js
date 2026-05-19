"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const tables_controller_1 = require("./tables.controller");
const auth_middleware_1 = require("../../shared/middleware/auth.middleware");
const router = (0, express_1.Router)();
// Todas las rutas requieren autenticación
router.use(auth_middleware_1.authMiddleware);
// Listar mesas (disponible para admin, mesero, cajero, cocina)
router.get("/", (0, auth_middleware_1.requireRole)("admin", "mesero", "cajero", "cocina"), tables_controller_1.TablesController.getAll);
// Obtener una mesa específica
router.get("/:id", (0, auth_middleware_1.requireRole)("admin", "mesero", "cajero"), tables_controller_1.TablesController.getById);
// Rutas de administración (Crear, Editar, Eliminar)
router.post("/", (0, auth_middleware_1.requireRole)("admin"), tables_controller_1.TablesController.create);
router.put("/:id", (0, auth_middleware_1.requireRole)("admin", "mesero", "cajero"), tables_controller_1.TablesController.update); // Mesero puede actualizar estado
router.delete("/:id", (0, auth_middleware_1.requireRole)("admin"), tables_controller_1.TablesController.delete);
exports.default = router;

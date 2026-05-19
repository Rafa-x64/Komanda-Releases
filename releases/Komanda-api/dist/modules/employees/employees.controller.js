"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.EmployeesController = void 0;
const employees_validator_1 = require("./employees.validator");
const employees_service_1 = require("./employees.service");
exports.EmployeesController = {
    async list(req, res) {
        try {
            const data = await employees_service_1.EmployeesService.list(req.user.restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error al listar empleados";
            return res.status(500).json({ status: "error", message: msg });
        }
    },
    async getRoles(req, res) {
        try {
            const data = await employees_service_1.EmployeesService.getRoles(req.user.restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error al listar roles";
            return res.status(500).json({ status: "error", message: msg });
        }
    },
    async seedRoles(req, res) {
        try {
            const { Conexion } = await Promise.resolve().then(() => __importStar(require("../../config/database")));
            const { Role } = await Promise.resolve().then(() => __importStar(require("../signup/domain/role.entity")));
            // If dropping a column fails because of old schema issues, we just ignore it
            try {
                await Conexion.query(`ALTER TABLE core.roles DROP COLUMN IF EXISTS restaurante_id CASCADE;`);
            }
            catch (e) { }
            const rolesToSeed = ['admin', 'cajero', 'mesero', 'cocina'];
            for (const r of rolesToSeed) {
                const exists = await Conexion.manager.findOne(Role, { where: { nombre: r } });
                if (!exists) {
                    const newRole = Conexion.manager.create(Role, { nombre: r });
                    await Conexion.manager.save(newRole);
                }
            }
            return res.json({ status: "success", message: "Roles seeded globally" });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error";
            return res.status(500).json({ status: "error", message: msg });
        }
    },
    async create(req, res) {
        const parsed = employees_validator_1.CreateEmployeeSchema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({
                status: "error",
                message: "Datos inválidos: " + parsed.error.issues.map((e) => e.message).join(", ")
            });
        }
        try {
            const data = await employees_service_1.EmployeesService.create(parsed.data, req.user.restaurantId);
            return res.status(201).json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error al crear empleado";
            return res.status(400).json({ status: "error", message: msg });
        }
    },
    async update(req, res) {
        const parsed = employees_validator_1.UpdateEmployeeSchema.safeParse(req.body);
        if (!parsed.success) {
            return res.status(400).json({
                status: "error",
                message: "Datos inválidos: " + parsed.error.issues.map((e) => e.message).join(", ")
            });
        }
        try {
            const idParam = typeof req.params.id === 'string' ? req.params.id : req.params.id[0];
            const id = parseInt(idParam);
            const data = await employees_service_1.EmployeesService.update(id, parsed.data, req.user.restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error al actualizar empleado";
            return res.status(400).json({ status: "error", message: msg });
        }
    },
    async remove(req, res) {
        try {
            const idParam = typeof req.params.id === 'string' ? req.params.id : req.params.id[0];
            const id = parseInt(idParam);
            const data = await employees_service_1.EmployeesService.remove(id, req.user.restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error al eliminar empleado";
            return res.status(400).json({ status: "error", message: msg });
        }
    },
};

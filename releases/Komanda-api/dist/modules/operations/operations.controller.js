"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OperationsController = void 0;
const operations_service_1 = require("./operations.service");
const operations_validator_1 = require("./operations.validator");
class OperationsController {
    // ==========================================
    // PROVEEDORES
    // ==========================================
    static async getProveedores(req, res) {
        try {
            const result = await operations_service_1.OperationsService.getProveedores(req.user.restaurantId);
            res.json({ status: "success", data: result });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getUnidadesCompra(req, res) {
        try {
            const result = await operations_service_1.OperationsService.getUnidadesCompra(req.user.restaurantId);
            res.json({ status: "success", data: result });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async createProveedor(req, res) {
        try {
            const data = operations_validator_1.createProveedorSchema.parse(req.body);
            const result = await operations_service_1.OperationsService.createProveedor(data, req.user.restaurantId);
            res.status(201).json({ status: "success", data: result });
        }
        catch (error) {
            res.status(400).json({ status: "error", message: error.errors || error.message });
        }
    }
    static async updateProveedor(req, res) {
        try {
            const data = operations_validator_1.updateProveedorSchema.parse(req.body);
            const result = await operations_service_1.OperationsService.updateProveedor(Number(req.params.id), data, req.user.restaurantId);
            res.json({ status: "success", data: result });
        }
        catch (error) {
            res.status(400).json({ status: "error", message: error.errors || error.message });
        }
    }
    // ==========================================
    // GASTOS OPERATIVOS
    // ==========================================
    static async getGastos(req, res) {
        try {
            const result = await operations_service_1.OperationsService.getGastos(req.user.restaurantId);
            res.json({ status: "success", data: result });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async createGasto(req, res) {
        try {
            const data = operations_validator_1.createGastoSchema.parse(req.body);
            const result = await operations_service_1.OperationsService.createGasto(data, req.user.restaurantId, req.user.userId);
            res.status(201).json({ status: "success", data: result });
        }
        catch (error) {
            res.status(400).json({ status: "error", message: error.errors || error.message });
        }
    }
    // ==========================================
    // COMPRAS
    // ==========================================
    static async getCompras(req, res) {
        try {
            const result = await operations_service_1.OperationsService.getCompras(req.user.restaurantId);
            res.json({ status: "success", data: result });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async createCompra(req, res) {
        try {
            const data = operations_validator_1.createCompraSchema.parse(req.body);
            const result = await operations_service_1.OperationsService.createCompra(data, req.user.restaurantId);
            res.status(201).json({ status: "success", data: result });
        }
        catch (error) {
            const message = error.issues
                ? JSON.stringify(error.issues)
                : (error.errors || error.message);
            res.status(400).json({ status: "error", message });
        }
    }
    // ==========================================
    // SEED DATA
    // ==========================================
    static async seedOperationsData(req, res) {
        try {
            const restaurantId = req.user.restaurantId;
            const provs = await operations_service_1.OperationsService.getProveedores(restaurantId);
            if (provs.length === 0) {
                await operations_service_1.OperationsService.createProveedor({
                    identificacion: "J-12345678-9",
                    nombre: "Distribuidora de Alimentos Polar",
                    telefono: "0212-555-1234",
                    email: "ventas@polar.com",
                    direccion: "Caracas, Venezuela",
                    banco_nombre: "Banesco",
                    banco_cuenta_numero: "0134-XXXX-XXXX-XXXX"
                }, restaurantId);
                await operations_service_1.OperationsService.createProveedor({
                    identificacion: "J-98765432-1",
                    nombre: "Hortalizas El Campo",
                    telefono: "0414-555-4321",
                    email: "contacto@elcampo.com",
                    direccion: "Mercado Mayorista"
                }, restaurantId);
            }
            res.json({ status: "success", message: "Datos seed generados correctamente" });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
}
exports.OperationsController = OperationsController;

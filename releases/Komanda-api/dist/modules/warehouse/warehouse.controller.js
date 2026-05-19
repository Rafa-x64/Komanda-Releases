"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WarehouseController = void 0;
const zod_1 = require("zod");
const warehouse_service_1 = require("./warehouse.service");
const warehouse_validator_1 = require("./warehouse.validator");
const service = new warehouse_service_1.WarehouseService();
class WarehouseController {
    static getRestaurantId(req, res) {
        const id = req.user?.restaurantId;
        if (!id) {
            res.status(401).json({ status: "error", message: "Token sin restaurante válido. Vuelve a iniciar sesión." });
            return null;
        }
        return Number(id);
    }
    static async list(req, res) {
        try {
            const restauranteId = WarehouseController.getRestaurantId(req, res);
            if (!restauranteId)
                return;
            const data = await service.getAll(restauranteId);
            res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error interno";
            res.status(500).json({ status: "error", message: msg });
        }
    }
    static async getUnidades(_req, res) {
        try {
            const data = await service.getUnidades();
            res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error interno";
            res.status(500).json({ status: "error", message: msg });
        }
    }
    static async create(req, res) {
        try {
            const payload = warehouse_validator_1.CreateIngredientSchema.parse(req.body);
            const restauranteId = WarehouseController.getRestaurantId(req, res);
            if (!restauranteId)
                return;
            const data = await service.create(payload, restauranteId);
            res.status(201).json({ status: "success", data });
        }
        catch (error) {
            if (error instanceof zod_1.ZodError) {
                res.status(400).json({ status: "error", message: "Datos inválidos", errors: error.issues.map(e => e.message) });
            }
            else {
                const msg = error instanceof Error ? error.message : "Error al crear";
                res.status(400).json({ status: "error", message: msg });
            }
        }
    }
    static async update(req, res) {
        try {
            const payload = warehouse_validator_1.StockAdjustmentSchema.parse(req.body);
            const restauranteId = WarehouseController.getRestaurantId(req, res);
            if (!restauranteId)
                return;
            const data = await service.update(Number(req.params.id), payload, restauranteId);
            res.json({ status: "success", data });
        }
        catch (error) {
            if (error instanceof zod_1.ZodError) {
                res.status(400).json({ status: "error", message: "Datos inválidos", errors: error.issues.map(e => e.message) });
            }
            else {
                const msg = error instanceof Error ? error.message : "Error al actualizar";
                res.status(400).json({ status: "error", message: msg });
            }
        }
    }
    static async delete(req, res) {
        try {
            const restauranteId = WarehouseController.getRestaurantId(req, res);
            if (!restauranteId)
                return;
            await service.delete(Number(req.params.id), restauranteId);
            res.json({ status: "success", message: "Ingrediente eliminado" });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error al eliminar";
            res.status(400).json({ status: "error", message: msg });
        }
    }
}
exports.WarehouseController = WarehouseController;

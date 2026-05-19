"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.InventoryController = void 0;
const inventory_service_1 = require("./inventory.service");
const inventory_validator_1 = require("./inventory.validator");
const zod_1 = require("zod");
const inventoryService = new inventory_service_1.InventoryService();
class InventoryController {
    static getRestaurantId(req, res) {
        const id = req.user?.restaurantId;
        if (!id) {
            res.status(401).json({ status: "error", message: "Token sin restaurante válido. Vuelve a iniciar sesión." });
            return null;
        }
        return Number(id);
    }
    static async getInventory(req, res) {
        try {
            const restaurantId = InventoryController.getRestaurantId(req, res);
            if (!restaurantId)
                return;
            const data = await inventoryService.getAllByRestaurant(restaurantId);
            res.status(200).json({ status: "success", data });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async createIngredient(req, res) {
        try {
            const payload = inventory_validator_1.createIngredientSchema.parse(req.body);
            const restaurantId = InventoryController.getRestaurantId(req, res);
            if (!restaurantId)
                return;
            const data = await inventoryService.createIngredient(payload, restaurantId);
            res.status(201).json({ status: "success", data });
        }
        catch (error) {
            if (error instanceof zod_1.ZodError) {
                res.status(400).json({ status: "error", message: "Datos inválidos", details: error.issues });
            }
            else {
                res.status(400).json({ status: "error", message: error.message });
            }
        }
    }
    static async updateIngredient(req, res) {
        try {
            const payload = inventory_validator_1.updateIngredientSchema.parse(req.body);
            const restaurantId = InventoryController.getRestaurantId(req, res);
            if (!restaurantId)
                return;
            const data = await inventoryService.updateIngredient(Number(req.params.id), payload, restaurantId);
            res.status(200).json({ status: "success", data });
        }
        catch (error) {
            if (error instanceof zod_1.ZodError) {
                res.status(400).json({ status: "error", message: "Datos inválidos", details: error.issues });
            }
            else {
                res.status(400).json({ status: "error", message: error.message });
            }
        }
    }
    static async getMermas(req, res) {
        try {
            const restaurantId = InventoryController.getRestaurantId(req, res);
            if (!restaurantId)
                return;
            const data = await inventoryService.getMermas(restaurantId);
            res.status(200).json({ status: "success", data });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async createMerma(req, res) {
        try {
            const payload = inventory_validator_1.createMermaSchema.parse(req.body);
            const restaurantId = InventoryController.getRestaurantId(req, res);
            if (!restaurantId)
                return;
            const userId = req.user?.userId || 1;
            const result = await inventoryService.createMerma(payload, restaurantId, userId);
            res.status(201).json({ status: "success", data: result.data });
        }
        catch (error) {
            if (error instanceof zod_1.ZodError) {
                res.status(400).json({ status: "error", message: "Error de validación", details: error.issues });
            }
            else {
                res.status(400).json({ status: "error", message: error.message });
            }
        }
    }
}
exports.InventoryController = InventoryController;

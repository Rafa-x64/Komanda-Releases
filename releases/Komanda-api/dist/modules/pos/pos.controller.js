"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.POSController = void 0;
const pos_service_1 = require("./pos.service");
const pos_validator_1 = require("./pos.validator");
const zod_1 = require("zod");
class POSController {
    static async getCategories(req, res) {
        try {
            const { restaurantId } = req.user;
            const categories = await pos_service_1.POSService.getCategories(restaurantId);
            res.status(200).json({ status: "success", data: categories });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getProducts(req, res) {
        try {
            const { restaurantId } = req.user;
            const recipes = await pos_service_1.POSService.getProducts(restaurantId);
            res.status(200).json({ status: "success", data: recipes });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getTables(req, res) {
        try {
            const { restaurantId } = req.user;
            const mesas = await pos_service_1.POSService.getTables(restaurantId);
            res.status(200).json({ status: "success", data: mesas });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getPaymentMethods(req, res) {
        try {
            const { restaurantId } = req.user;
            const methods = await pos_service_1.POSService.getPaymentMethods(restaurantId);
            res.status(200).json({ status: "success", data: methods });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getSales(req, res) {
        try {
            const { restaurantId } = req.user;
            const sales = await pos_service_1.POSService.getSales(restaurantId);
            res.status(200).json({ status: "success", data: sales });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    // Pedidos listos para pagar (Cola del cajero)
    static async getReadyOrders(req, res) {
        try {
            const { restaurantId } = req.user;
            const orders = await pos_service_1.POSService.getReadyOrders(restaurantId);
            res.status(200).json({ status: "success", data: orders });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async checkoutOrder(req, res) {
        try {
            const payload = pos_validator_1.CheckoutOrderSchema.parse(req.body);
            const { restaurantId, userId } = req.user;
            const pedidoId = Number(req.params.id);
            const result = await pos_service_1.POSService.checkoutOrder(pedidoId, payload, restaurantId, userId);
            res.status(200).json({ status: "success", data: result });
        }
        catch (error) {
            if (error?.constructor?.name === 'ZodError') {
                res.status(400).json({ status: "fail", message: error.message });
            }
            else {
                res.status(error.message.includes('no encontrado') || error.message.includes('ya fue pagado') ? 422 : 500)
                    .json({ status: "error", message: error.message });
            }
        }
    }
    static async getActiveOrders(req, res) {
        try {
            const { restaurantId } = req.user;
            const orders = await pos_service_1.POSService.getActiveOrders(restaurantId);
            res.status(200).json({ status: "success", data: orders });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async updateOrderStatus(req, res) {
        try {
            const { restaurantId } = req.user;
            const pedidoId = Number(req.params.id);
            const { estado } = req.body;
            if (!estado) {
                res.status(400).json({ status: "error", message: "El estado es requerido" });
                return;
            }
            const updated = await pos_service_1.POSService.updateOrderStatus(pedidoId, estado, restaurantId);
            res.status(200).json({ status: "success", data: updated });
        }
        catch (error) {
            res.status(400).json({ status: "error", message: error.message });
        }
    }
    static async createSale(req, res) {
        try {
            const payload = pos_validator_1.CreateSaleSchema.parse(req.body);
            const { restaurantId, userId } = req.user;
            const sale = await pos_service_1.POSService.createSale(payload, restaurantId, userId);
            res.status(201).json({ status: "success", data: sale });
        }
        catch (error) {
            if (error instanceof zod_1.ZodError) {
                res.status(400).json({ status: "fail", message: "Error de validación", details: error.issues });
            }
            else {
                res.status(500).json({ status: "error", message: error.message });
            }
        }
    }
    static async closeCashRegister(req, res) {
        try {
            const payload = pos_validator_1.CashClosureSchema.parse(req.body);
            const { restaurantId, id: userId } = req.user;
            const closure = await pos_service_1.POSService.closeCashRegister(payload, restaurantId, userId);
            res.status(200).json({ status: "success", data: closure });
        }
        catch (error) {
            if (error instanceof zod_1.ZodError) {
                res.status(400).json({ status: "fail", message: "Error de validación", details: error.issues });
            }
            else {
                res.status(500).json({ status: "error", message: error.message });
            }
        }
    }
    static async getCashReport(req, res) {
        try {
            const { restaurantId } = req.user;
            const report = await pos_service_1.POSService.getCashReport(restaurantId);
            res.status(200).json({ status: "success", data: report });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
}
exports.POSController = POSController;

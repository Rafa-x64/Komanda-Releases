"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateOrderStatus = exports.getActiveOrders = void 0;
const kitchen_service_1 = require("./kitchen.service");
const kitchen_validator_1 = require("./kitchen.validator");
const kitchen_socket_1 = require("./kitchen.socket");
// Obtiene todas las ordenes activas en cocina
const getActiveOrders = async (req, res) => {
    try {
        const restaurantId = req.user?.restaurantId || req.user?.restaurante_id;
        if (!restaurantId) {
            res.status(403).json({ status: "error", message: "Restaurante no identificado (Multi-tenant activo)" });
            return;
        }
        const orders = await kitchen_service_1.KitchenService.getKitchenOrders(restaurantId);
        res.status(200).json({ status: "success", data: orders });
    }
    catch (error) {
        res.status(500).json({ status: "error", message: error.message });
    }
};
exports.getActiveOrders = getActiveOrders;
// Actualiza el estado de una orden y avisa por websockets
const updateOrderStatus = async (req, res) => {
    try {
        const restaurantId = req.user?.restaurantId || req.user?.restaurante_id;
        if (!restaurantId) {
            res.status(403).json({ status: "error", message: "Restaurante no identificado (Multi-tenant activo)" });
            return;
        }
        const orderId = parseInt(req.params.id);
        if (isNaN(orderId)) {
            res.status(400).json({ status: "error", message: "ID de orden inválido" });
            return;
        }
        const validData = kitchen_validator_1.updateOrderStatusSchema.parse(req.body);
        await kitchen_service_1.KitchenService.updateOrderStatus(orderId, validData.estado, restaurantId);
        // Disparar socket a los clientes de la cocina para que sepan que algo cambio a 'listo' o 'preparando'
        (0, kitchen_socket_1.broadcastNewOrderToKitchen)({
            action: 'actualizar_estado',
            payload: { id: orderId, estado: validData.estado }
        });
        res.status(200).json({ status: "success", message: "Estado de orden actualizado a " + validData.estado });
    }
    catch (error) {
        if (error.name === "ZodError") {
            res.status(400).json({ status: "error", message: "Validación fallida", details: error.errors });
            return;
        }
        res.status(400).json({ status: "error", message: error.message });
    }
};
exports.updateOrderStatus = updateOrderStatus;

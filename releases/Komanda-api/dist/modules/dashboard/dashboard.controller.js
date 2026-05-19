"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DashboardController = void 0;
const dashboard_service_1 = require("./dashboard.service");
exports.DashboardController = {
    async adminStats(req, res) {
        try {
            const restaurantId = req.user.restaurantId;
            const data = await dashboard_service_1.DashboardService.getAdminStats(restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error en dashboard";
            return res.status(500).json({ status: "error", message: msg });
        }
    },
    async kitchenOrders(req, res) {
        try {
            const restaurantId = req.user.restaurantId;
            const data = await dashboard_service_1.DashboardService.getKitchenOrders(restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error en dashboard";
            return res.status(500).json({ status: "error", message: msg });
        }
    },
    async waiterTables(req, res) {
        try {
            const restaurantId = req.user.restaurantId;
            const data = await dashboard_service_1.DashboardService.getWaiterTables(restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error en dashboard";
            return res.status(500).json({ status: "error", message: msg });
        }
    },
    async waiterStats(req, res) {
        try {
            const restaurantId = req.user.restaurantId;
            const data = await dashboard_service_1.DashboardService.getWaiterStats(restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            const msg = error instanceof Error ? error.message : "Error en dashboard";
            return res.status(500).json({ status: "error", message: msg });
        }
    },
};

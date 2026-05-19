"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReportsController = void 0;
const reports_service_1 = require("./reports.service");
class ReportsController {
    static async getReport(req, res) {
        try {
            const { type, dateFrom, dateTo } = req.query;
            const restaurantId = req.user.restaurantId;
            if (!type) {
                res.status(400).json({ status: "error", message: "El tipo de reporte es requerido" });
                return;
            }
            const data = await reports_service_1.ReportsService.getReportData(restaurantId, type, dateFrom, dateTo);
            res.status(200).json({ status: "success", data });
        }
        catch (error) {
            console.error("ReportsController.getReport error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getOverview(req, res) {
        try {
            const restaurantId = req.user.restaurantId;
            const data = await reports_service_1.ReportsService.getDashboardOverview(restaurantId);
            res.status(200).json({ status: "success", data });
        }
        catch (error) {
            console.error("ReportsController.getOverview error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }
}
exports.ReportsController = ReportsController;

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccountingController = void 0;
const accounting_service_1 = require("./accounting.service");
const accounting_validator_1 = require("./accounting.validator");
class AccountingController {
    static async getVBalanceGeneral(req, res) {
        const parsed = accounting_validator_1.DateRangeSchema.safeParse(req.query);
        if (!parsed.success) {
            return res.status(400).json({ status: "error", errors: parsed.error.flatten().fieldErrors });
        }
        try {
            const restaurantId = req.user.restaurantId;
            const { dateFrom, dateTo } = parsed.data;
            const data = await accounting_service_1.AccountingService.getBalanceGeneral(restaurantId, dateFrom, dateTo);
            res.status(200).json({ status: "success", data });
        }
        catch (error) {
            console.error("AccountingController.getVBalanceGeneral error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getVEstadoResultados(req, res) {
        const parsed = accounting_validator_1.DateRangeSchema.safeParse(req.query);
        if (!parsed.success) {
            return res.status(400).json({ status: "error", errors: parsed.error.flatten().fieldErrors });
        }
        try {
            const restaurantId = req.user.restaurantId;
            const { dateFrom, dateTo } = parsed.data;
            const data = await accounting_service_1.AccountingService.getEstadoResultados(restaurantId, dateFrom, dateTo);
            res.status(200).json({ status: "success", data });
        }
        catch (error) {
            console.error("AccountingController.getVEstadoResultados error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getJournalEntries(req, res) {
        const parsed = accounting_validator_1.DateRangeSchema.safeParse(req.query);
        if (!parsed.success) {
            return res.status(400).json({ status: "error", errors: parsed.error.flatten().fieldErrors });
        }
        try {
            const restaurantId = req.user.restaurantId;
            const { dateFrom, dateTo } = parsed.data;
            const data = await accounting_service_1.AccountingService.getJournalEntries(restaurantId, dateFrom, dateTo);
            res.status(200).json({ status: "success", data });
        }
        catch (error) {
            console.error("AccountingController.getJournalEntries error:", error);
            res.status(500).json({ status: "error", message: error.message });
        }
    }
}
exports.AccountingController = AccountingController;

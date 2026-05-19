"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TablesController = void 0;
const tables_service_1 = require("./tables.service");
const tables_validator_1 = require("./tables.validator");
class TablesController {
    static async getAll(req, res) {
        try {
            const tables = await tables_service_1.TablesService.getTables(req.user.restaurantId);
            res.status(200).json({ status: "success", data: tables });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async getById(req, res) {
        try {
            const tableId = Number(req.params.id);
            const table = await tables_service_1.TablesService.getTableById(req.user.restaurantId, tableId);
            if (!table) {
                return res.status(404).json({ status: "error", message: "Mesa no encontrada" });
            }
            res.status(200).json({ status: "success", data: table });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async create(req, res) {
        try {
            const validatedData = tables_validator_1.createTableSchema.parse(req.body);
            const newTable = await tables_service_1.TablesService.createTable(req.user.restaurantId, validatedData);
            res.status(201).json({ status: "success", data: newTable });
        }
        catch (error) {
            if (error.name === 'ZodError') {
                return res.status(400).json({ status: "error", message: error.errors[0].message });
            }
            res.status(400).json({ status: "error", message: error.message });
        }
    }
    static async update(req, res) {
        try {
            const tableId = Number(req.params.id);
            const validatedData = tables_validator_1.updateTableSchema.parse(req.body);
            const updatedTable = await tables_service_1.TablesService.updateTable(req.user.restaurantId, tableId, validatedData);
            res.status(200).json({ status: "success", data: updatedTable });
        }
        catch (error) {
            if (error.name === 'ZodError') {
                return res.status(400).json({ status: "error", message: error.errors[0].message });
            }
            res.status(400).json({ status: "error", message: error.message });
        }
    }
    static async delete(req, res) {
        try {
            const tableId = Number(req.params.id);
            await tables_service_1.TablesService.deleteTable(req.user.restaurantId, tableId);
            res.status(200).json({ status: "success", message: "Mesa eliminada correctamente" });
        }
        catch (error) {
            res.status(400).json({ status: "error", message: error.message });
        }
    }
}
exports.TablesController = TablesController;

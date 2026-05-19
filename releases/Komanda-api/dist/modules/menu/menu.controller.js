"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MenuController = void 0;
const menu_service_1 = require("./menu.service");
const menu_validator_1 = require("./menu.validator");
exports.MenuController = {
    async getRecipes(req, res) {
        try {
            const data = await menu_service_1.MenuService.getRecipes(req.user.restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            return res.status(500).json({ status: "error", message: error.message });
        }
    },
    async getCategories(req, res) {
        try {
            const data = await menu_service_1.MenuService.getCategories(req.user.restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            return res.status(500).json({ status: "error", message: error.message });
        }
    },
    async createRecipe(req, res) {
        const parsed = menu_validator_1.CreateRecipeSchema.safeParse(req.body);
        if (!parsed.success)
            return res.status(400).json({ status: "error", message: "Datos inválidos", errors: parsed.error.issues.map(e => e.message) });
        try {
            const data = await menu_service_1.MenuService.createRecipe(parsed.data, req.user.restaurantId);
            return res.status(201).json({ status: "success", data });
        }
        catch (error) {
            return res.status(400).json({ status: "error", message: error.message });
        }
    },
    async updateRecipe(req, res) {
        const parsed = menu_validator_1.UpdateRecipeSchema.safeParse(req.body);
        if (!parsed.success)
            return res.status(400).json({ status: "error", message: "Datos inválidos", errors: parsed.error.issues.map(e => e.message) });
        try {
            const data = await menu_service_1.MenuService.updateRecipe(Number(req.params.id), parsed.data, req.user.restaurantId);
            return res.json({ status: "success", data });
        }
        catch (error) {
            return res.status(400).json({ status: "error", message: error.message });
        }
    },
    async deleteRecipe(req, res) {
        try {
            await menu_service_1.MenuService.deleteRecipe(Number(req.params.id), req.user.restaurantId);
            return res.json({ status: "success", data: null });
        }
        catch (error) {
            return res.status(400).json({ status: "error", message: error.message });
        }
    },
    async createCategory(req, res) {
        const parsed = menu_validator_1.CreateCategorySchema.safeParse(req.body);
        if (!parsed.success)
            return res.status(400).json({ status: "error", message: "Datos inválidos", errors: parsed.error.issues.map(e => e.message) });
        try {
            const data = await menu_service_1.MenuService.createCategory(parsed.data, req.user.restaurantId);
            return res.status(201).json({ status: "success", data });
        }
        catch (error) {
            return res.status(400).json({ status: "error", message: error.message });
        }
    }
};

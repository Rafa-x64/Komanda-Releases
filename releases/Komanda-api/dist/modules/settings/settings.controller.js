"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.SettingsController = void 0;
const database_1 = require("../../config/database");
const restaurant_entity_1 = require("../signup/domain/restaurant.entity");
const user_entity_1 = require("../signup/domain/user.entity");
const settings_validator_1 = require("./settings.validator");
const zod_1 = require("zod");
const bcrypt = __importStar(require("bcrypt"));
class SettingsController {
    static async getRestaurantInfo(req, res) {
        try {
            const restaurantId = req.user?.restaurantId || req.user?.restaurante_id;
            if (!restaurantId) {
                res.status(403).json({ status: "error", message: "Restaurante no identificado" });
                return;
            }
            const info = await database_1.Conexion.getRepository(restaurant_entity_1.Restaurant).findOne({ where: { id: restaurantId } });
            if (!info) {
                res.status(404).json({ status: "error", message: "Restaurante no existe" });
                return;
            }
            res.status(200).json({ status: "success", data: info });
        }
        catch (error) {
            res.status(500).json({ status: "error", message: error.message });
        }
    }
    static async updateRestaurantInfo(req, res) {
        try {
            const restaurantId = req.user?.restaurantId || req.user?.restaurante_id;
            const role = req.user?.role;
            if (role !== 'admin') {
                res.status(403).json({ status: "error", message: "Permisos insuficientes" });
                return;
            }
            const validData = settings_validator_1.updateRestaurantSchema.parse(req.body);
            const restaurantRepo = database_1.Conexion.getRepository(restaurant_entity_1.Restaurant);
            const restaurant = await restaurantRepo.findOne({ where: { id: restaurantId } });
            if (!restaurant) {
                res.status(404).json({ status: "error", message: "Restaurante no encontrado" });
                return;
            }
            restaurant.nombre = validData.nombre;
            if (validData.direccion !== undefined)
                restaurant.direccion = validData.direccion;
            if (validData.telefono !== undefined)
                restaurant.telefono = validData.telefono;
            if (validData.email !== undefined)
                restaurant.email = validData.email;
            if (validData.moneda !== undefined)
                restaurant.moneda = validData.moneda;
            if (validData.impuesto_porcentaje !== undefined)
                restaurant.impuesto_porcentaje = Number(validData.impuesto_porcentaje);
            await restaurantRepo.save(restaurant);
            res.status(200).json({ status: "success", message: "Datos actualizados exitosamente", data: restaurant });
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
    static async updateProfile(req, res) {
        try {
            const userId = req.user?.id;
            const validData = settings_validator_1.updateProfileSchema.parse(req.body);
            const userRepo = database_1.Conexion.getRepository(user_entity_1.User);
            const userFound = await userRepo.findOne({ where: { id: userId } });
            if (!userFound) {
                res.status(404).json({ status: "error", message: "Usuario no encontrado" });
                return;
            }
            userFound.nombre = validData.nombre;
            userFound.email = validData.email;
            if (validData.password && validData.password.trim() !== '') {
                userFound.password_hash = await bcrypt.hash(validData.password, 10);
            }
            await userRepo.save(userFound);
            // Retornamos sin exponer la contraseña
            const { password_hash, ...safeUser } = userFound;
            res.status(200).json({ status: "success", message: "Perfil actualizado exitosamente", data: safeUser });
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
}
exports.SettingsController = SettingsController;

"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.JWT_SECRET = exports.requireRole = exports.authMiddleware = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const JWT_SECRET = process.env.JWT_SECRET || "komanda_secret_key_2026";
exports.JWT_SECRET = JWT_SECRET;
const authMiddleware = (req, res, next) => {
    const header = req.headers.authorization;
    if (!header?.startsWith("Bearer ")) {
        return res.status(401).json({ status: "error", message: "Token no proporcionado" });
    }
    try {
        const token = header.split(" ")[1];
        req.user = jsonwebtoken_1.default.verify(token, JWT_SECRET);
        next();
    }
    catch {
        return res.status(401).json({ status: "error", message: "Token inválido o expirado" });
    }
};
exports.authMiddleware = authMiddleware;
const requireRole = (...roles) => {
    return (req, res, next) => {
        if (!req.user || !roles.includes(req.user.role)) {
            return res.status(403).json({ status: "error", message: "No tienes permisos para esta acción" });
        }
        next();
    };
};
exports.requireRole = requireRole;

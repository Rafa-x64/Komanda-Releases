"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SignInService = void 0;
const database_1 = require("../../config/database");
const bcrypt_1 = __importDefault(require("bcrypt"));
const SignInService = async ({ username, password, restaurantName }) => {
    if (!database_1.Conexion.isInitialized) {
        throw new Error("La base de datos no está lista. Intenta de nuevo en unos segundos.");
    }
    // Buscar restaurante por nombre
    const restaurant = await database_1.Conexion.manager.query(`SELECT id, nombre FROM core.restaurante WHERE nombre = $1 LIMIT 1`, [restaurantName]);
    if (!restaurant.length)
        throw new Error("Restaurante no encontrado");
    const rest = restaurant[0];
    // Buscar usuario con su rol mediante JOIN
    const users = await database_1.Conexion.manager.query(`SELECT u.id, u.nombre, u.email, u.username, u.password_hash, u.activo, r.nombre AS rol_nombre
         FROM core.usuarios u
         JOIN core.roles r ON u.rol_id = r.id
         WHERE u.username = $1 AND u.restaurante_id = $2
         LIMIT 1`, [username, rest.id]);
    if (!users.length)
        throw new Error("Usuario no encontrado");
    const user = users[0];
    if (!user.activo)
        throw new Error("Usuario desactivado. Contacta al administrador.");
    const isPasswordValid = await bcrypt_1.default.compare(password, user.password_hash);
    if (!isPasswordValid)
        throw new Error("Contraseña inválida");
    return {
        user: {
            id: user.id,
            nombre: user.nombre,
            email: user.email,
            username: user.username,
            role: user.rol_nombre,
        },
        restaurant: { id: rest.id, nombre: rest.nombre },
    };
};
exports.SignInService = SignInService;

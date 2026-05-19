"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.EmployeesService = void 0;
const database_1 = require("../../config/database");
const user_entity_1 = require("../signup/domain/user.entity");
const role_entity_1 = require("../signup/domain/role.entity");
const bcrypt_1 = __importDefault(require("bcrypt"));
exports.EmployeesService = {
    async list(restaurantId) {
        const employees = await database_1.Conexion.manager.query(`SELECT u.id, u.nombre, u.email, u.username, u.activo, u.rol_id,
                    r.nombre AS rol_nombre, u.created_at
             FROM core.usuarios u
             JOIN core.roles r ON u.rol_id = r.id
             WHERE u.restaurante_id = $1
             ORDER BY u.nombre ASC`, [restaurantId]);
        return employees;
    },
    async getRoles(restaurantId) {
        return database_1.Conexion.getRepository(role_entity_1.Role).find({
            order: { nombre: "ASC" },
        });
    },
    async create(data, restaurantId) {
        // Verificar username único
        const existing = await database_1.Conexion.manager.findOne(user_entity_1.User, {
            where: { username: data.username },
        });
        if (existing)
            throw new Error("El nombre de usuario ya está en uso");
        // Verificar que el rol existe (ahora roles son globales)
        const role = await database_1.Conexion.manager.findOne(role_entity_1.Role, {
            where: { id: data.rol_id },
        });
        if (!role)
            throw new Error("Rol no válido");
        const salt = await bcrypt_1.default.genSalt(10);
        const passwordHash = await bcrypt_1.default.hash(data.password, salt);
        const user = database_1.Conexion.manager.create(user_entity_1.User, {
            nombre: data.nombre,
            email: data.email,
            username: data.username,
            password_hash: passwordHash,
            rol_id: data.rol_id,
            restaurante_id: restaurantId,
            activo: true,
        });
        await database_1.Conexion.manager.save(user);
        return { id: user.id, nombre: user.nombre, username: user.username, email: user.email, rol: role.nombre };
    },
    async update(id, data, restaurantId) {
        const user = await database_1.Conexion.manager.findOne(user_entity_1.User, {
            where: { id, restaurante_id: restaurantId },
        });
        if (!user)
            throw new Error("Empleado no encontrado");
        if (data.username && data.username !== user.username) {
            const dup = await database_1.Conexion.manager.findOne(user_entity_1.User, { where: { username: data.username } });
            if (dup)
                throw new Error("El nombre de usuario ya está en uso");
        }
        if (data.password) {
            const salt = await bcrypt_1.default.genSalt(10);
            data.password_hash = await bcrypt_1.default.hash(data.password, salt);
            delete data.password;
        }
        await database_1.Conexion.manager.update(user_entity_1.User, { id, restaurante_id: restaurantId }, data);
        return { message: "Empleado actualizado" };
    },
    async remove(id, restaurantId) {
        const user = await database_1.Conexion.manager.findOne(user_entity_1.User, {
            where: { id, restaurante_id: restaurantId },
        });
        if (!user)
            throw new Error("Empleado no encontrado");
        await database_1.Conexion.manager.update(user_entity_1.User, { id }, { activo: false });
        return { message: "Empleado desactivado" };
    },
};

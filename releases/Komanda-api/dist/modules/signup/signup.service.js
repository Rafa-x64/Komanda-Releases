"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SignupService = void 0;
const database_1 = require("../../config/database");
const restaurant_entity_1 = require("./domain/restaurant.entity");
const role_entity_1 = require("./domain/role.entity");
const user_entity_1 = require("./domain/user.entity");
const bcrypt_1 = __importDefault(require("bcrypt"));
exports.SignupService = {
    async register(data) {
        const queryRunner = database_1.Conexion.createQueryRunner();
        await queryRunner.connect();
        await queryRunner.startTransaction();
        try {
            // 1. Verificar email duplicado
            const existingUser = await queryRunner.manager.findOne(user_entity_1.User, {
                where: { email: data.admin.email },
            });
            if (existingUser) {
                throw new Error("El correo ya está registrado en otro restaurante.");
            }
            // 2. Verificar username duplicado
            const existingUsername = await queryRunner.manager.findOne(user_entity_1.User, {
                where: { username: data.admin.userName },
            });
            if (existingUsername) {
                throw new Error("El nombre de usuario ya existe.");
            }
            // 3. Crear el Restaurante
            const restaurant = queryRunner.manager.create(restaurant_entity_1.Restaurant, {
                nombre: data.restaurant.name,
                direccion: data.restaurant.address || null,
                telefono: data.restaurant.phone || null,
                email: data.restaurant.email || null,
                moneda: data.restaurant.currency || "USD",
                zona_horaria: data.restaurant.zone || "America/Caracas",
                impuesto_porcentaje: parseFloat(data.restaurant.tax || "0"),
                propina_porcentaje: parseFloat(data.restaurant.tip || "0"),
            });
            await queryRunner.manager.save(restaurant);
            // 4. Obtener o crear el Rol "admin" global
            let role = await queryRunner.manager.findOne(role_entity_1.Role, {
                where: { nombre: "admin" },
            });
            if (!role) {
                role = queryRunner.manager.create(role_entity_1.Role, { nombre: "admin" });
                await queryRunner.manager.save(role);
            }
            // 5. Hashear la contraseña
            const salt = await bcrypt_1.default.genSalt(10);
            const passwordHash = await bcrypt_1.default.hash(data.admin.password, salt);
            // 6. Crear el Usuario administrador
            const user = queryRunner.manager.create(user_entity_1.User, {
                restaurante_id: restaurant.id,
                rol_id: role.id,
                nombre: data.admin.name,
                email: data.admin.email,
                username: data.admin.userName,
                password_hash: passwordHash,
            });
            await queryRunner.manager.save(user);
            // 7. COMMIT - todo salió bien
            await queryRunner.commitTransaction();
            return {
                restaurantId: restaurant.id,
                restaurantName: restaurant.nombre,
                adminId: user.id,
                adminEmail: user.email,
                role: role.nombre,
            };
        }
        catch (error) {
            // ROLLBACK - si algo falló, deshacemos todo
            await queryRunner.rollbackTransaction();
            throw error;
        }
        finally {
            // Liberar la conexión siempre
            await queryRunner.release();
        }
    },
};

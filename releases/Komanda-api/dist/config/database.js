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
exports.Conexion = void 0;
const dotenv = __importStar(require("dotenv"));
const path = __importStar(require("path"));
dotenv.config({ path: path.join(__dirname, "../../.env") });
const typeorm_1 = require("typeorm");
const restaurant_entity_1 = require("../modules/signup/domain/restaurant.entity");
const user_entity_1 = require("../modules/signup/domain/user.entity");
const role_entity_1 = require("../modules/signup/domain/role.entity");
const pedido_entity_1 = require("../modules/pos/domain/pedido.entity");
const pedido_detalle_entity_1 = require("../modules/pos/domain/pedido-detalle.entity");
const mesa_entity_1 = require("../modules/pos/domain/mesa.entity");
const receta_entity_1 = require("../modules/pos/domain/receta.entity");
const categoria_entity_1 = require("../modules/pos/domain/categoria.entity");
const inventory_model_1 = require("../modules/inventory/inventory.model");
const proveedor_entity_1 = require("../modules/operations/domain/proveedor.entity");
const compra_entity_1 = require("../modules/operations/domain/compra.entity");
const compra_detalle_entity_1 = require("../modules/operations/domain/compra-detalle.entity");
const gasto_operativo_entity_1 = require("../modules/operations/domain/gasto-operativo.entity");
const merma_entity_1 = require("../modules/inventory/domain/merma.entity");
exports.Conexion = new typeorm_1.DataSource({
    type: "postgres",
    host: process.env.DB_HOST ?? "localhost",
    port: Number(process.env.DB_PORT ?? 5432),
    username: process.env.DB_USER ?? "postgres",
    password: process.env.DB_PASSWORD ?? "",
    database: process.env.DB_NAME ?? "komanda_db",
    synchronize: false,
    logging: false,
    entities: [restaurant_entity_1.Restaurant, user_entity_1.User, role_entity_1.Role, pedido_entity_1.Pedido, pedido_detalle_entity_1.PedidoDetalle, mesa_entity_1.Mesa, receta_entity_1.Receta, categoria_entity_1.Categoria, inventory_model_1.Ingrediente, proveedor_entity_1.Proveedor, compra_entity_1.Compra, compra_detalle_entity_1.CompraDetalle, gasto_operativo_entity_1.GastoOperativo, merma_entity_1.Merma],
    subscribers: [],
    migrations: [],
});

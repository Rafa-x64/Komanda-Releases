"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
require("reflect-metadata");
const database_1 = require("./config/database");
const signup_routes_1 = require("./modules/signup/signup.routes");
const signin_routes_1 = require("./modules/signin/signin.routes");
const pos_routes_1 = require("./modules/pos/pos.routes");
const employees_routes_1 = require("./modules/employees/employees.routes");
const menu_routes_1 = require("./modules/menu/menu.routes");
const kitchen_routes_1 = require("./modules/kitchen/kitchen.routes");
const inventory_routes_1 = require("./modules/inventory/inventory.routes");
const settings_route_1 = __importDefault(require("./modules/settings/settings.route"));
const operations_routes_1 = __importDefault(require("./modules/operations/operations.routes"));
const tables_routes_1 = __importDefault(require("./modules/tables/tables.routes"));
const reports_routes_1 = require("./modules/reports/reports.routes");
const dashboard_route_1 = require("./modules/dashboard/dashboard.route");
const accounting_routes_1 = require("./modules/accounting/accounting.routes");
const warehouse_route_1 = require("./modules/warehouse/warehouse.route");
const kitchen_socket_1 = require("./modules/kitchen/kitchen.socket");
const ws_1 = require("ws");
const app = (0, express_1.default)();
const PORT = 3000;
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Rutas públicas (sin auth)
app.use("/api/v1/signup", signup_routes_1.signupRouter);
app.use("/api/v1/signin", signin_routes_1.SignInRoutes);
// Rutas protegidas (auth middleware aplicado dentro de cada router)
app.use("/api/v1/pos", pos_routes_1.posRouter);
app.use("/api/v1/employees", employees_routes_1.employeesRouter);
app.use("/api/v1/menu", menu_routes_1.menuRouter);
app.use("/api/v1/kitchen", kitchen_routes_1.kitchenRouter);
app.use("/api/v1/inventory", inventory_routes_1.inventoryRouter);
app.use("/api/v1/settings", settings_route_1.default);
app.use("/api/v1/operations", operations_routes_1.default);
app.use("/api/v1/mesas", tables_routes_1.default);
app.use("/api/v1/reports", reports_routes_1.reportsRouter);
app.use("/api/v1/dashboard", dashboard_route_1.dashboardRouter);
app.use("/api/v1/accounting", accounting_routes_1.accountingRouter);
app.use("/api/v1/warehouse", warehouse_route_1.warehouseRouter);
app.get('/', (_req, res) => {
    res.json({
        message: 'API de KOMANDA funcionando',
        system: 'EndeavourOS',
        status: 'cooking 🍳'
    });
});
database_1.Conexion.initialize()
    .then(() => {
    console.log("Database connected to:", database_1.Conexion.options.database);
    const server = app.listen(PORT, () => {
        console.log(`\n🚀 Server ready at: http://localhost:${PORT}`);
    });
    const wss = new ws_1.WebSocketServer({ server });
    (0, kitchen_socket_1.setupKitchenSocket)(wss);
    const shutdown = () => {
        console.log('Cerrando el servidor de forma segura para liberar el puerto...');
        wss.close();
        server.close(() => {
            if (database_1.Conexion.isInitialized) {
                database_1.Conexion.destroy().then(() => {
                    console.log('Conexión a la base de datos cerrada.');
                    process.exit(0);
                });
            }
            else {
                process.exit(0);
            }
        });
        // Forzar cierre si tarda mucho
        setTimeout(() => {
            console.error('El cierre seguro tardó demasiado, forzando la salida...');
            process.exit(1);
        }, 5000).unref();
    };
    process.on('SIGINT', shutdown);
    process.on('SIGTERM', shutdown);
})
    .catch((error) => {
    console.error("Database connection error:", error.message || "Unknown error");
    process.exit(1);
});

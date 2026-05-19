"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.dashboardQuerySchema = void 0;
const zod_1 = require("zod");
// El dashboard solo recibe query params opcionales (no body)
exports.dashboardQuerySchema = zod_1.z.object({
    range: zod_1.z.enum(["today", "week", "month"]).optional().default("today"),
});

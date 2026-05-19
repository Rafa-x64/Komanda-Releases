"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateOrderStatusSchema = void 0;
const zod_1 = require("zod");
exports.updateOrderStatusSchema = zod_1.z.object({
    estado: zod_1.z.enum(["pendiente", "preparando", "listo"]),
});

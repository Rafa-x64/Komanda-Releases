"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CheckoutOrderSchema = exports.CashClosureSchema = exports.CreateSaleSchema = void 0;
const zod_1 = require("zod");
exports.CreateSaleSchema = zod_1.z.object({
    mesa_id: zod_1.z.number().int().positive().nullable().optional(),
    cliente: zod_1.z.string().max(100).nullable().optional(),
    items: zod_1.z.array(zod_1.z.object({
        receta_id: zod_1.z.number().int().positive(),
        cantidad: zod_1.z.number().int().positive(),
        notas: zod_1.z.string().nullable().optional(),
    })).min(1, "La venta debe tener al menos un artículo"),
    pagos: zod_1.z.array(zod_1.z.object({
        metodo_pago_id: zod_1.z.number().int().positive(),
        monto: zod_1.z.number().positive(),
        referencia: zod_1.z.string().nullable().optional()
    })).optional(), // opcional si la cuenta queda "abierta"
});
exports.CashClosureSchema = zod_1.z.object({
    monto_final: zod_1.z.number().min(0, "El monto final no puede ser negativo"),
    observaciones: zod_1.z.string().nullable().optional()
});
exports.CheckoutOrderSchema = zod_1.z.object({
    pagos: zod_1.z.array(zod_1.z.object({
        metodo_pago_id: zod_1.z.number().int().positive(),
        monto: zod_1.z.number().positive(),
        referencia: zod_1.z.string().nullable().optional()
    })).min(1, "Debe ingresar al menos un método de pago"),
});

"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createGastoSchema = exports.createCompraSchema = exports.updateProveedorSchema = exports.createProveedorSchema = void 0;
const zod_1 = require("zod");
exports.createProveedorSchema = zod_1.z.object({
    identificacion: zod_1.z.string().min(1, "Identificación requerida").max(30),
    nombre: zod_1.z.string().min(2, "Nombre requerido").max(100),
    telefono: zod_1.z.string().max(20).optional().nullable(),
    email: zod_1.z.string().email("Correo no válido").max(100).optional().nullable().or(zod_1.z.literal("").transform(() => null)),
    direccion: zod_1.z.string().optional().nullable(),
    banco_nombre: zod_1.z.string().max(50).optional().nullable(),
    banco_cuenta_numero: zod_1.z.string().max(30).optional().nullable(),
    observaciones: zod_1.z.string().optional().nullable(),
});
exports.updateProveedorSchema = exports.createProveedorSchema.partial().extend({
    activo: zod_1.z.boolean().optional()
});
exports.createCompraSchema = zod_1.z.object({
    fecha: zod_1.z.string(), // YYYY-MM-DD
    numero_factura_proveedor: zod_1.z.string().max(50).nullish(),
    proveedor_id: zod_1.z.number().int().positive().nullish(),
    descripcion: zod_1.z.string().max(255).nullish(),
    estado_pago: zod_1.z.enum(["pagada", "pendiente", "abonada"]).default("pagada"),
    items: zod_1.z.array(zod_1.z.object({
        ingrediente_id: zod_1.z.number().int().positive().nullish(),
        ingrediente_nombre: zod_1.z.string().max(100).nullish(),
        unidad_id: zod_1.z.number().int().positive().nullish(), // unidad de medida del nuevo ing
        cantidad_compra: zod_1.z.number().positive(),
        unidad_compra_id: zod_1.z.number().int().positive().nullish(), // siempre opcional
        precio_unitario: zod_1.z.number().nonnegative(),
        factor_conversion: zod_1.z.number().positive().default(1),
        cantidad_minima: zod_1.z.number().min(0).nullish(),
        merma_teorica_porcentaje: zod_1.z.number().min(0).max(100).nullish(),
    })).min(1, "Debe incluir al menos un ítem en la compra"),
});
exports.createGastoSchema = zod_1.z.object({
    categoria: zod_1.z.enum(["agua", "gas", "electricidad", "internet", "alquiler", "otros"], {
        message: "Categoría de gasto no válida."
    }),
    monto: zod_1.z.number().positive("El monto debe ser mayor a 0"),
    fecha: zod_1.z.string(), // YYYY-MM-DD
    metodo_pago: zod_1.z.enum(["efectivo", "pago_movil", "tarjeta", "divisa"], {
        message: "Método de pago no válido"
    }),
    referencia: zod_1.z.string().max(100).optional().nullable(),
    descripcion: zod_1.z.string().max(255).optional().nullable(),
});

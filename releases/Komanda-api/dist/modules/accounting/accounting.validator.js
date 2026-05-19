"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DateRangeSchema = void 0;
const zod_1 = require("zod");
exports.DateRangeSchema = zod_1.z.object({
    dateFrom: zod_1.z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Formato de fecha inválido (YYYY-MM-DD)').optional(),
    dateTo: zod_1.z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Formato de fecha inválido (YYYY-MM-DD)').optional(),
});

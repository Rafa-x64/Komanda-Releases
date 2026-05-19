"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GastoOperativo = void 0;
const typeorm_1 = require("typeorm");
let GastoOperativo = class GastoOperativo {
    id;
    categoria; // categoria_gasto_enum: 'agua', 'gas', 'electricidad', 'internet', 'alquiler'
    descripcion;
    monto;
    fecha;
    metodo_pago; // metodo_pago_enum
    referencia;
    periodo_mes;
    periodo_anio;
    usuario_id;
    restaurante_id;
    created_at;
};
exports.GastoOperativo = GastoOperativo;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], GastoOperativo.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar" }),
    __metadata("design:type", String)
], GastoOperativo.prototype, "categoria", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 255, nullable: true }),
    __metadata("design:type", Object)
], GastoOperativo.prototype, "descripcion", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 12, scale: 2, transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], GastoOperativo.prototype, "monto", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "date" }),
    __metadata("design:type", String)
], GastoOperativo.prototype, "fecha", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", default: "efectivo" }),
    __metadata("design:type", String)
], GastoOperativo.prototype, "metodo_pago", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 100, nullable: true }),
    __metadata("design:type", Object)
], GastoOperativo.prototype, "referencia", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", nullable: true }),
    __metadata("design:type", Object)
], GastoOperativo.prototype, "periodo_mes", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", nullable: true }),
    __metadata("design:type", Object)
], GastoOperativo.prototype, "periodo_anio", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", nullable: true }),
    __metadata("design:type", Object)
], GastoOperativo.prototype, "usuario_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], GastoOperativo.prototype, "restaurante_id", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: "created_at" }),
    __metadata("design:type", Date)
], GastoOperativo.prototype, "created_at", void 0);
exports.GastoOperativo = GastoOperativo = __decorate([
    (0, typeorm_1.Entity)({ name: "gastos_operativos", schema: "finanzas" })
], GastoOperativo);

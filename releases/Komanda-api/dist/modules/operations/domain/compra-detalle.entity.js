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
exports.CompraDetalle = void 0;
const typeorm_1 = require("typeorm");
const compra_entity_1 = require("./compra.entity");
let CompraDetalle = class CompraDetalle {
    id;
    compra_id;
    ingrediente_id;
    cantidad_compra;
    unidad_compra_id;
    precio_unitario;
    factor_conversion;
    restaurante_id;
    compra;
};
exports.CompraDetalle = CompraDetalle;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], CompraDetalle.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], CompraDetalle.prototype, "compra_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], CompraDetalle.prototype, "ingrediente_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 10, scale: 3, transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], CompraDetalle.prototype, "cantidad_compra", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", nullable: true }),
    __metadata("design:type", Object)
], CompraDetalle.prototype, "unidad_compra_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 10, scale: 2, transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], CompraDetalle.prototype, "precio_unitario", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 10, scale: 3, transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], CompraDetalle.prototype, "factor_conversion", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], CompraDetalle.prototype, "restaurante_id", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => compra_entity_1.Compra, (compra) => compra.detalles),
    (0, typeorm_1.JoinColumn)({ name: "compra_id" }),
    __metadata("design:type", compra_entity_1.Compra)
], CompraDetalle.prototype, "compra", void 0);
exports.CompraDetalle = CompraDetalle = __decorate([
    (0, typeorm_1.Entity)({ name: "compra_detalle", schema: "inventario" })
], CompraDetalle);

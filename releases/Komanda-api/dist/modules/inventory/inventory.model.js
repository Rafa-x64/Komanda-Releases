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
exports.Ingrediente = void 0;
const typeorm_1 = require("typeorm");
let Ingrediente = class Ingrediente {
    id;
    nombre;
    cantidad_disponible;
    cantidad_minima;
    unidad_id;
    costo_promedio;
    merma_teorica_porcentaje;
    restaurante_id;
    created_at;
    updated_at;
};
exports.Ingrediente = Ingrediente;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Ingrediente.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 100 }),
    __metadata("design:type", String)
], Ingrediente.prototype, "nombre", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 10, scale: 3, default: 0, name: "cantidad_disponible", transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], Ingrediente.prototype, "cantidad_disponible", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 10, scale: 3, default: 0, name: "cantidad_minima", transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], Ingrediente.prototype, "cantidad_minima", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", name: "unidad_id" }),
    __metadata("design:type", Number)
], Ingrediente.prototype, "unidad_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 10, scale: 2, default: 0, name: "costo_promedio", transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], Ingrediente.prototype, "costo_promedio", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 5, scale: 2, default: 0, name: "merma_teorica_porcentaje", transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], Ingrediente.prototype, "merma_teorica_porcentaje", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", name: "restaurante_id" }),
    __metadata("design:type", Number)
], Ingrediente.prototype, "restaurante_id", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: "created_at" }),
    __metadata("design:type", Date)
], Ingrediente.prototype, "created_at", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: "updated_at" }),
    __metadata("design:type", Date)
], Ingrediente.prototype, "updated_at", void 0);
exports.Ingrediente = Ingrediente = __decorate([
    (0, typeorm_1.Entity)({ schema: "inventario", name: "ingredientes" })
], Ingrediente);

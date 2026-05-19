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
exports.Merma = void 0;
const typeorm_1 = require("typeorm");
let Merma = class Merma {
    id;
    ingrediente_id;
    cantidad;
    tipo;
    razon;
    reportado_por;
    restaurante_id;
    created_at;
};
exports.Merma = Merma;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Merma.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], Merma.prototype, "ingrediente_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 10, scale: 3, transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], Merma.prototype, "cantidad", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "enum", enum: ["desperdicio", "vencimiento", "rotura", "otro"] }),
    __metadata("design:type", String)
], Merma.prototype, "tipo", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "text", nullable: true }),
    __metadata("design:type", Object)
], Merma.prototype, "razon", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], Merma.prototype, "reportado_por", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], Merma.prototype, "restaurante_id", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: "created_at" }),
    __metadata("design:type", Date)
], Merma.prototype, "created_at", void 0);
exports.Merma = Merma = __decorate([
    (0, typeorm_1.Entity)({ schema: "inventario", name: "mermas" })
], Merma);

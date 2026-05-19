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
exports.Restaurant = void 0;
const typeorm_1 = require("typeorm");
const user_entity_1 = require("./user.entity");
let Restaurant = class Restaurant {
    id;
    nombre;
    direccion;
    telefono;
    email;
    logo_url;
    moneda;
    zona_horaria;
    impuesto_porcentaje;
    propina_porcentaje;
    patrimonio_inicial;
    activo;
    created_at;
    updated_at;
    usuarios;
};
exports.Restaurant = Restaurant;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Restaurant.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 100 }),
    __metadata("design:type", String)
], Restaurant.prototype, "nombre", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "text", nullable: true }),
    __metadata("design:type", String)
], Restaurant.prototype, "direccion", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 20, nullable: true }),
    __metadata("design:type", String)
], Restaurant.prototype, "telefono", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 100, nullable: true }),
    __metadata("design:type", String)
], Restaurant.prototype, "email", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "text", nullable: true }),
    __metadata("design:type", String)
], Restaurant.prototype, "logo_url", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 3, default: "USD" }),
    __metadata("design:type", String)
], Restaurant.prototype, "moneda", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 50, default: "America/Caracas" }),
    __metadata("design:type", String)
], Restaurant.prototype, "zona_horaria", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 5, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Restaurant.prototype, "impuesto_porcentaje", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 5, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Restaurant.prototype, "propina_porcentaje", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 12, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Restaurant.prototype, "patrimonio_inicial", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "boolean", default: true }),
    __metadata("design:type", Boolean)
], Restaurant.prototype, "activo", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" }),
    __metadata("design:type", Date)
], Restaurant.prototype, "created_at", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" }),
    __metadata("design:type", Date)
], Restaurant.prototype, "updated_at", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => user_entity_1.User, (user) => user.restaurant),
    __metadata("design:type", Array)
], Restaurant.prototype, "usuarios", void 0);
exports.Restaurant = Restaurant = __decorate([
    (0, typeorm_1.Entity)({ name: "restaurante", schema: "core" })
], Restaurant);

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
exports.Proveedor = void 0;
const typeorm_1 = require("typeorm");
let Proveedor = class Proveedor {
    id;
    identificacion;
    nombre;
    telefono;
    email;
    direccion;
    restaurante_id;
    banco_nombre;
    banco_cuenta_numero;
    activo;
    observaciones;
    created_at;
    updated_at;
};
exports.Proveedor = Proveedor;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Proveedor.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 30 }),
    __metadata("design:type", String)
], Proveedor.prototype, "identificacion", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 100 }),
    __metadata("design:type", String)
], Proveedor.prototype, "nombre", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 20, nullable: true }),
    __metadata("design:type", Object)
], Proveedor.prototype, "telefono", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 100, nullable: true }),
    __metadata("design:type", Object)
], Proveedor.prototype, "email", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "text", nullable: true }),
    __metadata("design:type", Object)
], Proveedor.prototype, "direccion", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], Proveedor.prototype, "restaurante_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 50, nullable: true }),
    __metadata("design:type", Object)
], Proveedor.prototype, "banco_nombre", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 30, nullable: true }),
    __metadata("design:type", Object)
], Proveedor.prototype, "banco_cuenta_numero", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "boolean", default: true }),
    __metadata("design:type", Boolean)
], Proveedor.prototype, "activo", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "text", nullable: true }),
    __metadata("design:type", Object)
], Proveedor.prototype, "observaciones", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: "created_at" }),
    __metadata("design:type", Date)
], Proveedor.prototype, "created_at", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: "updated_at" }),
    __metadata("design:type", Date)
], Proveedor.prototype, "updated_at", void 0);
exports.Proveedor = Proveedor = __decorate([
    (0, typeorm_1.Entity)({ name: "proveedores", schema: "inventario" })
], Proveedor);

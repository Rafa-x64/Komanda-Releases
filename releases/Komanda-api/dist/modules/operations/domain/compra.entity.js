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
exports.Compra = void 0;
const typeorm_1 = require("typeorm");
const compra_detalle_entity_1 = require("./compra-detalle.entity");
let Compra = class Compra {
    id;
    fecha;
    numero_factura_proveedor;
    total;
    estado_pago; // estado_pago_compra enum
    saldo_pendiente;
    descripcion;
    proveedor_id;
    restaurante_id;
    created_at;
    detalles;
};
exports.Compra = Compra;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Compra.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "date" }),
    __metadata("design:type", String)
], Compra.prototype, "fecha", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 50, nullable: true }),
    __metadata("design:type", Object)
], Compra.prototype, "numero_factura_proveedor", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 12, scale: 2, transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], Compra.prototype, "total", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", default: "pagada" }),
    __metadata("design:type", String)
], Compra.prototype, "estado_pago", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "numeric", precision: 12, scale: 2, default: 0, transformer: { to: (val) => val, from: (val) => parseFloat(val) } }),
    __metadata("design:type", Number)
], Compra.prototype, "saldo_pendiente", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 255, nullable: true }),
    __metadata("design:type", Object)
], Compra.prototype, "descripcion", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", nullable: true }),
    __metadata("design:type", Object)
], Compra.prototype, "proveedor_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], Compra.prototype, "restaurante_id", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: "created_at" }),
    __metadata("design:type", Date)
], Compra.prototype, "created_at", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => compra_detalle_entity_1.CompraDetalle, (detalle) => detalle.compra),
    __metadata("design:type", Array)
], Compra.prototype, "detalles", void 0);
exports.Compra = Compra = __decorate([
    (0, typeorm_1.Entity)({ name: "compras", schema: "inventario" })
], Compra);

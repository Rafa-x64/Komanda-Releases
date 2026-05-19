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
exports.Pedido = void 0;
const typeorm_1 = require("typeorm");
const pedido_detalle_entity_1 = require("./pedido-detalle.entity");
let Pedido = class Pedido {
    id;
    codigo;
    mesa_id;
    mesero_id;
    cliente;
    estado;
    estado_cuenta;
    fecha_hora;
    subtotal;
    descuento;
    impuestos;
    total;
    restaurante_id;
    created_at;
    updated_at;
    detalles;
};
exports.Pedido = Pedido;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Pedido.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 40, unique: true }),
    __metadata("design:type", String)
], Pedido.prototype, "codigo", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", nullable: true }),
    __metadata("design:type", Object)
], Pedido.prototype, "mesa_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int", nullable: true }),
    __metadata("design:type", Object)
], Pedido.prototype, "mesero_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "varchar", length: 100, nullable: true }),
    __metadata("design:type", Object)
], Pedido.prototype, "cliente", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "enum", enum: ["pendiente", "enviado", "preparando", "listo", "pagado", "completado", "anulado"], default: "pendiente" }),
    __metadata("design:type", String)
], Pedido.prototype, "estado", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "enum", enum: ["abierta", "cuenta_pedida", "pagada", "cerrada"], default: "abierta" }),
    __metadata("design:type", String)
], Pedido.prototype, "estado_cuenta", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" }),
    __metadata("design:type", Date)
], Pedido.prototype, "fecha_hora", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 12, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Pedido.prototype, "subtotal", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 12, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Pedido.prototype, "descuento", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 12, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Pedido.prototype, "impuestos", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 12, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], Pedido.prototype, "total", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], Pedido.prototype, "restaurante_id", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ type: "timestamp" }),
    __metadata("design:type", Date)
], Pedido.prototype, "created_at", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ type: "timestamp" }),
    __metadata("design:type", Date)
], Pedido.prototype, "updated_at", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => pedido_detalle_entity_1.PedidoDetalle, (d) => d.pedido, { cascade: true }),
    __metadata("design:type", Array)
], Pedido.prototype, "detalles", void 0);
exports.Pedido = Pedido = __decorate([
    (0, typeorm_1.Entity)({ name: "pedidos", schema: "operaciones" })
], Pedido);

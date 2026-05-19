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
exports.PedidoDetalle = void 0;
const typeorm_1 = require("typeorm");
const pedido_entity_1 = require("./pedido.entity");
let PedidoDetalle = class PedidoDetalle {
    id;
    pedido_id;
    receta_id;
    cantidad;
    precio_unitario;
    subtotal;
    notas;
    restaurante_id;
    pedido;
};
exports.PedidoDetalle = PedidoDetalle;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], PedidoDetalle.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], PedidoDetalle.prototype, "pedido_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], PedidoDetalle.prototype, "receta_id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], PedidoDetalle.prototype, "cantidad", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 10, scale: 2 }),
    __metadata("design:type", Number)
], PedidoDetalle.prototype, "precio_unitario", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "decimal", precision: 10, scale: 2 }),
    __metadata("design:type", Number)
], PedidoDetalle.prototype, "subtotal", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "text", nullable: true }),
    __metadata("design:type", Object)
], PedidoDetalle.prototype, "notas", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: "int" }),
    __metadata("design:type", Number)
], PedidoDetalle.prototype, "restaurante_id", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => pedido_entity_1.Pedido, (p) => p.detalles),
    (0, typeorm_1.JoinColumn)({ name: "pedido_id" }),
    __metadata("design:type", pedido_entity_1.Pedido)
], PedidoDetalle.prototype, "pedido", void 0);
exports.PedidoDetalle = PedidoDetalle = __decorate([
    (0, typeorm_1.Entity)({ name: "pedido_detalle", schema: "operaciones" })
], PedidoDetalle);

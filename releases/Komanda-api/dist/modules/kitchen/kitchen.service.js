"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.KitchenService = void 0;
const database_1 = require("../../config/database");
const pedido_entity_1 = require("../pos/domain/pedido.entity");
class KitchenService {
    static async getKitchenOrders(restaurantId) {
        // Obtenemos los pedidos pendientes o en preparación
        const result = await database_1.Conexion.query(`SELECT 
                p.id, 
                p.codigo, 
                p.mesa_id, 
                coalesce(m.nombre, 'Mesa ' || p.mesa_id::text, 'Para llevar') as mesa,
                u.nombre as mesero, 
                p.cliente, 
                p.estado, 
                p.fecha_hora,
                (
                    SELECT json_agg(json_build_object(
                        'receta_id', d.receta_id, 
                        'nombre', r.nombre, 
                        'cantidad', d.cantidad, 
                        'notas', d.notas
                    ))
                    FROM operaciones.pedido_detalle d
                    JOIN menu.recetas r ON r.id = d.receta_id
                    WHERE d.pedido_id = p.id
                ) as items
             FROM operaciones.pedidos p
             LEFT JOIN operaciones.mesas m ON m.id = p.mesa_id
             LEFT JOIN core.usuarios u ON u.id = p.mesero_id
             WHERE p.restaurante_id = $1 
               AND p.estado IN ('pendiente', 'preparando')
             ORDER BY p.fecha_hora ASC`, [restaurantId]);
        return result;
    }
    static async updateOrderStatus(orderId, estado, restaurantId) {
        // Validamos que exista y pertenezca al restaurante
        const orderRepo = database_1.Conexion.getRepository(pedido_entity_1.Pedido);
        const order = await orderRepo.findOne({
            where: { id: orderId, restaurante_id: restaurantId }
        });
        if (!order) {
            throw new Error("Pedido no encontrado o no pertenece al restaurante");
        }
        order.estado = estado;
        await orderRepo.save(order);
        return order;
    }
    static async notifyPForPayment(pedidoId, restaurantId) {
        const pedido = await database_1.Conexion.getRepository(pedido_entity_1.Pedido).findOne({
            where: { id: pedidoId, restaurante_id: restaurantId },
        });
        if (!pedido)
            return;
        // Update estado to 'pagado' to trigger POS notification
        pedido.estado = 'pagado';
        await database_1.Conexion.getRepository(pedido_entity_1.Pedido).save(pedido);
    }
}
exports.KitchenService = KitchenService;

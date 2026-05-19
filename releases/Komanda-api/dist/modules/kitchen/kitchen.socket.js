"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notifyPForPayment = notifyPForPayment;
exports.setupKitchenSocket = setupKitchenSocket;
exports.broadcastNewOrderToKitchen = broadcastNewOrderToKitchen;
const ws_1 = require("ws");
// Set global para mantener clientes de cocina conectados
const kitchenClients = new Set();
// Set global para mantener clientes POS conectados
const posClients = new Set();
// Notify POS that order is ready for payment
function notifyPForPayment(pedidoId, restaurante_id) {
    broadcast({
        action: 'pedido_listo_pago',
        payload: { pedidoId, restaurante_id }
    }, 'pos');
}
function setupKitchenSocket(wss) {
    wss.on('connection', (ws) => {
        console.log('[Kitchen Socket] Nuevo cliente conectado');
        // Determine client type based on query parameter or header
        const isPOS = ws.url && ws.url.includes('type=pos');
        if (isPOS) {
            posClients.add(ws);
            console.log('[Kitchen Socket] Cliente POS conectado, total:', posClients.size);
        }
        else {
            kitchenClients.add(ws);
            console.log('[Kitchen Socket] Cliente cocina conectado, total:', kitchenClients.size);
        }
        // Cuando un cliente envía un mensaje
        ws.on('message', (message) => {
            try {
                const data = JSON.parse(message);
                if (data.action === 'cambiar_estado') {
                    console.log(`[Kitchen Socket] Orden ${data.payload.id} cambió a estado: ${data.payload.estado}`);
                    // Reenviamos el evento de cambio a todos los demás clientes (broadcasting)
                    // para que todas las pantallas de cocina se sincronicen
                    broadcast({
                        action: 'actualizar_estado',
                        payload: {
                            id: data.payload.id,
                            estado: data.payload.estado
                        }
                    });
                }
            }
            catch (error) {
                console.error('[Kitchen Socket] Error parseando mensaje', error);
            }
        });
        ws.on('close', () => {
            console.log('[Kitchen Socket] Cliente desconectado');
            kitchenClients.delete(ws);
        });
    });
}
// Función disponible de forma global en el módulo para que, por ejemplo,
// el Order.Controller nos llame para avisar que entró un nuevo pedido desde las mesas
function broadcastNewOrderToKitchen(pedido) {
    broadcast({
        action: 'nuevo_pedido',
        payload: pedido
    }, 'kitchen');
}
function broadcast(message, target = 'kitchen') {
    const data = JSON.stringify(message);
    const clients = target === 'kitchen' ? kitchenClients : posClients;
    for (const client of clients) {
        if (client.readyState === ws_1.WebSocket.OPEN) {
            client.send(data);
        }
    }
}

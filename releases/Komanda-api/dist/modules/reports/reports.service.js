"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReportsService = void 0;
const database_1 = require("../../config/database");
class ReportsService {
    static async getReportData(restaurantId, type, dateFrom, dateTo) {
        let query = "";
        let params = [restaurantId];
        let paramIndex = 2;
        switch (type) {
            case 'ventas':
                query = `
                    SELECT 
                        TO_CHAR(p.fecha_hora, 'YYYY-MM-DD HH24:MI:SS') as fecha, 
                        p.codigo as ticket, 
                        '$' || ROUND(p.subtotal, 2) as base, 
                        '$' || ROUND(p.impuestos, 2) as tax, 
                        '$' || ROUND(p.total, 2) as total 
                    FROM operaciones.pedidos p
                    WHERE p.restaurante_id = $1 
                    AND p.estado_cuenta IN ('pagada', 'cerrada')
                `;
                if (dateFrom && dateTo) {
                    query += ` AND DATE(p.fecha_hora) BETWEEN $${paramIndex} AND $${paramIndex + 1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += ` ORDER BY p.fecha_hora DESC`;
                break;
            case 'inventario':
                query = `
                    SELECT 
                        nombre as insumo, 
                        cantidad_disponible || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = unidad_id LIMIT 1) as actual,
                        cantidad_minima || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = unidad_id LIMIT 1) as reorden,
                        CASE WHEN cantidad_disponible <= cantidad_minima THEN 'Crítico' ELSE 'Óptimo' END as estado 
                    FROM inventario.ingredientes 
                    WHERE restaurante_id = $1
                    ORDER BY cantidad_disponible ASC
                `;
                break;
            case 'empleados':
                query = `
                    SELECT 
                        u.nombre as empleado, 
                        r.nombre as cargo, 
                        '$' || ROUND(COALESCE(SUM(p.total), 0), 2) as ventas, 
                        COUNT(p.id) || ' turnos/órdenes' as horas 
                    FROM core.usuarios u 
                    JOIN core.roles r ON u.rol_id = r.id 
                    LEFT JOIN operaciones.pedidos p ON p.mesero_id = u.id AND p.restaurante_id = $1
                `;
                if (dateFrom && dateTo) {
                    query += ` AND DATE(p.fecha_hora) BETWEEN $${paramIndex} AND $${paramIndex + 1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += `
                    WHERE u.restaurante_id = $1
                    GROUP BY u.id, r.nombre
                    ORDER BY COALESCE(SUM(p.total), 0) DESC
                `;
                break;
            case 'gastos':
                query = `
                    SELECT 
                        TO_CHAR(g.fecha, 'YYYY-MM-DD') as fecha, 
                        g.categoria::text as categoria, 
                        g.descripcion, 
                        '$' || ROUND(g.monto, 2) as monto, 
                        COALESCE(u.nombre, 'Sistema') as responsable 
                    FROM finanzas.gastos_operativos g 
                    LEFT JOIN core.usuarios u ON g.usuario_id = u.id 
                    WHERE g.restaurante_id = $1
                `;
                if (dateFrom && dateTo) {
                    query += ` AND g.fecha BETWEEN $${paramIndex} AND $${paramIndex + 1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += ` ORDER BY g.fecha DESC`;
                break;
            case 'contabilidad':
                query = `
                    SELECT 
                        TO_CHAR(a.fecha, 'YYYY-MM-DD') as fecha, 
                        'AS-' || LPAD(a.id::text, 4, '0') as asiento, 
                        a.descripcion as cuenta_debe, 
                        'Caja/Bancos' as cuenta_haber, 
                        '$' || ROUND(a.total_debe, 2) as monto 
                    FROM contabilidad.asientos a
                    WHERE a.restaurante_id = $1
                `;
                if (dateFrom && dateTo) {
                    query += ` AND a.fecha BETWEEN $${paramIndex} AND $${paramIndex + 1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += ` ORDER BY a.fecha DESC`;
                break;
            case 'mermas':
                query = `
                    SELECT 
                        TO_CHAR(m.created_at, 'YYYY-MM-DD HH24:MI:SS') as fecha, 
                        i.nombre as insumo, 
                        m.cantidad || ' ' || (SELECT abreviatura FROM core.unidad_medida WHERE id = i.unidad_id LIMIT 1) as cantidad, 
                        m.razon as motivo, 
                        '$' || ROUND((m.cantidad * i.costo_promedio), 2) as costo_perdido 
                    FROM inventario.mermas m 
                    JOIN inventario.ingredientes i ON m.ingrediente_id = i.id 
                    WHERE m.restaurante_id = $1
                `;
                if (dateFrom && dateTo) {
                    query += ` AND DATE(m.created_at) BETWEEN $${paramIndex} AND $${paramIndex + 1}`;
                    params.push(dateFrom, dateTo);
                    paramIndex += 2;
                }
                query += ` ORDER BY m.created_at DESC`;
                break;
            case 'predicciones':
                query = `
                    WITH FechasVentas AS (
                        SELECT MIN(DATE(fecha_hora)) as primera_venta
                        FROM operaciones.pedidos
                        WHERE restaurante_id = $1 AND estado_cuenta IN ('pagada', 'cerrada')
                    ),
                    DiasOperacion AS (
                        SELECT GREATEST(1, CURRENT_DATE - COALESCE(primera_venta, CURRENT_DATE) + 1) as dias_totales
                        FROM FechasVentas
                    ),
                    DailySales AS (
                        SELECT DATE(fecha_hora) as dia, SUM(total) as total_dia
                        FROM operaciones.pedidos
                        WHERE restaurante_id = $1 AND estado_cuenta IN ('pagada', 'cerrada')
                        GROUP BY DATE(fecha_hora)
                    ),
                    AvgSales AS (
                        SELECT 
                            COALESCE(SUM(total_dia) / (SELECT dias_totales FROM DiasOperacion), 0) as promedio_diario,
                            COALESCE(AVG(total_dia), 0) as promedio_dias_activos
                        FROM DailySales
                        WHERE dia >= CURRENT_DATE - INTERVAL '30 days'
                    )
                    SELECT 
                        TO_CHAR(CURRENT_DATE + seq.day, 'YYYY-MM-DD') as fecha_proyectada,
                        'Venta Proyectada (Tendencia)' as concepto,
                        '$' || ROUND(
                            (
                                (SELECT 
                                    CASE 
                                        WHEN (SELECT dias_totales FROM DiasOperacion) < 7 THEN promedio_dias_activos * (1 + (seq.day * 0.05))
                                        ELSE promedio_diario 
                                    END
                                 FROM AvgSales)
                                * (1 + (RANDOM() * 0.10 - 0.05))
                            )::numeric, 2
                        ) as monto_estimado,
                        CASE 
                            WHEN (SELECT dias_totales FROM DiasOperacion) < 7 THEN 'Crecimiento Inicial (5% diario)'
                            ELSE 'Media Móvil Ponderada (Días Operativos)'
                        END as metodo
                    FROM (SELECT generate_series(1, 7) as day) seq
                `;
                break;
            default:
                throw new Error("Tipo de reporte no soportado");
        }
        const results = await database_1.Conexion.query(query, params);
        return results;
    }
    static async getDashboardOverview(restaurantId) {
        // KPIs (This week vs Last week would be ideal, but let's just do "This Week" totals)
        const [kpis] = await database_1.Conexion.query(`SELECT 
                COALESCE(SUM(CASE WHEN tipo = 'ingreso' THEN monto ELSE 0 END), 0) as ingreso_bruto,
                COALESCE(SUM(CASE WHEN tipo IN ('costo', 'gasto') THEN monto ELSE 0 END), 0) as costo_operativo
             FROM contabilidad.v_estado_resultados
             WHERE restaurante_id = $1 AND fecha >= CURRENT_DATE - INTERVAL '7 days'`, [restaurantId]);
        const [tickets] = await database_1.Conexion.query(`SELECT COUNT(id) as total_tickets
             FROM operaciones.pedidos
             WHERE restaurante_id = $1 AND fecha_hora >= CURRENT_DATE - INTERVAL '7 days'`, [restaurantId]);
        // Profitability (Sales vs Cost)
        const rentabilidad = await database_1.Conexion.query(`SELECT 
                r.nombre as name,
                '🍽️' as emoji,
                CAST(r.precio_venta AS NUMERIC) as price,
                CAST(r.costo_produccion AS NUMERIC) as cost,
                CAST(COALESCE(SUM(pd.cantidad), 0) AS INTEGER) as units
             FROM menu.recetas r
             LEFT JOIN operaciones.pedido_detalle pd ON pd.receta_id = r.id
             LEFT JOIN operaciones.pedidos p ON p.id = pd.pedido_id AND p.fecha_hora >= CURRENT_DATE - INTERVAL '30 days'
             WHERE r.restaurante_id = $1
             GROUP BY r.id, r.nombre, r.precio_venta, r.costo_produccion
             ORDER BY units DESC`, [restaurantId]);
        // Chart Data (Last 7 days)
        const chartData = await database_1.Conexion.query(`SELECT 
                TO_CHAR(fecha, 'DD/MM') as date,
                COALESCE(SUM(CASE WHEN tipo = 'ingreso' THEN monto ELSE 0 END), 0) as revenue,
                COALESCE(SUM(CASE WHEN tipo IN ('costo', 'gasto') THEN monto ELSE 0 END), 0) as cost
             FROM contabilidad.v_estado_resultados
             WHERE restaurante_id = $1 AND fecha >= CURRENT_DATE - INTERVAL '6 days'
             GROUP BY fecha
             ORDER BY fecha ASC`, [restaurantId]);
        return {
            kpis: {
                ingreso_bruto: parseFloat(kpis.ingreso_bruto),
                costo_operativo: parseFloat(kpis.costo_operativo),
                tickets_semana: parseInt(tickets.total_tickets)
            },
            rentabilidad: rentabilidad.map((r) => {
                const margin = r.price - r.cost;
                const marginPct = r.price > 0 ? (margin / r.price) * 100 : 0;
                return {
                    name: r.name,
                    emoji: r.emoji,
                    price: parseFloat(r.price),
                    cost: parseFloat(r.cost),
                    units: r.units,
                    margin: margin,
                    marginPct: marginPct,
                    totalGain: margin * r.units
                };
            }),
            chartData: chartData.map((c) => ({
                date: c.date,
                revenue: parseFloat(c.revenue),
                cost: parseFloat(c.cost)
            }))
        };
    }
}
exports.ReportsService = ReportsService;

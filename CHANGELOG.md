# 📜 ChangeLog

Todas las actualizaciones notables documentadas en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [v0.4.0] - 2026-05-19

### 🚀 Novedades (Features)

- **Empaquetado Automático y Obfuscado (`build-release.sh`):** Implementación de un script transpilador ultra-seguro, offline-first y blindado que empaqueta todo el monorepo (Frontend Vite + Backend tsc) libre de código fuente original (.ts, .vue) protegiendo al 100% la propiedad intelectual del software.
- **Orquestador Monorepo de Producción:** Creación de un lanzador unificado en releases (`package.json` de producción) que levanta Frontend estático (`serve`), Backend Express y Servidor PHP concurrentemente con un solo comando `pnpm start`.
- **Aislamiento Multi-Tenant y Códigos Scoped:** Corrección en el sistema de asignación de códigos secuenciales de pedidos aislados estrictamente por restaurante para erradicar colisiones entre tenants.
- **Globalización de Métodos de Pago:** Transición de métodos de pago a configuraciones universales seguras a nivel de base de datos para todas las sucursales.

### 🐛 Correcciones (Fixes)

- **Cero Errores de Tipado TypeScript en Compilación:** Corrección de los 8 errores estrictos del backend en `get_schema.ts` (tipos de pg), `inventory.validator.ts` y `operations.validator.ts` (firma Zod para enums con invalid_type_error), `kitchen.service.ts` (entidad Pedido corregida) y `settings.controller.ts` (alineación de campos email y password_hash del modelo User).
- **Estabilización de Dashboards y KPIs Reales:** Conexión estricta de las KPIs y gráficas contables en base a la vista real `contabilidad.v_estado_resultados` en lugar del obsoleto `libro_diario`.
- **Navegación y Autenticación de Roles:** Solucionado el bug de redirección por sesión no autorizada de roles al ingresar a Inventario.
- **Costo CPP de Recetas:** Resuelto el problema de valor en cero de las recetas en el reporte de rentabilidad calculando dinámicamente el Costo Promedio Ponderado real.

---

## [v0.3.0] - 2026-05-03

### 🚀 Novedades (Features)

- **Métricas Reales en Dashboard:** Sustituida la data de prueba en el panel de administración por KPIs reales sincronizados con la BD y soporte temporal.
- **Reportes Analíticos y Predictivos:** Implementación completa del módulo de reportes con soporte exportable y pronóstico de ventas a 7 días.
- **Sincronización POS/Cocina (KDS):** Flujo de tiempo real robustecido entre cajero, cocina y mesero; estado de órdenes sincronizado por WebSockets.
- **Optimización de Entorno Legacy:** Creación de scripts automatizados para asegurar el rendimiento sobre hardware Dell Inspiron 1525 (CachyOS + Wayland).

### 🐛 Correcciones (Fixes)

- **Conflictos de Puertos:** Corregido el error EADDRINUSE en el puerto 3000 con asignación dinámica o resolución automática de procesos zombies.
- **Integridad de Base de Datos:** Corrección y aplicación rigurosa de esquema SQLite / PostgreSQL para asegurar la integración perfecta entre el backend y frontend.

---

## [v0.2.0] - 2026-04-23

### 🚀 Novedades (Features)

- **Cajero y POS Unificados:** Rediseño arquitectónico del POS pasando de un "catálogo de productos" a una **Cola de Cobros centralizada (Cashier-centric Queue)**.
- **Reporte de Cierre de Caja:** Nuevo endpoint `/api/v1/pos/cash-report` que calcula pedidos cobrados y desglose por método de pago del día/turno.
- **Impresión Térmica de Tickets:** Integración de `html2pdf.js` en el dashboard del cajero para generar e imprimir de forma aislada los reportes de cierre de caja en formato ticket de 80mm.
- **Control de Acceso (RBAC):** El rol `cajero` ahora tiene un menú lateral restringido, ocultando opciones administrativas, inventario y gastos.

### 🐛 Correcciones (Fixes)

- **Base de Datos TypeORM:** Eliminadas las columnas `total_pagado` y `pagado_completo` de la entidad `Pedido` para evitar errores de sincronización e inserción con el esquema PostgreSQL nativo.
- **Sockets de Cocina:** Corregida ruta de importación errónea en `useSocketCocina.ts` y eliminadas llamadas a funciones de pago inexistentes que rompían el renderizado del frontend.
- **Responsive Web Design:** Solapamiento del botón hamburguesa corregido en la vista del Cajero en móviles mediante `padding-top`.

---

## [v0.1.0] - 2026-03-31

### 📋 Revisión y Consolidación de Módulos (Correcciones Académicas)

> [!IMPORTANT]
> Revisión mayor de la arquitectura funcional basada en las correcciones de los profesores de Gerenciales y Contabilidad. No se modificó código, solo documentación y estructura de módulos.

- **Consolidación de Módulos:** Se redujo de múltiples módulos redundantes a **5 módulos funcionales claros**:

  - `Almacén y Compras` (fusiona lo que antes eran "Inventario" y "Almacén" por separado).
  - `Menú y Recetas` (estandarización de platos con BOM y precios dinámicos).
  - `Punto de Venta` (fusiona "Ventas" y "Caja" en un único lugar).
  - `Contabilidad` (módulo completo con Balance General, Estado de Resultados y Libro Diario).
  - `Gastos Operativos` (agua, gas, electricidad, internet, alquiler exclusivamente).
- **Punto de Venta Unificado:** El POS y la caja son un solo módulo. Cada venta registra el/los método(s) de pago usados (Efectivo, Pago Móvil, Tarjeta, Divisa) con sus montos individuales para un arqueo preciso.
- **Módulo Contable Completo:** La contabilidad ahora es un módulo de primera clase con asientos automáticos por cada evento de negocio (compra, venta, gasto). Incluye Balance General, Estado de Resultados y Reporte de Rentabilidad por plato.
- **Contexto SaaS:** Se formalizó que Komanda es un sistema SaaS multi-restaurante (multi-tenant). Cada restaurante es un tenant aislado.
- **Documentación Actualizada:**

  - `KOMANDA.md` — Redefinición completa con los 5 módulos y contexto SaaS.
  - `ROADMAP.md` — Plan de sprints alineado con los módulos consolidados.
  - `TODO.md` — Checklist maestra reorganizada por los 5 módulos.
  - `enunciado_maestro.txt` — Documento guía de referencia para el desarrollo.

---

## [v0.0.3] - 2026-02-18

### 🗄️ Base de Datos (Breaking Change v2.1)

> [!WARNING]
> Esta versión incluye cambios disruptivos (Breaking Changes) en la estructura de la base de datos PostgreSQL.

- **Organización por Esquemas PostgreSQL:** Separación lógica en `core`, `inventario`, `menu`, `operaciones`, `finanzas`, `contabilidad`.
- **Robustez Operativa (v2.1):**
  - **Conversiones:** `compra_detalle` ahora incluye `factor_conversion` y una columna calculada `cantidad_inventario` para manejar unidades de compra vs consumo.
  - **Descuentos y Propinas:** Campos financieros agregados a `pedidos` y `facturas`. Configuración de `propina_porcentaje` en restaurante.
  - **Reservas:** Nueva tabla `operaciones.reservas` con estado y datos de cliente.
  - **Imágenes:** Campo `imagen_url` en recetas para KDS/POS.
  - **Mermas:** Tabla de registro de desperdicios y campo `merma_teorica_porcentaje` en ingredientes.
- **Tablas Nuevas Clave:** `menu.categorias`, `contabilidad.libro_diario`.
- **Correcciones de Dominio:** ENUMs alineados con `DOMAIN.md` (`estado_pedido`, `estado_cuenta`).
- **Seguridad:** `password_hash` en usuarios. Auditoría completa (`created_at`/`updated_at`) con triggers automáticos.

### 📚 Documentación

- **[CAMBIOS_BD_v2.txt](./CAMBIOS_BD_v2.txt):** Resumen detallado de la versión 2.1.

---

## [v0.0.1] - 2026-02-07

### 🗄️ Base de Datos (Breaking Change)

> [!WARNING]
> Refactorización masiva inicial: Todas las tablas migradas del schema `public` a 6 esquemas lógicos.

- **Esquemas:**
  - `core` — Restaurante, usuarios, roles, métodos de pago, unidades de medida.
  - `inventario` — Ingredientes, proveedores, compras, mermas, unidades de compra.
  - `menu` — Categorías, recetas, ingredientes de receta.
  - `operaciones` — Mesas, meseros, pedidos, facturas.
  - `finanzas` — Caja, banco, egresos y movimientos.
  - `contabilidad` — Libro diario (asientos contables).
- **Nuevas Tablas:** `inventario.mermas`, `menu.categorias`, `contabilidad.libro_diario`.
- **Autenticación:** Campo `password_hash` en `core.usuarios`.
- **ENUMs Corregidos:** `estado_pedido`, `estado_cuenta`, `tipo_merma`.
- **Columnas Nuevas:** `notas` en `pedido_detalle`, datos de cliente y pago en `facturas`, datos de la empresa en `restaurante`, `categoria_id` en `recetas`.
- **Auditoría & Precisión:** `created_at`/`updated_at` + triggers; campos financieros a `DECIMAL(12,2)`.

### 📚 Documentación

- **[CAMBIOS_BD_v2.txt](./CAMBIOS_BD_v2.txt):** Resumen detallado de todos los cambios de la base de datos.

---

## [v0.0.1] - 2026-02-07

### 🚀 Novedades (Features)

- **Hybrid Core Architecture:** Se ha implementado la arquitectura híbrida que permite ejecutar **Node.js** (Puerto 3000) y **PHP** (Puerto 8000) simultáneamente.
- **Kitchen Monitor (MVP):** Nueva vista en Vue 3 (`KitchenStatus.vue`) que consume datos en tiempo real de ambos backends.
  - Endpoints: Node `/api/v1/kitchen/status` y PHP `/api/stats.php`.

### 📚 Documentación (Docs)

> [!NOTE]
> Se ha creado la "Constitución" del proyecto para estandarizar el desarrollo.

- **[ARCHITECTURE.md](./ARCHITECTURE.md):** Definición del Monolito Modular y DDD-Lite.
- **[DOMAIN.md](./DOMAIN.md):** Glosario de términos y Estados de Pedidos.
- **[API_CONTRACTS.md](./API_CONTRACTS.md):** Estándares de respuesta JSON.
- **[MANUAL_BACKEND.md](./MANUAL_BACKEND.md):** Guía de endpoints Node y PHP (Hybrid).
- **[MANUAL_FRONTEND.md](./MANUAL_FRONTEND.md):** Guía de Frontend Vue 3.
- **README.md:** Reescrito con formato profesional "Dev-to-Dev" e integraciones.

### 🛠 Infraestructura & Fixes

- **Orquestación:** Nuevo comando `pnpm komanda` (alias `pnpm dev`) para concurrencia.
- **CORS:** Habilitado para Express y PHP.
- **Instalación:** Verificación y creación de guías multiplataforma.

---

## [v0.0.2] - 2026-02-11

### 🚀 Novedades (Features)

- **Landing Page Responsiva:** Implementación en `src/modules/landing`.
  - Componentes principales desarrollados con Glassmorphism y animaciones.
  - **Tema KOrange:** Integración del modo oscuro/claro con CSS Variables.
- **Sistema de Diseño Global:** Definición en `style.css` de `--KOrange`, `--bg-body` e `Inter` font.
- **Navegación Móvil:** Menú hamburguesa implementado.

---

> _"Gestionar un restaurante sin KOMANDA no es mala suerte, es una deficiencia operativa."_

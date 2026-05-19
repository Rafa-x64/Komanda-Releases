# 🚀 KOMANDA — Sistema Integral de Gestión Contable y Operativa para Restaurantes

[![Monorepo](https://img.shields.io/badge/Workspace-pnpm-F6A90A?style=for-the-badge&logo=pnpm&logoColor=white)](https://pnpm.io/)
[![Frontend](https://img.shields.io/badge/Frontend-Vue%203%20%2B%20Vite-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white)](https://vuejs.org/)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%2B%20Express-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![Database](https://img.shields.io/badge/Database-PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](./LICENSE)

**Komanda** es un moderno sistema contable y operativo híbrido de clase empresarial (SaaS) estructurado bajo un monorepo modular. Diseñado específicamente para optimizar la cadena de valor de restaurantes medianos y grandes, automatiza desde la comanda física en mesa hasta el balance general y estado de resultados bajo normas contables estándares.

Esta es la **distribución pública y compilada (Release)** de la plataforma, lista para ser instalada e iniciada con cero configuraciones de desarrollo complejas.

> [!IMPORTANT]
> **Esta versión está empaquetada para producción:** Todos los archivos TypeScript y Vue 3 han sido transpi-lados y obfuscados a código JavaScript nativo minificado. Tu código de desarrollo está a salvo, y los usuarios finales tienen todo lo necesario para correr el sistema de forma veloz e íntegra.

---

## 🌟 Características Destacadas

* 🏪 **Almacén e Inventario Inteligente (CPP):** Cálculo automático del **Costo Promedio Ponderado** en cada compra de insumos con control de stock crítico y mermas.
* 🍽️ **Menú, Recetas y Costeo en Tiempo Real:** Fórmulas de platos dinámicas vinculadas al inventario que calculan costos de producción al instante y sugieren márgenes de ganancia.
* 💳 **Punto de Venta Unificado (POS):** Cola de cobro centralizada orientada al cajero con soporte de múltiples transacciones cruzadas (Efectivo, Pago Móvil, Tarjeta, Divisas en cobros mixtos).
* 🍽️ **KDS Monitor de Cocina (Tiempo Real):** Flujo síncrono mediante WebSockets nativos que conecta al cajero, mesa, mesero y monitores de preparación de forma instantánea.
* 💰 **Contabilidad Automatizada:** Asientos de partida doble en el Libro Diario generados de forma atómica por cada compra, venta o gasto operativo.
* 📊 **Dashboard Gerencial Analítico:** KPIs financieros reales de ventas netas, costos acumulados y reportes exportables de rentabilidad de recetas.

---

## 📂 Estructura del Empaquetado Público

Las compilaciones de producción de esta release están organizadas de forma limpia en el workspace:

```text
releases/
├── 📂 database/
│   └── 📜 Database_Komanda.sql          # Esquema y semillas PostgreSQL listos para restaurar
├── 📂 Komanda-api/
│   ├── 📂 dist/                         # Servidor Express compilado en JavaScript (.js)
│   ├── 📜 .env.example                  # Plantilla de variables de entorno para producción
│   └── 📜 package.json                  # Dependencias productivas del Backend
├── 📂 Komanda-web/
│   └── 📂 dist/                         # Bundle estático del Frontend optimizado (HTML/CSS/JS)
├── 📜 package.json                      # Orquestador del Monorepo de producción
└── 📜 pnpm-workspace.yaml              # Configuración simplificada de espacios de trabajo
```

---

## 🛠️ Guía de Instalación y Despliegue Rápido

Sigue estos 3 simples pasos para poner en marcha **Komanda** en tu servidor local o de producción:

### 1️⃣ Inicializar la Base de Datos (PostgreSQL)
Abre tu consola de PostgreSQL o tu cliente gráfico (ej: PGAdmin, DBeaver) y ejecuta:
1. Crea una base de datos vacía llamada `komanda_db`.
2. Restaura el esquema y las semillas iniciales desde el archivo provisto en la release:
   ```bash
   psql -U postgres -d komanda_db -f database/Database_Komanda.sql
   ```

### 2️⃣ Configurar Entorno del Backend
1. Entra a la carpeta de la API: `cd Komanda-api`
2. Renombra o duplica el archivo `.env.example` a `.env`:
   ```bash
   cp .env.example .env
   ```
3. Edita las variables de entorno de tu archivo `.env` según tu base de datos local:
   ```env
   PORT=3000
   NODE_ENV=production

   # Conexión a tu Postgres
   DB_HOST=localhost
   DB_PORT=5432
   DB_USER=postgres
   DB_PASSWORD=tu_contrasena_aqui
   DB_NAME=komanda_db
   ```

### 3️⃣ Instalar y Levantar el Monorepo
Regresa a la raíz de la carpeta `releases/` y arranca la aplicación completa en un solo comando:
```bash
# 1. Instalar dependencias de producción y herramientas de servidor
pnpm install

# 2. Levantar el ecosistema completo (POS, Backend y PHP de soporte)
pnpm start
```

> [!NOTE]
> `pnpm start` utiliza `concurrently` para levantar de forma orquestada:
> * **El Frontend Web** en el puerto `5173` corriendo sobre un servidor estático ultraligero y optimizado (`serve`).
>   * *Acceso:* `http://localhost:5173`
> * **La API del Backend** corriendo en Express sobre el puerto `3000`.
>   * *Acceso:* `http://localhost:3000`
> * **El servidor PHP** de soporte ejecutándose en el puerto `8000`.
>   * *Acceso:* `http://localhost:8000`

---

## 📜 Historial de Cambios Recientes (Changelog)

A continuación se destacan las últimas mejoras incorporadas en esta distribución:

### 🚀 v0.4.0 — ¡La Release Definitiva de Producción! (Última Actualización)
* **Empaquetador Automatizado Blindado (`build-release.sh`):** Implementación de un script inteligente y blindado en bash que transpila, obfuscación y empaqueta el frontend y backend en JavaScript nativo eliminando el código fuente original para proteger el 100% de la propiedad intelectual.
* **Orquestador Monorepo de Producción:** Creación de los archivos maestros de pnpm que permiten a los usuarios finales instalar y levantar todo el sistema (POS, API y PHP) con un solo comando unificado `pnpm start`.
* **Aislamiento Estricto Multi-Tenant:** Corrección definitiva del asignador secuencial de códigos de pedidos a nivel de base de datos para asegurar el aislamiento de datos por restaurante y evitar colisiones entre sucursales.
* **Globalización de Métodos de Pago:** Transición de métodos de pago universales cargados automáticamente por semilla en la base de datos a nivel SaaS.
* **Cero Errores de Tipado en Backend:** Resueltas las 8 advertencias de tipado estricto en TypeScript (`get_schema.ts`, validadores Zod con `message`, `kitchen.service.ts` y campos de perfil en `settings.controller.ts`) para una compilación 100% limpia y óptima.
* **Estabilización Contable y de Dashboard:** Redirección de KPIs y métricas del panel administrativo a la vista real `contabilidad.v_estado_resultados`, solucionando el problema de datos vacíos.
* **Recetas con Costo Real (CPP):** Sincronización del costo ponderado dinámico para recetas e ingredientes, eliminando valores en cero en el Reporte de Rentabilidad.

### 🚀 v0.3.0
* **Dashboard Analítico Real:** Sustitución de datos simulados por KPIs reales y soporte de pronósticos predictivos a 7 días.
* **Sincronización POS/KDS en Tiempo Real:** WebSocket nativo robustecido para conectar la toma de comanda del mesero y el monitor de cocina instantáneamente.
* **Resolución de Conflictos de Puertos:** Control automático de procesos zombies en el puerto 3000 (EADDRINUSE).

---

## 🔒 Licencia y Seguridad

El software se distribuye compilado bajo licencia comercial privada del autor. Queda prohibida la descompilación o ingeniería inversa del bundle distribuido en esta carpeta de releases para propósitos comerciales no autorizados.

---

> _"Gestionar un restaurante sin KOMANDA no es mala suerte, es una deficiencia operativa."_

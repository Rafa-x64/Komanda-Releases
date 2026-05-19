# 🚀 KOMANDA | The Ultimate Restaurant OS

> "Gestionar un restaurante sin KOMANDA no es mala suerte, es una deficiencia operativa."

Bienvenido al repositorio de **KOMANDA**. Si estás aquí es porque entiendes que el caos en la cocina y la administración no se arregla con más personal, sino con mejor software. Este es un sistema con visión de **SaaS** diseñado para aniquilar la ineficiencia en inventarios, ventas, nóminas y pedidos. No estamos inventando la rueda, la estamos haciendo de fibra de carbono para que ruede sola.

---

## 📌 Tabla de Contenidos

1. [🧠 La Filosofía (Arquitectura > Improvisación)](#la-filosofía-arquitectura-improvisación)
2. [✨ Módulos Principales](#módulos-principales)
   - [📦 Inventario & Back-flushing (El Núcleo)](#inventario-back-flushing-el-núcleo)
   - [🧾 Ventas & POS (Point of Sale)](#ventas-pos-point-of-sale)
   - [🍳 Cocina en Tiempo Real (KDS)](#cocina-en-tiempo-real-kds)
   - [💰 Pagos & Nómina](#pagos-nómina)
3. [🛠 Tech Stack](#tech-stack)
4. [📂 Estructura del Proyecto](#estructura-del-proyecto)
5. [🚀 Guía de Instalación](#guía-de-instalación)
6. [🏆 Reglas de Oro](#reglas-de-oro-no-las-rompas-o-mal-por-todos)

---

## 🧠 La Filosofía (Arquitectura > Improvisación)

Este proyecto no es un "reguero" más. Está construido bajo una **Arquitectura Modular (Domain-Driven Design Lite)**.

¿Qué significa esto para ti como dev? Que el sistema se divide en **unidades de negocio autónomas**. Si mañana quieres cambiar el módulo de Nómina, no tienes que rezar para que no explote el Inventario. Todo está separado, desacoplado y listo para escalar a mil sucursales si es necesario.

---

## ✨ Módulos Principales

### 📦 Inventario & Back-flushing (El Núcleo)

El inventario es el corazón logístico. Aquí aplicamos **Back-flushing**:

- **Descuento Atómico:** Al confirmar una comanda de 2 Sándwiches Italianos, el sistema consulta la **Receta** y descuenta exactamente la proporción (ej. 200g de tomate, 4 panes).
- **Trazabilidad:** Manejamos Unidades de compra (Sacos/Kilos) vs Unidades de consumo (Gramos/Unidades).
- **Alertas de Re-orden:** Notificaciones automáticas cuando el stock llega al punto crítico. Evita el "se nos acabó la carne" en pleno servicio.

### 🧾 Ventas & POS (Point of Sale)

- Generación de facturas instantáneas.
- Afiliación de clientes para fidelización.
- Integración directa con el flujo de caja y reportes financieros.

### 🍳 Cocina en Tiempo Real (KDS)

- **WebSockets al poder:** Los pedidos llegan de la Tablet del mesero a la pantalla del chef instantáneamente.
- **Cronómetro de Pedidos:** Visualización del tiempo de espera para optimizar el servicio y evitar cuellos de botella.

### 💰 Pagos & Nómina

- **Gestión de Gastos:** Registro de servicios (luz, agua, gas) y cuentas por pagar a proveedores.
- **Comisiones por Desempeño:** Cálculo automático de pagos basado en productividad. Premiamos a los que más "carrean" el restaurante.

---

## 🛠 Tech Stack & Arquitectura

### 🧠 La Filosofía (Arquitectura > Improvisación)

Este proyecto no es un "reguero" más. Está construido bajo una **Arquitectura Híbrida Modular (Domain-Driven Design Lite)**.
¿Qué significa esto para ti como dev? Que el sistema se divide en **unidades de negocio autónomas**. Si mañana quieres cambiar el módulo de Nómina, no tienes que rezar para que no explote el Inventario. Todo está separado, desacoplado y listo para escalar a mil sucursales si es necesario.

### 🌐 Frontend (Komanda-web)

- **Framework Principal:** Vue 3 (Usando estrictamente **Composition API** y la etiqueta `<script setup>`).
- **Build Tool:** Vite (Desarrollo ultrarrápido y compilación optimizada).
- **Lenguaje:** TypeScript / JavaScript.
- **Estilos y UI:**
  - Vanilla CSS (Usando CSS Variables personalizadas para los temas, colores como `--KOrange` y `--bg-body`).
  - Bootstrap 5 (Para el sistema de grid fluido, utilities y componentes base).
- **Enrutamiento:** Vue Router.
- **Iconografía:** Lucide Vue Next (`lucide-vue-next`) y Bootstrap Icons (`bi`).

### ⚙️ Backend (Komanda-api)

- **Arquitectura:** Híbrida y modular (DDD-Lite).
- **Entornos de Ejecución:**
  - Node.js (Principal motor para APIs RESTful de alto rendimiento y WebSockets).
  - PHP (Acompañando lógica heredada o endpoints específicos).
- **Framework Node:** Express.js.
- **Lenguaje (Node):** TypeScript (Tipado estricto pero pragmático).
- **Validaciones (Input):** Zod (Para validar fuertemente los esquemas de entrada antes de que toquen los controladores).

### 🗄️ Base de Datos

- **Motor:** PostgreSQL.
- **Reglas de Diseño:**
  - Nombres de tablas siempre en **plural y en inglés** (Ej: `users`, `orders`).
  - Columnas siempre en **snake_case** (Ej: `created_at`).

### 📦 Gestión y Herramientas del Proyecto

- **Estructura del Proyecto:** Monorepo.
- **Gestor de Paquetes:** `pnpm` (o en su defecto `bun`). Obligatorio para instalar dependencias y gestionar los workspaces del monorepo rápidamente.
- **Tiempo Real:** WebSockets (Sincronización letal entre la vista del Mesero y el KDS de Cocina).

---

## 📂 Estructura del Proyecto

Mantenemos una simetría entre Front y Back para que no te pierdas en el limbo de las carpetas.

#### Link al documento de estructura: [STRUCTURE.md](./docs/STRUCTURE.md)

---

## 🚀 Guía de Instalación

Para que no pierdas tiempo peleando con el entorno, hemos preparado guías específicas según tu sistema operativo. Elige la tuya y estarás listo en minutos:

- 🐧 [**Guía para Debian**](./docs/instalation-guides/DEBIAN.MD) (Stable/Testing)
- 🧡 [**Guía para Ubuntu**](./docs/instalation-guides/UBUNTU.MD) (Server/Desktop)
- 🪟 [**Guía para Windows**](./docs/instalation-guides/WINDOWS.MD) (PowerShell/Winget)

### Inicio rápido (Universal)

Si ya tienes el entorno listo (Node v20+, Postgres, pnpm):

```bash
# 1. Clona el repo y actualiza
git clone https://github.com/Rafa-x64/Komanda.git
cd Komanda
git pull origin master

# 2. Instala dependencias (Monorepo)
pnpm install

# 3. Importación y configuración de la base de datos
# Asegúrate de crear la base de datos "komanda_db" en tu PostgreSQL
# Pudes usar psql para importar si tienes un dump o crearla directamente
# psql -U postgres -c "CREATE DATABASE komanda_db;"

# 4. Configura variables
cp .env.example .env
# IMPORTANTE: Asegurate de ingresar tus credenciales de Postgres en el .env
# DB_PORT=5432
# DB_USER=postgres
# DB_PASSWORD=postgres
# DB_NAME=komanda_db

# 5. Corre todo el ecosistema (API + Web)
pnpm run komanda
```

---

## 🏆 Reglas de Oro (No las rompas o mal por todos)

- **Código Minimalista:** Si funciona en 3 líneas de forma legible, no escribas 10.
- **Clean Code:** Nada de comentarios obvios. El código debe leerse como una novela.
- **Modularidad Total:** Prohibido importar lógica de un módulo a otro de forma directa. Usa servicios compartidos o eventos.
- **Optimización:** Cada query a la DB cuenta. No traigas el mundo entero si solo necesitas un ID.

---

> PD: Desarrollado con ❤️ (y mucha terminal) por un fanático del minimalismo extremo. ¿Dudas? Abre un issue o simplemente haz un buen PR.

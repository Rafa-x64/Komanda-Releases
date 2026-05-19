--
-- PostgreSQL database dump
--

\restrict mG8YTp6RWD4QMwFrZeqlkC4EwIFbE2Z9W1YcLMTWijrC4IHeQvY1m5Yxf7GImPc

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-19 00:30:49 -04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 19016)
-- Name: contabilidad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contabilidad;


ALTER SCHEMA contabilidad OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 19017)
-- Name: core; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 19018)
-- Name: finanzas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA finanzas;


ALTER SCHEMA finanzas OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 19019)
-- Name: inventario; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventario;


ALTER SCHEMA inventario OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 19020)
-- Name: inventory; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventory;


ALTER SCHEMA inventory OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 19021)
-- Name: menu; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA menu;


ALTER SCHEMA menu OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 19022)
-- Name: operaciones; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA operaciones;


ALTER SCHEMA operaciones OWNER TO postgres;

--
-- TOC entry 14 (class 2615 OID 19023)
-- Name: sales; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sales;


ALTER SCHEMA sales OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 19024)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4531 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 995 (class 1247 OID 19036)
-- Name: categoria_gasto_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.categoria_gasto_enum AS ENUM (
    'agua',
    'gas',
    'electricidad',
    'internet',
    'alquiler',
    'otros'
);


ALTER TYPE public.categoria_gasto_enum OWNER TO postgres;

--
-- TOC entry 4532 (class 0 OID 0)
-- Dependencies: 995
-- Name: TYPE categoria_gasto_enum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.categoria_gasto_enum IS 'Gastos operativos fijos según enunciado académico: agua, gas, electricidad, internet, alquiler';


--
-- TOC entry 998 (class 1247 OID 19048)
-- Name: estado_caja; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_caja AS ENUM (
    'abierta',
    'cerrada'
);


ALTER TYPE public.estado_caja OWNER TO postgres;

--
-- TOC entry 1001 (class 1247 OID 19054)
-- Name: estado_cuenta; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_cuenta AS ENUM (
    'abierta',
    'cuenta_pedida',
    'pagada',
    'cerrada'
);


ALTER TYPE public.estado_cuenta OWNER TO postgres;

--
-- TOC entry 1004 (class 1247 OID 19064)
-- Name: estado_factura; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_factura AS ENUM (
    'emitida',
    'anulada'
);


ALTER TYPE public.estado_factura OWNER TO postgres;

--
-- TOC entry 1007 (class 1247 OID 19070)
-- Name: estado_mesa; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_mesa AS ENUM (
    'libre',
    'ocupada',
    'reservada',
    'inactiva'
);


ALTER TYPE public.estado_mesa OWNER TO postgres;

--
-- TOC entry 1010 (class 1247 OID 19080)
-- Name: estado_pago_compra; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_pago_compra AS ENUM (
    'pendiente',
    'pagada',
    'parcial'
);


ALTER TYPE public.estado_pago_compra OWNER TO postgres;

--
-- TOC entry 1013 (class 1247 OID 19088)
-- Name: estado_pedido; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_pedido AS ENUM (
    'pendiente',
    'enviado',
    'preparando',
    'listo',
    'entregado',
    'anulado'
);


ALTER TYPE public.estado_pedido OWNER TO postgres;

--
-- TOC entry 1016 (class 1247 OID 19102)
-- Name: estado_reserva; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_reserva AS ENUM (
    'pendiente',
    'confirmada',
    'cancelada',
    'completada',
    'no_show'
);


ALTER TYPE public.estado_reserva OWNER TO postgres;

--
-- TOC entry 1019 (class 1247 OID 19114)
-- Name: metodo_pago_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.metodo_pago_enum AS ENUM (
    'efectivo',
    'pago_movil',
    'tarjeta',
    'divisa'
);


ALTER TYPE public.metodo_pago_enum OWNER TO postgres;

--
-- TOC entry 4533 (class 0 OID 0)
-- Dependencies: 1019
-- Name: TYPE metodo_pago_enum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.metodo_pago_enum IS 'Métodos de pago aceptados: efectivo (Bs), pago_movil (transferencia), tarjeta (débito/crédito), divisa (USD/EUR físico)';


--
-- TOC entry 1022 (class 1247 OID 19124)
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'preparing',
    'ready',
    'delivered',
    'cancelled'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- TOC entry 1025 (class 1247 OID 19136)
-- Name: orders_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.orders_status_enum AS ENUM (
    'pending',
    'preparing',
    'ready',
    'delivered',
    'cancelled'
);


ALTER TYPE public.orders_status_enum OWNER TO postgres;

--
-- TOC entry 1028 (class 1247 OID 19148)
-- Name: referencia_tipo_banco; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.referencia_tipo_banco AS ENUM (
    'venta',
    'egreso',
    'compra',
    'deposito_caja',
    'ajuste'
);


ALTER TYPE public.referencia_tipo_banco OWNER TO postgres;

--
-- TOC entry 1031 (class 1247 OID 19160)
-- Name: referencia_tipo_caja; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.referencia_tipo_caja AS ENUM (
    'venta',
    'egreso',
    'compra',
    'apertura',
    'cierre',
    'ajuste'
);


ALTER TYPE public.referencia_tipo_caja OWNER TO postgres;

--
-- TOC entry 1034 (class 1247 OID 19174)
-- Name: tipo_cuenta_contable_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_cuenta_contable_enum AS ENUM (
    'activo',
    'pasivo',
    'patrimonio',
    'ingreso',
    'costo',
    'gasto'
);


ALTER TYPE public.tipo_cuenta_contable_enum OWNER TO postgres;

--
-- TOC entry 1037 (class 1247 OID 19188)
-- Name: tipo_merma; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_merma AS ENUM (
    'desperdicio',
    'vencimiento',
    'rotura',
    'otro'
);


ALTER TYPE public.tipo_merma OWNER TO postgres;

--
-- TOC entry 1040 (class 1247 OID 19198)
-- Name: tipo_movimiento; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_movimiento AS ENUM (
    'ingreso',
    'egreso'
);


ALTER TYPE public.tipo_movimiento OWNER TO postgres;

--
-- TOC entry 362 (class 1255 OID 19203)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 19204)
-- Name: asiento_lineas; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.asiento_lineas (
    id integer NOT NULL,
    asiento_id integer NOT NULL,
    cuenta_id integer NOT NULL,
    tipo_movimiento character varying(5) NOT NULL,
    monto numeric(12,2) NOT NULL,
    descripcion character varying(255),
    restaurante_id integer NOT NULL,
    CONSTRAINT asiento_lineas_monto_check CHECK ((monto > (0)::numeric)),
    CONSTRAINT asiento_lineas_tipo_movimiento_check CHECK (((tipo_movimiento)::text = ANY (ARRAY[('debe'::character varying)::text, ('haber'::character varying)::text])))
);


ALTER TABLE contabilidad.asiento_lineas OWNER TO postgres;

--
-- TOC entry 4534 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE asiento_lineas; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.asiento_lineas IS 'Líneas de cada asiento contable. Cada asiento tiene N líneas (min. 2: un Debe y un Haber).
La suma de todas las líneas tipo "debe" debe ser igual a la suma de las "haber" en el mismo asiento.
Ejemplo para una Venta:
  DEBE:  Caja/Banco            500.00
  HABER: Ingresos por Ventas   500.00
  DEBE:  Costo de Ventas       180.00
  HABER: Inventario            180.00';


--
-- TOC entry 4535 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN asiento_lineas.tipo_movimiento; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.asiento_lineas.tipo_movimiento IS 'debe = cargo a la cuenta | haber = abono a la cuenta (partida doble)';


--
-- TOC entry 229 (class 1259 OID 19215)
-- Name: asiento_lineas_id_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.asiento_lineas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.asiento_lineas_id_seq OWNER TO postgres;

--
-- TOC entry 4536 (class 0 OID 0)
-- Dependencies: 229
-- Name: asiento_lineas_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.asiento_lineas_id_seq OWNED BY contabilidad.asiento_lineas.id;


--
-- TOC entry 230 (class 1259 OID 19216)
-- Name: asientos; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.asientos (
    id integer NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(255) NOT NULL,
    origen_tipo character varying(50),
    origen_id integer,
    total_debe numeric(12,2) DEFAULT 0 NOT NULL,
    total_haber numeric(12,2) DEFAULT 0 NOT NULL,
    restaurante_id integer NOT NULL,
    creado_por integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE contabilidad.asientos OWNER TO postgres;

--
-- TOC entry 4537 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE asientos; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.asientos IS 'Cabecera del asiento contable. Cada evento del sistema (venta, compra, gasto) genera
un asiento automáticamente. INVARIANTE: total_debe = total_haber (principio de partida doble).';


--
-- TOC entry 4538 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN asientos.origen_tipo; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.asientos.origen_tipo IS 'venta: pedido pagado | compra: entrada de mercancía | gasto_operativo: agua/luz/etc | costo_venta: back-flushing';


--
-- TOC entry 231 (class 1259 OID 19228)
-- Name: asientos_id_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.asientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.asientos_id_seq OWNER TO postgres;

--
-- TOC entry 4539 (class 0 OID 0)
-- Dependencies: 231
-- Name: asientos_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.asientos_id_seq OWNED BY contabilidad.asientos.id;


--
-- TOC entry 232 (class 1259 OID 19229)
-- Name: libro_diario; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.libro_diario (
    id integer NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(255) NOT NULL,
    tipo character varying(50) NOT NULL,
    debe numeric(12,2) DEFAULT 0 NOT NULL,
    haber numeric(12,2) DEFAULT 0 NOT NULL,
    referencia_tipo character varying(50),
    referencia_id integer,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE contabilidad.libro_diario OWNER TO postgres;

--
-- TOC entry 4540 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE libro_diario; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.libro_diario IS 'Asientos contables para generar Balance General y Estado de Resultados';


--
-- TOC entry 4541 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN libro_diario.tipo; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.libro_diario.tipo IS 'Ej: venta, costo_venta, gasto_operativo, compra_insumo, merma';


--
-- TOC entry 233 (class 1259 OID 19242)
-- Name: libro_diario_id_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.libro_diario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.libro_diario_id_seq OWNER TO postgres;

--
-- TOC entry 4542 (class 0 OID 0)
-- Dependencies: 233
-- Name: libro_diario_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.libro_diario_id_seq OWNED BY contabilidad.libro_diario.id;


--
-- TOC entry 234 (class 1259 OID 19243)
-- Name: plan_cuentas; Type: TABLE; Schema: contabilidad; Owner: postgres
--

CREATE TABLE contabilidad.plan_cuentas (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    tipo public.tipo_cuenta_contable_enum NOT NULL,
    padre_id integer,
    es_auxiliar boolean DEFAULT true,
    restaurante_id integer,
    activo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE contabilidad.plan_cuentas OWNER TO postgres;

--
-- TOC entry 4543 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE plan_cuentas; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON TABLE contabilidad.plan_cuentas IS 'Plan de Cuentas Contable. Estructura jerárquica (padre_id) que permite generar
Balance General y Estado de Resultados agrupando por tipo de cuenta.
Las cuentas globales (restaurante_id IS NULL) aplican a todos los restaurantes.';


--
-- TOC entry 4544 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN plan_cuentas.codigo; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON COLUMN contabilidad.plan_cuentas.codigo IS 'Código contable estándar. Ej: 1=Activo, 2=Pasivo, 3=Patrimonio, 4=Ingreso, 5=Costo, 6=Gasto';


--
-- TOC entry 235 (class 1259 OID 19253)
-- Name: plan_cuentas_id_seq; Type: SEQUENCE; Schema: contabilidad; Owner: postgres
--

CREATE SEQUENCE contabilidad.plan_cuentas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contabilidad.plan_cuentas_id_seq OWNER TO postgres;

--
-- TOC entry 4545 (class 0 OID 0)
-- Dependencies: 235
-- Name: plan_cuentas_id_seq; Type: SEQUENCE OWNED BY; Schema: contabilidad; Owner: postgres
--

ALTER SEQUENCE contabilidad.plan_cuentas_id_seq OWNED BY contabilidad.plan_cuentas.id;


--
-- TOC entry 236 (class 1259 OID 19254)
-- Name: restaurante; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.restaurante (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    direccion text,
    telefono character varying(20),
    email character varying(100),
    logo_url text,
    moneda character varying(3) DEFAULT 'USD'::character varying NOT NULL,
    zona_horaria character varying(50) DEFAULT 'America/Caracas'::character varying NOT NULL,
    impuesto_porcentaje numeric(5,2) DEFAULT 0 NOT NULL,
    propina_porcentaje numeric(5,2) DEFAULT 0 NOT NULL,
    patrimonio_inicial numeric(12,2) DEFAULT 0 NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.restaurante OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 19277)
-- Name: v_balance_general; Type: VIEW; Schema: contabilidad; Owner: postgres
--

CREATE VIEW contabilidad.v_balance_general AS
 SELECT r.id AS restaurante_id,
    r.nombre AS restaurante,
    pc.tipo,
    pc.codigo,
    pc.nombre AS cuenta,
    COALESCE(sum(
        CASE al.tipo_movimiento
            WHEN 'debe'::text THEN
            CASE
                WHEN ((pc.tipo)::text = ANY (ARRAY['activo'::text, 'costo'::text, 'gasto'::text])) THEN al.monto
                ELSE (- al.monto)
            END
            WHEN 'haber'::text THEN
            CASE
                WHEN ((pc.tipo)::text = ANY (ARRAY['activo'::text, 'costo'::text, 'gasto'::text])) THEN (- al.monto)
                ELSE al.monto
            END
            ELSE NULL::numeric
        END), (0)::numeric) AS saldo
   FROM (((contabilidad.plan_cuentas pc
     CROSS JOIN core.restaurante r)
     LEFT JOIN contabilidad.asiento_lineas al ON (((al.cuenta_id = pc.id) AND (al.restaurante_id = r.id))))
     LEFT JOIN contabilidad.asientos a ON (((a.id = al.asiento_id) AND (a.restaurante_id = r.id))))
  WHERE (pc.es_auxiliar = true)
  GROUP BY r.id, r.nombre, pc.tipo, pc.codigo, pc.nombre
  ORDER BY pc.codigo;


ALTER VIEW contabilidad.v_balance_general OWNER TO postgres;

--
-- TOC entry 4546 (class 0 OID 0)
-- Dependencies: 237
-- Name: VIEW v_balance_general; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON VIEW contabilidad.v_balance_general IS 'Vista del Balance General y Estado de Resultados. Filtrar por restaurante_id y rango de fechas
usando JOIN con contabilidad.asientos.';


--
-- TOC entry 238 (class 1259 OID 19282)
-- Name: v_estado_resultados; Type: VIEW; Schema: contabilidad; Owner: postgres
--

CREATE VIEW contabilidad.v_estado_resultados AS
 SELECT al.restaurante_id,
    a.fecha,
    pc.tipo,
    pc.nombre AS cuenta,
    sum(
        CASE al.tipo_movimiento
            WHEN 'debe'::text THEN
            CASE
                WHEN ((pc.tipo)::text = ANY (ARRAY['costo'::text, 'gasto'::text])) THEN al.monto
                ELSE (- al.monto)
            END
            WHEN 'haber'::text THEN
            CASE
                WHEN ((pc.tipo)::text = 'ingreso'::text) THEN al.monto
                ELSE (- al.monto)
            END
            ELSE NULL::numeric
        END) AS monto
   FROM ((contabilidad.asiento_lineas al
     JOIN contabilidad.asientos a ON ((a.id = al.asiento_id)))
     JOIN contabilidad.plan_cuentas pc ON ((pc.id = al.cuenta_id)))
  WHERE ((pc.tipo)::text = ANY (ARRAY['ingreso'::text, 'costo'::text, 'gasto'::text]))
  GROUP BY al.restaurante_id, a.fecha, pc.tipo, pc.nombre
  ORDER BY a.fecha, (pc.tipo)::text;


ALTER VIEW contabilidad.v_estado_resultados OWNER TO postgres;

--
-- TOC entry 4547 (class 0 OID 0)
-- Dependencies: 238
-- Name: VIEW v_estado_resultados; Type: COMMENT; Schema: contabilidad; Owner: postgres
--

COMMENT ON VIEW contabilidad.v_estado_resultados IS 'Estado de Resultados por fecha. Para obtener el total de un período:
SELECT tipo, cuenta, SUM(monto) FROM contabilidad.v_estado_resultados
WHERE restaurante_id = X AND fecha BETWEEN inicio AND fin
GROUP BY tipo, cuenta;';


--
-- TOC entry 239 (class 1259 OID 19287)
-- Name: metodos_pago; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.metodos_pago (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE core.metodos_pago OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 19295)
-- Name: metodos_pago_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.metodos_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.metodos_pago_id_seq OWNER TO postgres;

--
-- TOC entry 4548 (class 0 OID 0)
-- Dependencies: 240
-- Name: metodos_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.metodos_pago_id_seq OWNED BY core.metodos_pago.id;


--
-- TOC entry 241 (class 1259 OID 19296)
-- Name: restaurante_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.restaurante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.restaurante_id_seq OWNER TO postgres;

--
-- TOC entry 4549 (class 0 OID 0)
-- Dependencies: 241
-- Name: restaurante_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.restaurante_id_seq OWNED BY core.restaurante.id;


--
-- TOC entry 242 (class 1259 OID 19297)
-- Name: roles; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.roles OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 19304)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.roles_id_seq OWNER TO postgres;

--
-- TOC entry 4550 (class 0 OID 0)
-- Dependencies: 243
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.roles_id_seq OWNED BY core.roles.id;


--
-- TOC entry 244 (class 1259 OID 19305)
-- Name: tables; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.tables (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    capacidad integer DEFAULT 2,
    status character varying(20) DEFAULT 'available'::character varying
);


ALTER TABLE core.tables OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 19312)
-- Name: tables_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.tables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.tables_id_seq OWNER TO postgres;

--
-- TOC entry 4551 (class 0 OID 0)
-- Dependencies: 245
-- Name: tables_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.tables_id_seq OWNED BY core.tables.id;


--
-- TOC entry 246 (class 1259 OID 19313)
-- Name: unidad_medida; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.unidad_medida (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    abreviatura character varying(5) NOT NULL
);


ALTER TABLE core.unidad_medida OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 19319)
-- Name: unidad_medida_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.unidad_medida_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.unidad_medida_id_seq OWNER TO postgres;

--
-- TOC entry 4552 (class 0 OID 0)
-- Dependencies: 247
-- Name: unidad_medida_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.unidad_medida_id_seq OWNED BY core.unidad_medida.id;


--
-- TOC entry 248 (class 1259 OID 19320)
-- Name: usuarios; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.usuarios (
    id integer NOT NULL,
    restaurante_id integer NOT NULL,
    rol_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.usuarios OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 19338)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: core; Owner: postgres
--

CREATE SEQUENCE core.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 4553 (class 0 OID 0)
-- Dependencies: 249
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: postgres
--

ALTER SEQUENCE core.usuarios_id_seq OWNED BY core.usuarios.id;


--
-- TOC entry 250 (class 1259 OID 19339)
-- Name: banco; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.banco (
    id integer NOT NULL,
    nombre_banco character varying(100) NOT NULL,
    numero_cuenta character varying(50) NOT NULL,
    saldo_actual numeric(12,2) DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE finanzas.banco OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 19350)
-- Name: banco_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.banco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.banco_id_seq OWNER TO postgres;

--
-- TOC entry 4554 (class 0 OID 0)
-- Dependencies: 251
-- Name: banco_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.banco_id_seq OWNED BY finanzas.banco.id;


--
-- TOC entry 252 (class 1259 OID 19351)
-- Name: banco_movimientos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.banco_movimientos (
    id integer NOT NULL,
    banco_id integer NOT NULL,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tipo public.tipo_movimiento NOT NULL,
    monto numeric(12,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    referencia_tipo public.referencia_tipo_banco NOT NULL,
    referencia_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE finanzas.banco_movimientos OWNER TO postgres;

--
-- TOC entry 4555 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE banco_movimientos; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON TABLE finanzas.banco_movimientos IS 'Movimientos bancarios con trazabilidad polimórfica';


--
-- TOC entry 253 (class 1259 OID 19365)
-- Name: banco_movimientos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.banco_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.banco_movimientos_id_seq OWNER TO postgres;

--
-- TOC entry 4556 (class 0 OID 0)
-- Dependencies: 253
-- Name: banco_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.banco_movimientos_id_seq OWNED BY finanzas.banco_movimientos.id;


--
-- TOC entry 254 (class 1259 OID 19366)
-- Name: caja; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.caja (
    id integer NOT NULL,
    fecha_apertura timestamp without time zone NOT NULL,
    fecha_cierre timestamp without time zone,
    monto_inicial numeric(12,2) NOT NULL,
    monto_final numeric(12,2),
    monto_teorico numeric(12,2),
    diferencia numeric(12,2),
    estado public.estado_caja DEFAULT 'abierta'::public.estado_caja,
    usuario_apertura_id integer NOT NULL,
    usuario_cierre_id integer,
    observaciones text,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE finanzas.caja OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 19378)
-- Name: caja_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.caja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.caja_id_seq OWNER TO postgres;

--
-- TOC entry 4557 (class 0 OID 0)
-- Dependencies: 255
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.caja_id_seq OWNED BY finanzas.caja.id;


--
-- TOC entry 256 (class 1259 OID 19379)
-- Name: caja_movimientos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.caja_movimientos (
    id integer NOT NULL,
    caja_id integer NOT NULL,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tipo public.tipo_movimiento NOT NULL,
    monto numeric(12,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    referencia_tipo public.referencia_tipo_caja NOT NULL,
    referencia_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE finanzas.caja_movimientos OWNER TO postgres;

--
-- TOC entry 4558 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE caja_movimientos; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON TABLE finanzas.caja_movimientos IS 'Movimientos de efectivo con trazabilidad polimórfica';


--
-- TOC entry 257 (class 1259 OID 19393)
-- Name: caja_movimientos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.caja_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.caja_movimientos_id_seq OWNER TO postgres;

--
-- TOC entry 4559 (class 0 OID 0)
-- Dependencies: 257
-- Name: caja_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.caja_movimientos_id_seq OWNED BY finanzas.caja_movimientos.id;


--
-- TOC entry 258 (class 1259 OID 19394)
-- Name: egresos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.egresos (
    id integer NOT NULL,
    fecha date NOT NULL,
    monto numeric(12,2) NOT NULL,
    categoria_id integer NOT NULL,
    razon character varying(255) NOT NULL,
    descripcion text,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE finanzas.egresos OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 19406)
-- Name: egresos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.egresos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.egresos_id_seq OWNER TO postgres;

--
-- TOC entry 4560 (class 0 OID 0)
-- Dependencies: 259
-- Name: egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.egresos_id_seq OWNED BY finanzas.egresos.id;


--
-- TOC entry 260 (class 1259 OID 19407)
-- Name: gastos_operativos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.gastos_operativos (
    id integer NOT NULL,
    categoria public.categoria_gasto_enum NOT NULL,
    descripcion character varying(255),
    monto numeric(12,2) NOT NULL,
    fecha date NOT NULL,
    metodo_pago public.metodo_pago_enum DEFAULT 'efectivo'::public.metodo_pago_enum NOT NULL,
    referencia character varying(100),
    periodo_mes integer,
    periodo_anio integer,
    usuario_id integer,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT gastos_operativos_monto_check CHECK ((monto > (0)::numeric)),
    CONSTRAINT gastos_operativos_periodo_mes_check CHECK (((periodo_mes >= 1) AND (periodo_mes <= 12)))
);


ALTER TABLE finanzas.gastos_operativos OWNER TO postgres;

--
-- TOC entry 4561 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE gastos_operativos; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON TABLE finanzas.gastos_operativos IS 'Gastos operativos fijos del restaurante. Según el enunciado académico solo se registran:
agua, gas, electricidad, internet y alquiler. Cada registro genera un asiento contable automático
en contabilidad.asientos (Debe: Gasto / Haber: Caja o Banco).';


--
-- TOC entry 4562 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN gastos_operativos.categoria; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON COLUMN finanzas.gastos_operativos.categoria IS 'Una de las 5 categorías del enunciado: agua, gas, electricidad, internet, alquiler.';


--
-- TOC entry 4563 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN gastos_operativos.periodo_mes; Type: COMMENT; Schema: finanzas; Owner: postgres
--

COMMENT ON COLUMN finanzas.gastos_operativos.periodo_mes IS 'Mes al que corresponde el gasto (puede diferir de la fecha de pago). Usado en Estado de Resultados.';


--
-- TOC entry 261 (class 1259 OID 19420)
-- Name: gastos_operativos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.gastos_operativos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.gastos_operativos_id_seq OWNER TO postgres;

--
-- TOC entry 4564 (class 0 OID 0)
-- Dependencies: 261
-- Name: gastos_operativos_id_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.gastos_operativos_id_seq OWNED BY finanzas.gastos_operativos.id;


--
-- TOC entry 262 (class 1259 OID 19421)
-- Name: categoria_egresos; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.categoria_egresos (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.categoria_egresos OWNER TO postgres;

--
-- TOC entry 4565 (class 0 OID 0)
-- Dependencies: 262
-- Name: COLUMN categoria_egresos.nombre; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.categoria_egresos.nombre IS 'Ej: proveedores, servicios, nomina, otros';


--
-- TOC entry 263 (class 1259 OID 19428)
-- Name: categoria_egresos_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.categoria_egresos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.categoria_egresos_id_seq OWNER TO postgres;

--
-- TOC entry 4566 (class 0 OID 0)
-- Dependencies: 263
-- Name: categoria_egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.categoria_egresos_id_seq OWNED BY inventario.categoria_egresos.id;


--
-- TOC entry 264 (class 1259 OID 19429)
-- Name: compra_detalle; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.compra_detalle (
    id integer NOT NULL,
    compra_id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad_compra numeric(10,3) NOT NULL,
    unidad_compra_id integer,
    precio_unitario numeric(10,2) NOT NULL,
    factor_conversion numeric(10,3) NOT NULL,
    cantidad_inventario numeric(10,3) GENERATED ALWAYS AS ((cantidad_compra * factor_conversion)) STORED,
    restaurante_id integer NOT NULL
);


ALTER TABLE inventario.compra_detalle OWNER TO postgres;

--
-- TOC entry 4567 (class 0 OID 0)
-- Dependencies: 264
-- Name: COLUMN compra_detalle.factor_conversion; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.compra_detalle.factor_conversion IS 'Multiplicador para convertir Unidad Compra -> Unidad Inventario (ej. 1 Saco = 50000 gr)';


--
-- TOC entry 265 (class 1259 OID 19441)
-- Name: compra_detalle_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.compra_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.compra_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 4568 (class 0 OID 0)
-- Dependencies: 265
-- Name: compra_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.compra_detalle_id_seq OWNED BY inventario.compra_detalle.id;


--
-- TOC entry 266 (class 1259 OID 19442)
-- Name: compras; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.compras (
    id integer NOT NULL,
    fecha date NOT NULL,
    numero_factura_proveedor character varying(50),
    total numeric(12,2) NOT NULL,
    estado_pago public.estado_pago_compra DEFAULT 'pagada'::public.estado_pago_compra,
    saldo_pendiente numeric(12,2) DEFAULT 0,
    descripcion character varying(255),
    proveedor_id integer,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.compras OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 19452)
-- Name: compras_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.compras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.compras_id_seq OWNER TO postgres;

--
-- TOC entry 4569 (class 0 OID 0)
-- Dependencies: 267
-- Name: compras_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.compras_id_seq OWNED BY inventario.compras.id;


--
-- TOC entry 268 (class 1259 OID 19453)
-- Name: ingredientes; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.ingredientes (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    cantidad_disponible numeric(10,3) DEFAULT 0,
    cantidad_minima numeric(10,3) DEFAULT 0,
    unidad_id integer NOT NULL,
    costo_promedio numeric(10,2) DEFAULT 0,
    merma_teorica_porcentaje numeric(5,2) DEFAULT 0,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.ingredientes OWNER TO postgres;

--
-- TOC entry 4570 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE ingredientes; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON TABLE inventario.ingredientes IS 'Inventario de materias primas con costo promedio ponderado';


--
-- TOC entry 4571 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN ingredientes.merma_teorica_porcentaje; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON COLUMN inventario.ingredientes.merma_teorica_porcentaje IS '% de pérdida natural (ej. cáscaras, huesos) para cálculo preciso de costos del ingrediente limpio';


--
-- TOC entry 269 (class 1259 OID 19466)
-- Name: ingredientes_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.ingredientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.ingredientes_id_seq OWNER TO postgres;

--
-- TOC entry 4572 (class 0 OID 0)
-- Dependencies: 269
-- Name: ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.ingredientes_id_seq OWNED BY inventario.ingredientes.id;


--
-- TOC entry 270 (class 1259 OID 19467)
-- Name: mermas; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.mermas (
    id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    tipo public.tipo_merma DEFAULT 'desperdicio'::public.tipo_merma NOT NULL,
    razon text NOT NULL,
    reportado_por integer NOT NULL,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.mermas OWNER TO postgres;

--
-- TOC entry 4573 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE mermas; Type: COMMENT; Schema: inventario; Owner: postgres
--

COMMENT ON TABLE inventario.mermas IS 'Registro de pérdidas de inventario para conciliar stock teórico vs real';


--
-- TOC entry 271 (class 1259 OID 19481)
-- Name: mermas_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.mermas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.mermas_id_seq OWNER TO postgres;

--
-- TOC entry 4574 (class 0 OID 0)
-- Dependencies: 271
-- Name: mermas_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.mermas_id_seq OWNED BY inventario.mermas.id;


--
-- TOC entry 272 (class 1259 OID 19482)
-- Name: proveedores; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.proveedores (
    id integer NOT NULL,
    identificacion character varying(30) NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(20),
    email character varying(100),
    direccion text,
    restaurante_id integer NOT NULL,
    banco_nombre character varying(50),
    banco_cuenta_numero character varying(30),
    activo boolean DEFAULT true,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.proveedores OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 19494)
-- Name: proveedores_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.proveedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.proveedores_id_seq OWNER TO postgres;

--
-- TOC entry 4575 (class 0 OID 0)
-- Dependencies: 273
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.proveedores_id_seq OWNED BY inventario.proveedores.id;


--
-- TOC entry 274 (class 1259 OID 19495)
-- Name: unidad_compra; Type: TABLE; Schema: inventario; Owner: postgres
--

CREATE TABLE inventario.unidad_compra (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE inventario.unidad_compra OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 19502)
-- Name: unidad_compra_id_seq; Type: SEQUENCE; Schema: inventario; Owner: postgres
--

CREATE SEQUENCE inventario.unidad_compra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventario.unidad_compra_id_seq OWNER TO postgres;

--
-- TOC entry 4576 (class 0 OID 0)
-- Dependencies: 275
-- Name: unidad_compra_id_seq; Type: SEQUENCE OWNED BY; Schema: inventario; Owner: postgres
--

ALTER SEQUENCE inventario.unidad_compra_id_seq OWNED BY inventario.unidad_compra.id;


--
-- TOC entry 276 (class 1259 OID 19503)
-- Name: categories; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE inventory.categories (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE inventory.categories OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 19508)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: inventory; Owner: postgres
--

CREATE SEQUENCE inventory.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventory.categories_id_seq OWNER TO postgres;

--
-- TOC entry 4577 (class 0 OID 0)
-- Dependencies: 277
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE inventory.categories_id_seq OWNED BY inventory.categories.id;


--
-- TOC entry 278 (class 1259 OID 19509)
-- Name: products; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE inventory.products (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    precio_venta numeric(10,2) NOT NULL,
    categoria_id integer,
    imagen_url character varying(255),
    activo boolean DEFAULT true
);


ALTER TABLE inventory.products OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 19516)
-- Name: products_id_seq; Type: SEQUENCE; Schema: inventory; Owner: postgres
--

CREATE SEQUENCE inventory.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventory.products_id_seq OWNER TO postgres;

--
-- TOC entry 4578 (class 0 OID 0)
-- Dependencies: 279
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE inventory.products_id_seq OWNED BY inventory.products.id;


--
-- TOC entry 280 (class 1259 OID 19517)
-- Name: categorias; Type: TABLE; Schema: menu; Owner: postgres
--

CREATE TABLE menu.categorias (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    orden integer DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE menu.categorias OWNER TO postgres;

--
-- TOC entry 4579 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE categorias; Type: COMMENT; Schema: menu; Owner: postgres
--

COMMENT ON TABLE menu.categorias IS 'Categorías del menú: Entradas, Platos Fuertes, Bebidas, Postres, etc.';


--
-- TOC entry 281 (class 1259 OID 19527)
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: menu; Owner: postgres
--

CREATE SEQUENCE menu.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE menu.categorias_id_seq OWNER TO postgres;

--
-- TOC entry 4580 (class 0 OID 0)
-- Dependencies: 281
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.categorias_id_seq OWNED BY menu.categorias.id;


--
-- TOC entry 282 (class 1259 OID 19528)
-- Name: receta_ingredientes; Type: TABLE; Schema: menu; Owner: postgres
--

CREATE TABLE menu.receta_ingredientes (
    id integer NOT NULL,
    receta_id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE menu.receta_ingredientes OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 19536)
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE; Schema: menu; Owner: postgres
--

CREATE SEQUENCE menu.receta_ingredientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE menu.receta_ingredientes_id_seq OWNER TO postgres;

--
-- TOC entry 4581 (class 0 OID 0)
-- Dependencies: 283
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.receta_ingredientes_id_seq OWNED BY menu.receta_ingredientes.id;


--
-- TOC entry 284 (class 1259 OID 19537)
-- Name: recetas; Type: TABLE; Schema: menu; Owner: postgres
--

CREATE TABLE menu.recetas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    categoria_id integer,
    imagen_url text,
    costo_produccion numeric(10,2) DEFAULT 0,
    precio_sugerido numeric(10,2) DEFAULT 0,
    precio_venta numeric(10,2) DEFAULT 0,
    margen_utilidad numeric(5,2) DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE menu.recetas OWNER TO postgres;

--
-- TOC entry 4582 (class 0 OID 0)
-- Dependencies: 284
-- Name: TABLE recetas; Type: COMMENT; Schema: menu; Owner: postgres
--

COMMENT ON TABLE menu.recetas IS 'Recetas estándar (BOM - Bill of Materials) del menú';


--
-- TOC entry 285 (class 1259 OID 19552)
-- Name: recetas_id_seq; Type: SEQUENCE; Schema: menu; Owner: postgres
--

CREATE SEQUENCE menu.recetas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE menu.recetas_id_seq OWNER TO postgres;

--
-- TOC entry 4583 (class 0 OID 0)
-- Dependencies: 285
-- Name: recetas_id_seq; Type: SEQUENCE OWNED BY; Schema: menu; Owner: postgres
--

ALTER SEQUENCE menu.recetas_id_seq OWNED BY menu.recetas.id;


--
-- TOC entry 286 (class 1259 OID 19553)
-- Name: v_rentabilidad_platos; Type: VIEW; Schema: menu; Owner: postgres
--

CREATE VIEW menu.v_rentabilidad_platos AS
 SELECT restaurante_id,
    id AS receta_id,
    nombre AS plato,
    costo_produccion,
    precio_sugerido,
    precio_venta,
        CASE
            WHEN (precio_venta > (0)::numeric) THEN round((((precio_venta - costo_produccion) / precio_venta) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS margen_real_porcentaje,
        CASE
            WHEN (precio_venta > (0)::numeric) THEN (precio_venta - costo_produccion)
            ELSE (0)::numeric
        END AS utilidad_por_plato
   FROM menu.recetas r
  WHERE (activo = true);


ALTER VIEW menu.v_rentabilidad_platos OWNER TO postgres;

--
-- TOC entry 4584 (class 0 OID 0)
-- Dependencies: 286
-- Name: VIEW v_rentabilidad_platos; Type: COMMENT; Schema: menu; Owner: postgres
--

COMMENT ON VIEW menu.v_rentabilidad_platos IS 'Reporte de rentabilidad por plato. Compara costo_produccion (CPP de ingredientes * cantidades)
vs precio_venta. El campo costo_produccion debe actualizarse cuando cambia el CPP de un ingrediente.';


--
-- TOC entry 287 (class 1259 OID 19557)
-- Name: facturas; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.facturas (
    id integer NOT NULL,
    numero_factura character varying(50) NOT NULL,
    pedido_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer,
    cliente_nombre character varying(100),
    cliente_identificacion character varying(30),
    cliente_direccion text,
    cliente_email character varying(100),
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    descuento numeric(12,2) DEFAULT 0,
    impuestos numeric(10,2) DEFAULT 0,
    propina numeric(10,2) DEFAULT 0,
    total numeric(12,2) NOT NULL,
    estado public.estado_factura DEFAULT 'emitida'::public.estado_factura,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.facturas OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 19575)
-- Name: facturas_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.facturas_id_seq OWNER TO postgres;

--
-- TOC entry 4585 (class 0 OID 0)
-- Dependencies: 288
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.facturas_id_seq OWNED BY operaciones.facturas.id;


--
-- TOC entry 289 (class 1259 OID 19576)
-- Name: mesas; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.mesas (
    id integer NOT NULL,
    numero integer NOT NULL,
    nombre character varying(50),
    capacidad integer NOT NULL,
    estado public.estado_mesa DEFAULT 'libre'::public.estado_mesa,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.mesas OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 19586)
-- Name: mesas_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.mesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.mesas_id_seq OWNER TO postgres;

--
-- TOC entry 4586 (class 0 OID 0)
-- Dependencies: 290
-- Name: mesas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.mesas_id_seq OWNED BY operaciones.mesas.id;


--
-- TOC entry 291 (class 1259 OID 19587)
-- Name: meseros; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.meseros (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.meseros OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 19596)
-- Name: meseros_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.meseros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.meseros_id_seq OWNER TO postgres;

--
-- TOC entry 4587 (class 0 OID 0)
-- Dependencies: 292
-- Name: meseros_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.meseros_id_seq OWNED BY operaciones.meseros.id;


--
-- TOC entry 293 (class 1259 OID 19597)
-- Name: pedido_detalle; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.pedido_detalle (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    receta_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    notas text,
    restaurante_id integer NOT NULL
);


ALTER TABLE operaciones.pedido_detalle OWNER TO postgres;

--
-- TOC entry 4588 (class 0 OID 0)
-- Dependencies: 293
-- Name: COLUMN pedido_detalle.notas; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON COLUMN operaciones.pedido_detalle.notas IS 'Instrucciones para cocina: "Sin piña", "Extra queso", etc.';


--
-- TOC entry 294 (class 1259 OID 19609)
-- Name: pedido_detalle_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.pedido_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.pedido_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 4589 (class 0 OID 0)
-- Dependencies: 294
-- Name: pedido_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.pedido_detalle_id_seq OWNED BY operaciones.pedido_detalle.id;


--
-- TOC entry 295 (class 1259 OID 19610)
-- Name: pedidos; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.pedidos (
    id integer NOT NULL,
    codigo character varying(40) NOT NULL,
    mesa_id integer,
    mesero_id integer,
    cliente character varying(100),
    estado public.estado_pedido DEFAULT 'pendiente'::public.estado_pedido,
    estado_cuenta public.estado_cuenta DEFAULT 'abierta'::public.estado_cuenta,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal numeric(12,2) DEFAULT 0,
    descuento numeric(12,2) DEFAULT 0,
    impuestos numeric(12,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.pedidos OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 19626)
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.pedidos_id_seq OWNER TO postgres;

--
-- TOC entry 4590 (class 0 OID 0)
-- Dependencies: 296
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.pedidos_id_seq OWNED BY operaciones.pedidos.id;


--
-- TOC entry 297 (class 1259 OID 19627)
-- Name: reservas; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.reservas (
    id integer NOT NULL,
    mesa_id integer,
    cliente_nombre character varying(100) NOT NULL,
    cliente_telefono character varying(20),
    fecha_reserva timestamp without time zone NOT NULL,
    cantidad_personas integer NOT NULL,
    estado public.estado_reserva DEFAULT 'pendiente'::public.estado_reserva,
    notas text,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE operaciones.reservas OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 19640)
-- Name: reservas_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.reservas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.reservas_id_seq OWNER TO postgres;

--
-- TOC entry 4591 (class 0 OID 0)
-- Dependencies: 298
-- Name: reservas_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.reservas_id_seq OWNED BY operaciones.reservas.id;


--
-- TOC entry 299 (class 1259 OID 19641)
-- Name: transacciones_pago; Type: TABLE; Schema: operaciones; Owner: postgres
--

CREATE TABLE operaciones.transacciones_pago (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    metodo public.metodo_pago_enum NOT NULL,
    monto numeric(12,2) NOT NULL,
    referencia character varying(100),
    tasa_cambio numeric(12,4) DEFAULT 1,
    usuario_id integer,
    restaurante_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transacciones_pago_monto_check CHECK ((monto > (0)::numeric))
);


ALTER TABLE operaciones.transacciones_pago OWNER TO postgres;

--
-- TOC entry 4592 (class 0 OID 0)
-- Dependencies: 299
-- Name: TABLE transacciones_pago; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON TABLE operaciones.transacciones_pago IS 'Registro de método(s) de pago por pedido. Un pedido puede tener múltiples filas (pago mixto).
Permite arqueo por método: SUM(monto) WHERE metodo = ''efectivo'' AND caja_id = X';


--
-- TOC entry 4593 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN transacciones_pago.referencia; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON COLUMN operaciones.transacciones_pago.referencia IS 'Número de confirmación (pago móvil), últimos 4 dígitos (tarjeta) o identificador libre.';


--
-- TOC entry 4594 (class 0 OID 0)
-- Dependencies: 299
-- Name: COLUMN transacciones_pago.tasa_cambio; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON COLUMN operaciones.transacciones_pago.tasa_cambio IS 'Aplica cuando metodo=divisa. Registra la tasa Bs/USD vigente al momento de la transacción para reportes contables correctos.';


--
-- TOC entry 300 (class 1259 OID 19652)
-- Name: transacciones_pago_id_seq; Type: SEQUENCE; Schema: operaciones; Owner: postgres
--

CREATE SEQUENCE operaciones.transacciones_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE operaciones.transacciones_pago_id_seq OWNER TO postgres;

--
-- TOC entry 4595 (class 0 OID 0)
-- Dependencies: 300
-- Name: transacciones_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: operaciones; Owner: postgres
--

ALTER SEQUENCE operaciones.transacciones_pago_id_seq OWNED BY operaciones.transacciones_pago.id;


--
-- TOC entry 301 (class 1259 OID 19653)
-- Name: v_arqueo_caja; Type: VIEW; Schema: operaciones; Owner: postgres
--

CREATE VIEW operaciones.v_arqueo_caja AS
 SELECT restaurante_id,
    date(created_at) AS fecha,
    metodo AS metodo_pago,
    count(id) AS num_transacciones,
    sum(monto) AS total_recaudado
   FROM operaciones.transacciones_pago tp
  GROUP BY restaurante_id, (date(created_at)), metodo
  ORDER BY restaurante_id, (date(created_at)), metodo;


ALTER VIEW operaciones.v_arqueo_caja OWNER TO postgres;

--
-- TOC entry 4596 (class 0 OID 0)
-- Dependencies: 301
-- Name: VIEW v_arqueo_caja; Type: COMMENT; Schema: operaciones; Owner: postgres
--

COMMENT ON VIEW operaciones.v_arqueo_caja IS 'Resumen del arqueo de caja por día y método de pago.
Filtra por restaurante_id y fecha para el cierre diario.
Muestra cuánto se recaudó en efectivo, pago_movil, tarjeta y divisa por separado.';


--
-- TOC entry 302 (class 1259 OID 19657)
-- Name: banco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banco (
    id integer NOT NULL,
    nombre_banco character varying(100) NOT NULL,
    numero_cuenta character varying(50) NOT NULL,
    saldo_actual numeric(10,2) DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.banco OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 19666)
-- Name: banco_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.banco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.banco_id_seq OWNER TO postgres;

--
-- TOC entry 4597 (class 0 OID 0)
-- Dependencies: 303
-- Name: banco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banco_id_seq OWNED BY public.banco.id;


--
-- TOC entry 304 (class 1259 OID 19667)
-- Name: banco_movimientos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banco_movimientos (
    id integer NOT NULL,
    banco_id integer NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    monto numeric(10,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    referencia_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.banco_movimientos OWNER TO postgres;

--
-- TOC entry 4598 (class 0 OID 0)
-- Dependencies: 304
-- Name: TABLE banco_movimientos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.banco_movimientos IS 'Movimientos bancarios con trazabilidad polimórfica';


--
-- TOC entry 305 (class 1259 OID 19678)
-- Name: banco_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.banco_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.banco_movimientos_id_seq OWNER TO postgres;

--
-- TOC entry 4599 (class 0 OID 0)
-- Dependencies: 305
-- Name: banco_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banco_movimientos_id_seq OWNED BY public.banco_movimientos.id;


--
-- TOC entry 306 (class 1259 OID 19679)
-- Name: caja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja (
    id integer NOT NULL,
    fecha_apertura timestamp without time zone NOT NULL,
    fecha_cierre timestamp without time zone,
    monto_inicial numeric(10,2) NOT NULL,
    monto_final numeric(10,2),
    usuario_apertura_id integer NOT NULL,
    usuario_cierre_id integer,
    observaciones text,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.caja OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 19689)
-- Name: caja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_id_seq OWNER TO postgres;

--
-- TOC entry 4600 (class 0 OID 0)
-- Dependencies: 307
-- Name: caja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_id_seq OWNED BY public.caja.id;


--
-- TOC entry 308 (class 1259 OID 19690)
-- Name: caja_movimientos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja_movimientos (
    id integer NOT NULL,
    caja_id integer NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    monto numeric(10,2) NOT NULL,
    concepto character varying(255) NOT NULL,
    referencia_id integer NOT NULL,
    metodo_pago_id integer,
    usuario_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.caja_movimientos OWNER TO postgres;

--
-- TOC entry 4601 (class 0 OID 0)
-- Dependencies: 308
-- Name: TABLE caja_movimientos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.caja_movimientos IS 'Movimientos de efectivo con trazabilidad polimórfica';


--
-- TOC entry 309 (class 1259 OID 19701)
-- Name: caja_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_movimientos_id_seq OWNER TO postgres;

--
-- TOC entry 4602 (class 0 OID 0)
-- Dependencies: 309
-- Name: caja_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_movimientos_id_seq OWNED BY public.caja_movimientos.id;


--
-- TOC entry 310 (class 1259 OID 19702)
-- Name: categoria_egresos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_egresos (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.categoria_egresos OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 19708)
-- Name: categoria_egresos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categoria_egresos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_egresos_id_seq OWNER TO postgres;

--
-- TOC entry 4603 (class 0 OID 0)
-- Dependencies: 311
-- Name: categoria_egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_egresos_id_seq OWNED BY public.categoria_egresos.id;


--
-- TOC entry 312 (class 1259 OID 19709)
-- Name: compra_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compra_detalle (
    id integer NOT NULL,
    compra_id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    unidad_compra_id integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.compra_detalle OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 19719)
-- Name: compra_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compra_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compra_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 4604 (class 0 OID 0)
-- Dependencies: 313
-- Name: compra_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compra_detalle_id_seq OWNED BY public.compra_detalle.id;


--
-- TOC entry 314 (class 1259 OID 19720)
-- Name: compras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compras (
    id integer NOT NULL,
    fecha date NOT NULL,
    total numeric(10,2) NOT NULL,
    descripcion character varying(255),
    proveedor_id integer,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.compras OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 19727)
-- Name: compras_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compras_id_seq OWNER TO postgres;

--
-- TOC entry 4605 (class 0 OID 0)
-- Dependencies: 315
-- Name: compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compras_id_seq OWNED BY public.compras.id;


--
-- TOC entry 316 (class 1259 OID 19728)
-- Name: egresos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.egresos (
    id integer NOT NULL,
    fecha date NOT NULL,
    monto numeric(10,2) NOT NULL,
    categoria_id integer NOT NULL,
    razon character varying(255) NOT NULL,
    descripcion text,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.egresos OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 19739)
-- Name: egresos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.egresos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.egresos_id_seq OWNER TO postgres;

--
-- TOC entry 4606 (class 0 OID 0)
-- Dependencies: 317
-- Name: egresos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.egresos_id_seq OWNED BY public.egresos.id;


--
-- TOC entry 318 (class 1259 OID 19740)
-- Name: facturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facturas (
    id integer NOT NULL,
    numero_factura character varying(50) NOT NULL,
    pedido_id integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    impuestos numeric(10,2) DEFAULT 0,
    total numeric(10,2) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.facturas OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 19751)
-- Name: facturas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facturas_id_seq OWNER TO postgres;

--
-- TOC entry 4607 (class 0 OID 0)
-- Dependencies: 319
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facturas_id_seq OWNED BY public.facturas.id;


--
-- TOC entry 320 (class 1259 OID 19752)
-- Name: ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredientes (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    cantidad_disponible numeric(10,3) DEFAULT 0,
    cantidad_minima numeric(10,3) DEFAULT 0,
    unidad_id integer NOT NULL,
    costo_promedio numeric(10,2) DEFAULT 0,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.ingredientes OWNER TO postgres;

--
-- TOC entry 4608 (class 0 OID 0)
-- Dependencies: 320
-- Name: TABLE ingredientes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ingredientes IS 'Inventario de materias primas con costo promedio';


--
-- TOC entry 321 (class 1259 OID 19762)
-- Name: ingredientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredientes_id_seq OWNER TO postgres;

--
-- TOC entry 4609 (class 0 OID 0)
-- Dependencies: 321
-- Name: ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredientes_id_seq OWNED BY public.ingredientes.id;


--
-- TOC entry 322 (class 1259 OID 19763)
-- Name: mesas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mesas (
    id integer NOT NULL,
    numero integer NOT NULL,
    nombre character varying(50),
    capacidad integer NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.mesas OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 19770)
-- Name: mesas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mesas_id_seq OWNER TO postgres;

--
-- TOC entry 4610 (class 0 OID 0)
-- Dependencies: 323
-- Name: mesas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mesas_id_seq OWNED BY public.mesas.id;


--
-- TOC entry 324 (class 1259 OID 19771)
-- Name: meseros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meseros (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.meseros OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 19778)
-- Name: meseros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.meseros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meseros_id_seq OWNER TO postgres;

--
-- TOC entry 4611 (class 0 OID 0)
-- Dependencies: 325
-- Name: meseros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meseros_id_seq OWNED BY public.meseros.id;


--
-- TOC entry 326 (class 1259 OID 19779)
-- Name: metodos_pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metodos_pago (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.metodos_pago OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 19785)
-- Name: metodos_pago_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metodos_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metodos_pago_id_seq OWNER TO postgres;

--
-- TOC entry 4612 (class 0 OID 0)
-- Dependencies: 327
-- Name: metodos_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metodos_pago_id_seq OWNED BY public.metodos_pago.id;


--
-- TOC entry 328 (class 1259 OID 19786)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 19798)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    restaurant_id uuid,
    user_id uuid,
    table_id uuid,
    status public.orders_status_enum DEFAULT 'pending'::public.orders_status_enum NOT NULL,
    subtotal numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    tax_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    total_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 19815)
-- Name: pedido_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_detalle (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    receta_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.pedido_detalle OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 19825)
-- Name: pedido_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 4613 (class 0 OID 0)
-- Dependencies: 331
-- Name: pedido_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_detalle_id_seq OWNED BY public.pedido_detalle.id;


--
-- TOC entry 332 (class 1259 OID 19826)
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    mesa_id integer,
    mesero_id integer,
    cliente character varying(100),
    fecha_hora timestamp without time zone NOT NULL,
    total numeric(10,2) DEFAULT 0,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 19834)
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedidos_id_seq OWNER TO postgres;

--
-- TOC entry 4614 (class 0 OID 0)
-- Dependencies: 333
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;


--
-- TOC entry 334 (class 1259 OID 19835)
-- Name: proveedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedores (
    id integer NOT NULL,
    identificacion character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(20),
    email character varying(100),
    direccion text,
    restaurante_id integer NOT NULL,
    banco_nombre character varying(50),
    banco_cuenta_numero character varying(30),
    activo boolean DEFAULT true,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.proveedores OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 19847)
-- Name: proveedores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedores_id_seq OWNER TO postgres;

--
-- TOC entry 4615 (class 0 OID 0)
-- Dependencies: 335
-- Name: proveedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedores_id_seq OWNED BY public.proveedores.id;


--
-- TOC entry 336 (class 1259 OID 19848)
-- Name: receta_ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receta_ingredientes (
    id integer NOT NULL,
    receta_id integer NOT NULL,
    ingrediente_id integer NOT NULL,
    cantidad numeric(10,3) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.receta_ingredientes OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 19856)
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receta_ingredientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.receta_ingredientes_id_seq OWNER TO postgres;

--
-- TOC entry 4616 (class 0 OID 0)
-- Dependencies: 337
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receta_ingredientes_id_seq OWNED BY public.receta_ingredientes.id;


--
-- TOC entry 338 (class 1259 OID 19857)
-- Name: recetas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recetas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    costo_produccion numeric(10,2) DEFAULT 0,
    precio_sugerido numeric(10,2) DEFAULT 0,
    precio_venta numeric(10,2) DEFAULT 0,
    margen_utilidad numeric(5,2) DEFAULT 0,
    activo boolean DEFAULT true,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.recetas OWNER TO postgres;

--
-- TOC entry 4617 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE recetas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.recetas IS 'Recetas estándar (BOM - Bill of Materials)';


--
-- TOC entry 339 (class 1259 OID 19870)
-- Name: recetas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recetas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recetas_id_seq OWNER TO postgres;

--
-- TOC entry 4618 (class 0 OID 0)
-- Dependencies: 339
-- Name: recetas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recetas_id_seq OWNED BY public.recetas.id;


--
-- TOC entry 340 (class 1259 OID 19871)
-- Name: restaurante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurante (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    patrimonio_inicial numeric(10,2) DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.restaurante OWNER TO postgres;

--
-- TOC entry 4619 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE restaurante; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.restaurante IS 'Tabla base para multi-tenencia';


--
-- TOC entry 341 (class 1259 OID 19879)
-- Name: restaurante_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restaurante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.restaurante_id_seq OWNER TO postgres;

--
-- TOC entry 4620 (class 0 OID 0)
-- Dependencies: 341
-- Name: restaurante_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restaurante_id_seq OWNED BY public.restaurante.id;


--
-- TOC entry 342 (class 1259 OID 19880)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 343 (class 1259 OID 19886)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 4621 (class 0 OID 0)
-- Dependencies: 343
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 344 (class 1259 OID 19887)
-- Name: unidad_compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_compra (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    restaurante_id integer NOT NULL
);


ALTER TABLE public.unidad_compra OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 19893)
-- Name: unidad_compra_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_compra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unidad_compra_id_seq OWNER TO postgres;

--
-- TOC entry 4622 (class 0 OID 0)
-- Dependencies: 345
-- Name: unidad_compra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_compra_id_seq OWNED BY public.unidad_compra.id;


--
-- TOC entry 346 (class 1259 OID 19894)
-- Name: unidad_medida; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_medida (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    abreviatura character varying(5) NOT NULL
);


ALTER TABLE public.unidad_medida OWNER TO postgres;

--
-- TOC entry 347 (class 1259 OID 19900)
-- Name: unidad_medida_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_medida_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unidad_medida_id_seq OWNER TO postgres;

--
-- TOC entry 4623 (class 0 OID 0)
-- Dependencies: 347
-- Name: unidad_medida_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_medida_id_seq OWNED BY public.unidad_medida.id;


--
-- TOC entry 348 (class 1259 OID 19901)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    restaurante_id integer NOT NULL,
    rol_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    activo boolean DEFAULT true
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 349 (class 1259 OID 19911)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 4624 (class 0 OID 0)
-- Dependencies: 349
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 350 (class 1259 OID 19912)
-- Name: order_items; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.order_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id uuid,
    product_id integer,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE sales.order_items OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 19921)
-- Name: orders; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.orders (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    restaurant_id integer,
    user_id integer,
    table_id integer,
    status character varying(50) DEFAULT 'pending'::character varying,
    subtotal numeric(10,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(10,2) DEFAULT 0 NOT NULL,
    total_amount numeric(10,2) DEFAULT 0 NOT NULL,
    notes character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE sales.orders OWNER TO postgres;

--
-- TOC entry 3713 (class 2604 OID 19935)
-- Name: asiento_lineas id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas ALTER COLUMN id SET DEFAULT nextval('contabilidad.asiento_lineas_id_seq'::regclass);


--
-- TOC entry 3714 (class 2604 OID 19936)
-- Name: asientos id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos ALTER COLUMN id SET DEFAULT nextval('contabilidad.asientos_id_seq'::regclass);


--
-- TOC entry 3718 (class 2604 OID 19937)
-- Name: libro_diario id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario ALTER COLUMN id SET DEFAULT nextval('contabilidad.libro_diario_id_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 19938)
-- Name: plan_cuentas id; Type: DEFAULT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas ALTER COLUMN id SET DEFAULT nextval('contabilidad.plan_cuentas_id_seq'::regclass);


--
-- TOC entry 3735 (class 2604 OID 19939)
-- Name: metodos_pago id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago ALTER COLUMN id SET DEFAULT nextval('core.metodos_pago_id_seq'::regclass);


--
-- TOC entry 3726 (class 2604 OID 19940)
-- Name: restaurante id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.restaurante ALTER COLUMN id SET DEFAULT nextval('core.restaurante_id_seq'::regclass);


--
-- TOC entry 3738 (class 2604 OID 19941)
-- Name: roles id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.roles ALTER COLUMN id SET DEFAULT nextval('core.roles_id_seq'::regclass);


--
-- TOC entry 3740 (class 2604 OID 19942)
-- Name: tables id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.tables ALTER COLUMN id SET DEFAULT nextval('core.tables_id_seq'::regclass);


--
-- TOC entry 3743 (class 2604 OID 19943)
-- Name: unidad_medida id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.unidad_medida ALTER COLUMN id SET DEFAULT nextval('core.unidad_medida_id_seq'::regclass);


--
-- TOC entry 3744 (class 2604 OID 19944)
-- Name: usuarios id; Type: DEFAULT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios ALTER COLUMN id SET DEFAULT nextval('core.usuarios_id_seq'::regclass);


--
-- TOC entry 3748 (class 2604 OID 19945)
-- Name: banco id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco ALTER COLUMN id SET DEFAULT nextval('finanzas.banco_id_seq'::regclass);


--
-- TOC entry 3753 (class 2604 OID 19946)
-- Name: banco_movimientos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos ALTER COLUMN id SET DEFAULT nextval('finanzas.banco_movimientos_id_seq'::regclass);


--
-- TOC entry 3755 (class 2604 OID 19947)
-- Name: caja id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja ALTER COLUMN id SET DEFAULT nextval('finanzas.caja_id_seq'::regclass);


--
-- TOC entry 3758 (class 2604 OID 19948)
-- Name: caja_movimientos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('finanzas.caja_movimientos_id_seq'::regclass);


--
-- TOC entry 3760 (class 2604 OID 19949)
-- Name: egresos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos ALTER COLUMN id SET DEFAULT nextval('finanzas.egresos_id_seq'::regclass);


--
-- TOC entry 3762 (class 2604 OID 19950)
-- Name: gastos_operativos id; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.gastos_operativos ALTER COLUMN id SET DEFAULT nextval('finanzas.gastos_operativos_id_seq'::regclass);


--
-- TOC entry 3765 (class 2604 OID 19951)
-- Name: categoria_egresos id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos ALTER COLUMN id SET DEFAULT nextval('inventario.categoria_egresos_id_seq'::regclass);


--
-- TOC entry 3767 (class 2604 OID 19952)
-- Name: compra_detalle id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle ALTER COLUMN id SET DEFAULT nextval('inventario.compra_detalle_id_seq'::regclass);


--
-- TOC entry 3769 (class 2604 OID 19953)
-- Name: compras id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras ALTER COLUMN id SET DEFAULT nextval('inventario.compras_id_seq'::regclass);


--
-- TOC entry 3773 (class 2604 OID 19954)
-- Name: ingredientes id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes ALTER COLUMN id SET DEFAULT nextval('inventario.ingredientes_id_seq'::regclass);


--
-- TOC entry 3780 (class 2604 OID 19955)
-- Name: mermas id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas ALTER COLUMN id SET DEFAULT nextval('inventario.mermas_id_seq'::regclass);


--
-- TOC entry 3783 (class 2604 OID 19956)
-- Name: proveedores id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores ALTER COLUMN id SET DEFAULT nextval('inventario.proveedores_id_seq'::regclass);


--
-- TOC entry 3787 (class 2604 OID 19957)
-- Name: unidad_compra id; Type: DEFAULT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra ALTER COLUMN id SET DEFAULT nextval('inventario.unidad_compra_id_seq'::regclass);


--
-- TOC entry 3789 (class 2604 OID 19958)
-- Name: categories id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.categories ALTER COLUMN id SET DEFAULT nextval('inventory.categories_id_seq'::regclass);


--
-- TOC entry 3790 (class 2604 OID 19959)
-- Name: products id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products ALTER COLUMN id SET DEFAULT nextval('inventory.products_id_seq'::regclass);


--
-- TOC entry 3792 (class 2604 OID 19960)
-- Name: categorias id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias ALTER COLUMN id SET DEFAULT nextval('menu.categorias_id_seq'::regclass);


--
-- TOC entry 3797 (class 2604 OID 19961)
-- Name: receta_ingredientes id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes ALTER COLUMN id SET DEFAULT nextval('menu.receta_ingredientes_id_seq'::regclass);


--
-- TOC entry 3798 (class 2604 OID 19962)
-- Name: recetas id; Type: DEFAULT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas ALTER COLUMN id SET DEFAULT nextval('menu.recetas_id_seq'::regclass);


--
-- TOC entry 3806 (class 2604 OID 19963)
-- Name: facturas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas ALTER COLUMN id SET DEFAULT nextval('operaciones.facturas_id_seq'::regclass);


--
-- TOC entry 3813 (class 2604 OID 19964)
-- Name: mesas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas ALTER COLUMN id SET DEFAULT nextval('operaciones.mesas_id_seq'::regclass);


--
-- TOC entry 3817 (class 2604 OID 19965)
-- Name: meseros id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros ALTER COLUMN id SET DEFAULT nextval('operaciones.meseros_id_seq'::regclass);


--
-- TOC entry 3821 (class 2604 OID 19966)
-- Name: pedido_detalle id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle ALTER COLUMN id SET DEFAULT nextval('operaciones.pedido_detalle_id_seq'::regclass);


--
-- TOC entry 3822 (class 2604 OID 19967)
-- Name: pedidos id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos ALTER COLUMN id SET DEFAULT nextval('operaciones.pedidos_id_seq'::regclass);


--
-- TOC entry 3832 (class 2604 OID 19968)
-- Name: reservas id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas ALTER COLUMN id SET DEFAULT nextval('operaciones.reservas_id_seq'::regclass);


--
-- TOC entry 3836 (class 2604 OID 19969)
-- Name: transacciones_pago id; Type: DEFAULT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.transacciones_pago ALTER COLUMN id SET DEFAULT nextval('operaciones.transacciones_pago_id_seq'::regclass);


--
-- TOC entry 3839 (class 2604 OID 19970)
-- Name: banco id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco ALTER COLUMN id SET DEFAULT nextval('public.banco_id_seq'::regclass);


--
-- TOC entry 3842 (class 2604 OID 19971)
-- Name: banco_movimientos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos ALTER COLUMN id SET DEFAULT nextval('public.banco_movimientos_id_seq'::regclass);


--
-- TOC entry 3843 (class 2604 OID 19972)
-- Name: caja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja ALTER COLUMN id SET DEFAULT nextval('public.caja_id_seq'::regclass);


--
-- TOC entry 3844 (class 2604 OID 19973)
-- Name: caja_movimientos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('public.caja_movimientos_id_seq'::regclass);


--
-- TOC entry 3845 (class 2604 OID 19974)
-- Name: categoria_egresos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos ALTER COLUMN id SET DEFAULT nextval('public.categoria_egresos_id_seq'::regclass);


--
-- TOC entry 3846 (class 2604 OID 19975)
-- Name: compra_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle ALTER COLUMN id SET DEFAULT nextval('public.compra_detalle_id_seq'::regclass);


--
-- TOC entry 3847 (class 2604 OID 19976)
-- Name: compras id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras ALTER COLUMN id SET DEFAULT nextval('public.compras_id_seq'::regclass);


--
-- TOC entry 3848 (class 2604 OID 19977)
-- Name: egresos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos ALTER COLUMN id SET DEFAULT nextval('public.egresos_id_seq'::regclass);


--
-- TOC entry 3849 (class 2604 OID 19978)
-- Name: facturas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas ALTER COLUMN id SET DEFAULT nextval('public.facturas_id_seq'::regclass);


--
-- TOC entry 3851 (class 2604 OID 19979)
-- Name: ingredientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes ALTER COLUMN id SET DEFAULT nextval('public.ingredientes_id_seq'::regclass);


--
-- TOC entry 3855 (class 2604 OID 19980)
-- Name: mesas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas ALTER COLUMN id SET DEFAULT nextval('public.mesas_id_seq'::regclass);


--
-- TOC entry 3856 (class 2604 OID 19981)
-- Name: meseros id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros ALTER COLUMN id SET DEFAULT nextval('public.meseros_id_seq'::regclass);


--
-- TOC entry 3858 (class 2604 OID 19982)
-- Name: metodos_pago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago ALTER COLUMN id SET DEFAULT nextval('public.metodos_pago_id_seq'::regclass);


--
-- TOC entry 3868 (class 2604 OID 19983)
-- Name: pedido_detalle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle ALTER COLUMN id SET DEFAULT nextval('public.pedido_detalle_id_seq'::regclass);


--
-- TOC entry 3869 (class 2604 OID 19984)
-- Name: pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);


--
-- TOC entry 3871 (class 2604 OID 19985)
-- Name: proveedores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores ALTER COLUMN id SET DEFAULT nextval('public.proveedores_id_seq'::regclass);


--
-- TOC entry 3875 (class 2604 OID 19986)
-- Name: receta_ingredientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes ALTER COLUMN id SET DEFAULT nextval('public.receta_ingredientes_id_seq'::regclass);


--
-- TOC entry 3876 (class 2604 OID 19987)
-- Name: recetas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas ALTER COLUMN id SET DEFAULT nextval('public.recetas_id_seq'::regclass);


--
-- TOC entry 3882 (class 2604 OID 19988)
-- Name: restaurante id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurante ALTER COLUMN id SET DEFAULT nextval('public.restaurante_id_seq'::regclass);


--
-- TOC entry 3886 (class 2604 OID 19989)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3887 (class 2604 OID 19990)
-- Name: unidad_compra id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra ALTER COLUMN id SET DEFAULT nextval('public.unidad_compra_id_seq'::regclass);


--
-- TOC entry 3888 (class 2604 OID 19991)
-- Name: unidad_medida id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida ALTER COLUMN id SET DEFAULT nextval('public.unidad_medida_id_seq'::regclass);


--
-- TOC entry 3889 (class 2604 OID 19992)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 4406 (class 0 OID 19204)
-- Dependencies: 228
-- Data for Name: asiento_lineas; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.asiento_lineas (id, asiento_id, cuenta_id, tipo_movimiento, monto, descripcion, restaurante_id) FROM stdin;
1	1	5	debe	4.25	Ingreso al Inventario	1
2	1	3	haber	4.25	Salida de Caja/Bancos por Compra	1
3	2	3	debe	27.50	Cobro de Pedido - Caja	1
4	2	14	haber	27.50	Ingresos por Ventas	1
5	3	3	debe	17.60	Cobro de Pedido - Caja	1
6	3	14	haber	17.60	Ingresos por Ventas	1
7	4	18	debe	160.00	Registro de Gasto	1
8	4	3	haber	160.00	Pago de Gasto	1
9	5	16	debe	46.70	Costo de Ventas	1
10	5	5	haber	46.70	Salida de Inventario	1
11	6	3	debe	74.80	Cobro de Pedido - Caja	1
12	6	14	haber	74.80	Ingresos por Ventas	1
13	7	16	debe	0.57	Costo de Ventas	13
14	7	5	haber	0.57	Salida de Inventario	13
15	8	3	debe	3.30	Cobro de Pedido - Caja	13
16	8	14	haber	3.30	Ingresos por Ventas	13
17	9	18	debe	10.00	Registro de Gasto	13
18	9	3	haber	10.00	Pago de Gasto	13
19	10	5	debe	50.00	Ingreso al Inventario	13
20	10	8	haber	50.00	Cuentas por Pagar Proveedores	13
\.


--
-- TOC entry 4408 (class 0 OID 19216)
-- Dependencies: 230
-- Data for Name: asientos; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.asientos (id, fecha, descripcion, origen_tipo, origen_id, total_debe, total_haber, restaurante_id, creado_por, created_at) FROM stdin;
1	2026-05-18	Compra de mercancía Fac: 123456	compra_insumo	12	4.25	4.25	1	\N	2026-05-18 19:56:29.754181
2	2026-05-19	Cobro de Pedido 38	venta	38	27.50	27.50	1	5	2026-05-18 20:20:33.180477
3	2026-05-19	Cobro de Pedido 39	venta	39	17.60	17.60	1	5	2026-05-18 20:22:16.733027
4	2026-05-18	Gasto Operativo: OTROS - compra articulos limpieza	gasto_operativo	7	160.00	160.00	1	1	2026-05-18 22:02:23.588927
5	2026-05-19	Registro Pedido PED-20260519-0003	venta	40	46.70	46.70	1	4	2026-05-18 23:25:18.457076
6	2026-05-19	Cobro de Pedido 40	venta	40	74.80	74.80	1	5	2026-05-18 23:26:18.870635
7	2026-05-19	Registro Pedido R13-PED-20260519-0001	venta	42	0.57	0.57	13	9	2026-05-19 00:09:16.198163
8	2026-05-19	Cobro de Pedido 42	venta	42	3.30	3.30	13	11	2026-05-19 00:15:38.112276
9	2026-05-19	Gasto Operativo: ELECTRICIDAD	gasto_operativo	8	10.00	10.00	13	8	2026-05-19 00:22:23.712488
10	2026-05-19	Compra de mercancía Fac: fac-01	compra_insumo	13	50.00	50.00	13	\N	2026-05-19 00:24:59.537339
\.


--
-- TOC entry 4410 (class 0 OID 19229)
-- Dependencies: 232
-- Data for Name: libro_diario; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.libro_diario (id, fecha, descripcion, tipo, debe, haber, referencia_tipo, referencia_id, restaurante_id, created_at) FROM stdin;
1	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	7.15	0.00	venta	13	1	2026-04-04 00:02:27.408462
2	2026-04-04	Ingresos por Ventas	venta	0.00	7.15	venta	13	1	2026-04-04 00:02:27.408462
3	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	13	1	2026-04-04 00:02:27.408462
4	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	13	1	2026-04-04 00:02:27.408462
5	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	10.45	0.00	venta	14	1	2026-04-04 00:12:52.31896
6	2026-04-04	Ingresos por Ventas	venta	0.00	10.45	venta	14	1	2026-04-04 00:12:52.31896
7	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	14	1	2026-04-04 00:12:52.31896
8	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	14	1	2026-04-04 00:12:52.31896
9	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	10.45	0.00	venta	15	1	2026-04-04 00:16:00.581704
10	2026-04-04	Ingresos por Ventas	venta	0.00	10.45	venta	15	1	2026-04-04 00:16:00.581704
11	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	15	1	2026-04-04 00:16:00.581704
12	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	15	1	2026-04-04 00:16:00.581704
13	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	5.50	0.00	venta	16	1	2026-04-04 00:19:26.132213
14	2026-04-04	Ingresos por Ventas	venta	0.00	5.50	venta	16	1	2026-04-04 00:19:26.132213
15	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	16	1	2026-04-04 00:19:26.132213
16	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	16	1	2026-04-04 00:19:26.132213
17	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	5.50	0.00	venta	17	1	2026-04-04 00:31:51.480405
18	2026-04-04	Ingresos por Ventas	venta	0.00	5.50	venta	17	1	2026-04-04 00:31:51.480405
19	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	17	1	2026-04-04 00:31:51.480405
20	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	17	1	2026-04-04 00:31:51.480405
21	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	28.60	0.00	venta	18	1	2026-04-04 00:33:29.339811
22	2026-04-04	Ingresos por Ventas	venta	0.00	28.60	venta	18	1	2026-04-04 00:33:29.339811
23	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	18	1	2026-04-04 00:33:29.339811
24	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	18	1	2026-04-04 00:33:29.339811
25	2026-04-04	Ingreso a Caja/Bancos por Venta	venta	9.90	0.00	venta	19	1	2026-04-04 00:33:51.007441
26	2026-04-04	Ingresos por Ventas	venta	0.00	9.90	venta	19	1	2026-04-04 00:33:51.007441
27	2026-04-04	Costo de Ventas	costo_venta	0.00	0.00	venta	19	1	2026-04-04 00:33:51.007441
28	2026-04-04	Inventario	costo_venta	0.00	0.00	venta	19	1	2026-04-04 00:33:51.007441
29	2026-04-09	Ingreso a Caja/Bancos por Venta	venta	24.20	0.00	venta	20	1	2026-04-09 11:20:37.461517
30	2026-04-09	Ingresos por Ventas	venta	0.00	24.20	venta	20	1	2026-04-09 11:20:37.461517
31	2026-04-09	Costo de Ventas	costo_venta	0.00	0.00	venta	20	1	2026-04-09 11:20:37.461517
32	2026-04-09	Inventario	costo_venta	0.00	0.00	venta	20	1	2026-04-09 11:20:37.461517
33	2026-04-14	Ingreso a Caja/Bancos por Venta	venta	27.50	0.00	venta	21	1	2026-04-14 10:50:01.639167
34	2026-04-14	Ingresos por Ventas	venta	0.00	27.50	venta	21	1	2026-04-14 10:50:01.639167
35	2026-04-14	Costo de Ventas	costo_venta	0.00	0.00	venta	21	1	2026-04-14 10:50:01.639167
36	2026-04-14	Inventario	costo_venta	0.00	0.00	venta	21	1	2026-04-14 10:50:01.639167
37	2026-04-17	Ingreso a Caja/Bancos por Venta	venta	10.45	0.00	venta	22	1	2026-04-16 20:36:02.623098
38	2026-04-17	Ingresos por Ventas	venta	0.00	10.45	venta	22	1	2026-04-16 20:36:02.623098
39	2026-04-17	Costo de Ventas	costo_venta	0.00	0.00	venta	22	1	2026-04-16 20:36:02.623098
40	2026-04-17	Inventario	costo_venta	0.00	0.00	venta	22	1	2026-04-16 20:36:02.623098
41	2026-04-17	Ingreso a Caja/Bancos por Venta	venta	10.45	0.00	venta	23	1	2026-04-16 21:12:05.38234
42	2026-04-17	Ingresos por Ventas	venta	0.00	10.45	venta	23	1	2026-04-16 21:12:05.38234
43	2026-04-17	Costo de Ventas	costo_venta	0.00	0.00	venta	23	1	2026-04-16 21:12:05.38234
44	2026-04-17	Inventario	costo_venta	0.00	0.00	venta	23	1	2026-04-16 21:12:05.38234
45	2026-04-17	Ingreso a Caja/Bancos por Venta	venta	7.15	0.00	venta	24	1	2026-04-16 21:40:42.656259
46	2026-04-17	Ingresos por Ventas	venta	0.00	7.15	venta	24	1	2026-04-16 21:40:42.656259
47	2026-04-17	Costo de Ventas	costo_venta	0.00	0.00	venta	24	1	2026-04-16 21:40:42.656259
48	2026-04-17	Inventario	costo_venta	0.00	0.00	venta	24	1	2026-04-16 21:40:42.656259
49	2026-04-17	Ingreso a Caja/Bancos por Venta	venta	13.75	0.00	venta	25	1	2026-04-16 22:03:07.028868
50	2026-04-17	Ingresos por Ventas	venta	0.00	13.75	venta	25	1	2026-04-16 22:03:07.028868
51	2026-04-17	Costo de Ventas	costo_venta	0.00	0.00	venta	25	1	2026-04-16 22:03:07.028868
52	2026-04-17	Inventario	costo_venta	0.00	0.00	venta	25	1	2026-04-16 22:03:07.028868
53	2026-04-19	Gasto Operativo: ELECTRICIDAD	gasto_operativo	50.00	0.00	gasto_operativo	1	1	2026-04-19 15:53:51.852632
54	2026-04-19	Pago de Gasto Operativo	gasto_operativo	0.00	50.00	gasto_operativo	1	1	2026-04-19 15:53:51.852632
55	2026-04-19	Gasto Operativo: ELECTRICIDAD	gasto_operativo	35.50	0.00	gasto_operativo	2	1	2026-04-19 15:54:19.255008
56	2026-04-19	Pago de Gasto Operativo	gasto_operativo	0.00	35.50	gasto_operativo	2	1	2026-04-19 15:54:19.255008
57	2026-04-19	Gasto Operativo: OTROS - Reparaci	gasto_operativo	120.00	0.00	gasto_operativo	3	1	2026-04-19 16:09:18.693335
58	2026-04-19	Pago de Gasto Operativo	gasto_operativo	0.00	120.00	gasto_operativo	3	1	2026-04-19 16:09:18.693335
59	2026-04-19	Compra de mercancía	compra_insumo	50.00	0.00	compra	2	1	2026-04-19 16:11:07.468906
60	2026-04-19	Salida de Caja/Bancos por Compra	compra_insumo	0.00	50.00	compra	2	1	2026-04-19 16:11:07.468906
61	2026-04-19	Compra de mercancía	compra_insumo	50.00	0.00	compra	3	1	2026-04-19 16:11:35.513858
62	2026-04-19	Salida de Caja/Bancos por Compra	compra_insumo	0.00	50.00	compra	3	1	2026-04-19 16:11:35.513858
63	2026-04-19	Compra de mercancía Fac: 0156	compra_insumo	127.50	0.00	compra	4	1	2026-04-19 16:58:45.147314
64	2026-04-19	Salida de Caja/Bancos por Compra	compra_insumo	0.00	127.50	compra	4	1	2026-04-19 16:58:45.147314
65	2026-04-19	Ingreso a Caja/Bancos por Venta	venta	7.15	0.00	venta	28	1	2026-04-19 17:53:12.778435
66	2026-04-19	Ingresos por Ventas	venta	0.00	7.15	venta	28	1	2026-04-19 17:53:12.778435
67	2026-04-19	Costo de Ventas	costo_venta	0.00	0.00	venta	28	1	2026-04-19 17:53:12.778435
68	2026-04-19	Inventario	costo_venta	0.00	0.00	venta	28	1	2026-04-19 17:53:12.778435
69	2026-04-19	Ingreso a Caja/Bancos por Venta	venta	26.40	0.00	venta	29	1	2026-04-19 17:57:52.097927
70	2026-04-19	Ingresos por Ventas	venta	0.00	26.40	venta	29	1	2026-04-19 17:57:52.097927
71	2026-04-19	Costo de Ventas	costo_venta	0.00	0.00	venta	29	1	2026-04-19 17:57:52.097927
72	2026-04-19	Inventario	costo_venta	0.00	0.00	venta	29	1	2026-04-19 17:57:52.097927
73	2026-04-19	Ingreso a Caja/Bancos por Venta	venta	7.15	0.00	venta	30	1	2026-04-19 18:01:07.081599
74	2026-04-19	Ingresos por Ventas	venta	0.00	7.15	venta	30	1	2026-04-19 18:01:07.081599
75	2026-04-19	Costo de Ventas	costo_venta	0.00	0.00	venta	30	1	2026-04-19 18:01:07.081599
76	2026-04-19	Inventario	costo_venta	0.00	0.00	venta	30	1	2026-04-19 18:01:07.081599
77	2026-04-24	Cobro de Pedido - Caja	venta	15.95	0.00	venta	1	1	2026-04-23 20:12:23.587429
78	2026-04-24	Ingresos por Ventas	venta	0.00	15.95	venta	1	1	2026-04-23 20:12:23.587429
79	2026-04-24	Cobro de Pedido - Caja	venta	26.40	0.00	venta	2	1	2026-04-23 20:19:51.019828
80	2026-04-24	Ingresos por Ventas	venta	0.00	26.40	venta	2	1	2026-04-23 20:19:51.019828
81	2026-04-24	Cobro de Pedido - Caja	venta	26.40	0.00	venta	3	1	2026-04-23 20:22:01.040533
82	2026-04-24	Ingresos por Ventas	venta	0.00	26.40	venta	3	1	2026-04-23 20:22:01.040533
83	2026-04-24	Cobro de Pedido - Caja	venta	73.70	0.00	venta	4	1	2026-04-23 20:25:49.802483
84	2026-04-24	Ingresos por Ventas	venta	0.00	73.70	venta	4	1	2026-04-23 20:25:49.802483
85	2026-04-24	Cobro de Pedido - Caja	venta	79.20	0.00	venta	5	1	2026-04-23 20:58:07.398259
86	2026-04-24	Ingresos por Ventas	venta	0.00	79.20	venta	5	1	2026-04-23 20:58:07.398259
87	2026-04-24	Cobro de Pedido - Caja	venta	7.15	0.00	venta	28	1	2026-04-23 20:58:14.847819
88	2026-04-24	Ingresos por Ventas	venta	0.00	7.15	venta	28	1	2026-04-23 20:58:14.847819
89	2026-04-24	Cobro de Pedido - Caja	venta	26.40	0.00	venta	29	1	2026-04-23 20:58:19.894282
90	2026-04-24	Ingresos por Ventas	venta	0.00	26.40	venta	29	1	2026-04-23 20:58:19.894282
91	2026-04-24	Cobro de Pedido - Caja	venta	7.15	0.00	venta	30	1	2026-04-23 20:58:26.816428
92	2026-04-24	Ingresos por Ventas	venta	0.00	7.15	venta	30	1	2026-04-23 20:58:26.816428
93	2026-04-24	Ingreso a Caja/Bancos por Venta	venta	13.75	0.00	venta	31	1	2026-04-23 21:04:55.616863
94	2026-04-24	Ingresos por Ventas	venta	0.00	13.75	venta	31	1	2026-04-23 21:04:55.616863
95	2026-04-24	Costo de Ventas	costo_venta	0.00	0.00	venta	31	1	2026-04-23 21:04:55.616863
96	2026-04-24	Inventario	costo_venta	0.00	0.00	venta	31	1	2026-04-23 21:04:55.616863
97	2026-04-24	Cobro de Pedido - Caja	venta	13.75	0.00	venta	31	1	2026-04-23 21:08:06.779955
98	2026-04-24	Ingresos por Ventas	venta	0.00	13.75	venta	31	1	2026-04-23 21:08:06.779955
99	2026-04-24	Ingreso a Caja/Bancos por Venta	venta	10.45	0.00	venta	32	1	2026-04-24 13:27:53.546246
100	2026-04-24	Ingresos por Ventas	venta	0.00	10.45	venta	32	1	2026-04-24 13:27:53.546246
101	2026-04-24	Costo de Ventas	costo_venta	0.00	0.00	venta	32	1	2026-04-24 13:27:53.546246
102	2026-04-24	Inventario	costo_venta	0.00	0.00	venta	32	1	2026-04-24 13:27:53.546246
103	2026-04-24	Cobro de Pedido - Caja	venta	10.45	0.00	venta	32	1	2026-04-24 13:29:49.277638
104	2026-04-24	Ingresos por Ventas	venta	0.00	10.45	venta	32	1	2026-04-24 13:29:49.277638
105	2026-04-24	Ingreso a Caja/Bancos por Venta	venta	7.15	0.00	venta	33	1	2026-04-24 13:38:26.40887
106	2026-04-24	Ingresos por Ventas	venta	0.00	7.15	venta	33	1	2026-04-24 13:38:26.40887
107	2026-04-24	Costo de Ventas	costo_venta	0.00	0.00	venta	33	1	2026-04-24 13:38:26.40887
108	2026-04-24	Inventario	costo_venta	0.00	0.00	venta	33	1	2026-04-24 13:38:26.40887
109	2026-04-24	Ingreso a Caja/Bancos por Venta	venta	33.00	0.00	venta	34	1	2026-04-24 18:46:19.830914
110	2026-04-24	Ingresos por Ventas	venta	0.00	33.00	venta	34	1	2026-04-24 18:46:19.830914
111	2026-04-24	Costo de Ventas	costo_venta	0.00	0.00	venta	34	1	2026-04-24 18:46:19.830914
112	2026-04-24	Inventario	costo_venta	0.00	0.00	venta	34	1	2026-04-24 18:46:19.830914
113	2026-04-24	Ingreso a Caja/Bancos por Venta	venta	33.00	0.00	venta	35	1	2026-04-24 18:47:40.808388
114	2026-04-24	Ingresos por Ventas	venta	0.00	33.00	venta	35	1	2026-04-24 18:47:40.808388
115	2026-04-24	Costo de Ventas	costo_venta	0.00	0.00	venta	35	1	2026-04-24 18:47:40.808388
116	2026-04-24	Inventario	costo_venta	0.00	0.00	venta	35	1	2026-04-24 18:47:40.808388
117	2026-04-24	Cobro de Pedido - Caja	venta	7.15	0.00	venta	33	1	2026-04-24 18:50:02.133111
118	2026-04-24	Ingresos por Ventas	venta	0.00	7.15	venta	33	1	2026-04-24 18:50:02.133111
119	2026-04-24	Cobro de Pedido - Caja	venta	33.00	0.00	venta	34	1	2026-04-24 18:50:04.000746
120	2026-04-24	Ingresos por Ventas	venta	0.00	33.00	venta	34	1	2026-04-24 18:50:04.000746
121	2026-04-24	Cobro de Pedido - Caja	venta	33.00	0.00	venta	35	1	2026-04-24 18:50:05.511531
122	2026-04-24	Ingresos por Ventas	venta	0.00	33.00	venta	35	1	2026-04-24 18:50:05.511531
123	2026-04-24	Ingreso a Caja/Bancos por Venta	venta	3.30	0.00	venta	36	1	2026-04-24 18:51:14.195529
124	2026-04-24	Ingresos por Ventas	venta	0.00	3.30	venta	36	1	2026-04-24 18:51:14.195529
125	2026-04-24	Costo de Ventas	costo_venta	0.00	0.00	venta	36	1	2026-04-24 18:51:14.195529
126	2026-04-24	Inventario	costo_venta	0.00	0.00	venta	36	1	2026-04-24 18:51:14.195529
127	2026-05-02	Gasto Operativo: OTROS - intereses bancarios	gasto_operativo	150.00	0.00	gasto_operativo	4	1	2026-05-02 21:08:48.286716
128	2026-05-02	Pago de Gasto Operativo	gasto_operativo	0.00	150.00	gasto_operativo	4	1	2026-05-02 21:08:48.286716
129	2026-05-02	Gasto Operativo: AGUA - gasto en factura de agua corriente	gasto_operativo	150.00	0.00	gasto_operativo	5	1	2026-05-02 21:09:18.495557
130	2026-05-02	Pago de Gasto Operativo	gasto_operativo	0.00	150.00	gasto_operativo	5	1	2026-05-02 21:09:18.495557
131	2026-05-02	Compra de mercancía Fac: V1234	compra_insumo	2750.00	0.00	compra	5	1	2026-05-02 21:11:27.292936
132	2026-05-02	Salida de Caja/Bancos por Compra	compra_insumo	0.00	2750.00	compra	5	1	2026-05-02 21:11:27.292936
133	2026-05-03	Ingreso a Caja/Bancos por Venta	venta	20.90	0.00	venta	37	1	2026-05-02 21:30:19.834172
134	2026-05-03	Ingresos por Ventas	venta	0.00	20.90	venta	37	1	2026-05-02 21:30:19.834172
135	2026-05-03	Costo de Ventas	costo_venta	0.00	0.00	venta	37	1	2026-05-02 21:30:19.834172
136	2026-05-03	Inventario	costo_venta	0.00	0.00	venta	37	1	2026-05-02 21:30:19.834172
137	2026-05-03	Cobro de Pedido - Caja	venta	20.90	0.00	venta	37	1	2026-05-02 21:32:54.147476
138	2026-05-03	Ingresos por Ventas	venta	0.00	20.90	venta	37	1	2026-05-02 21:32:54.147476
139	2026-05-09	Compra de mercancía	compra_insumo	10.00	0.00	compra	7	1	2026-05-08 21:21:25.510437
140	2026-05-09	Salida de Caja/Bancos por Compra	compra_insumo	0.00	10.00	compra	7	1	2026-05-08 21:21:25.510437
141	2026-05-08	Compra de mercancía Fac: Fac-010	compra_insumo	12.50	0.00	compra	8	1	2026-05-08 22:26:39.615715
142	2026-05-08	Salida de Caja/Bancos por Compra	compra_insumo	0.00	12.50	compra	8	1	2026-05-08 22:26:39.615715
143	2026-05-18	Compra de mercancía Fac: 1234555	compra_insumo	4000.00	0.00	compra	9	1	2026-05-18 19:39:11.633153
144	2026-05-18	Salida de Caja/Bancos por Compra	compra_insumo	0.00	4000.00	compra	9	1	2026-05-18 19:39:11.633153
145	2026-05-18	Gasto Operativo: AGUA	gasto_operativo	157.00	0.00	gasto_operativo	6	1	2026-05-18 19:45:31.316728
146	2026-05-18	Pago de Gasto Operativo	gasto_operativo	0.00	157.00	gasto_operativo	6	1	2026-05-18 19:45:31.316728
147	2026-05-18	Compra de mercancía Fac: 123456	compra_insumo	250.00	0.00	compra	10	1	2026-05-18 19:46:36.140914
148	2026-05-18	Salida de Caja/Bancos por Compra	compra_insumo	0.00	250.00	compra	10	1	2026-05-18 19:46:36.140914
149	2026-05-18	Compra de mercancía Fac: 123456	compra_insumo	42.50	0.00	compra	11	1	2026-05-18 19:54:20.251235
150	2026-05-18	Cuentas por Pagar Proveedores	compra_insumo	0.00	42.50	compra	11	1	2026-05-18 19:54:20.251235
\.


--
-- TOC entry 4412 (class 0 OID 19243)
-- Dependencies: 234
-- Data for Name: plan_cuentas; Type: TABLE DATA; Schema: contabilidad; Owner: postgres
--

COPY contabilidad.plan_cuentas (id, codigo, nombre, tipo, padre_id, es_auxiliar, restaurante_id, activo, created_at) FROM stdin;
1	1	ACTIVOS	activo	\N	f	\N	t	2026-03-31 21:43:41.142979
6	2	PASIVOS	pasivo	\N	f	\N	t	2026-03-31 21:43:41.142979
9	3	PATRIMONIO	patrimonio	\N	f	\N	t	2026-03-31 21:43:41.142979
13	4	INGRESOS	ingreso	\N	f	\N	t	2026-03-31 21:43:41.142979
15	5	COSTOS DE VENTA	costo	\N	f	\N	t	2026-03-31 21:43:41.142979
17	6	GASTOS OPERATIVOS	gasto	\N	f	\N	t	2026-03-31 21:43:41.142979
2	1.1	Activos Corrientes	activo	1	f	\N	t	2026-03-31 21:43:41.142979
3	1.1.01	Caja	activo	2	t	\N	t	2026-03-31 21:43:41.142979
4	1.1.02	Banco	activo	2	t	\N	t	2026-03-31 21:43:41.142979
5	1.1.03	Inventario de Insumos	activo	2	t	\N	t	2026-03-31 21:43:41.142979
7	2.1	Pasivos Corrientes	pasivo	6	f	\N	t	2026-03-31 21:43:41.142979
8	2.1.01	Cuentas por Pagar a Proveedores	pasivo	7	t	\N	t	2026-03-31 21:43:41.142979
10	3.1.01	Capital Social	patrimonio	9	t	\N	t	2026-03-31 21:43:41.142979
11	3.1.02	Utilidades Acumuladas	patrimonio	9	t	\N	t	2026-03-31 21:43:41.142979
12	3.1.03	Utilidad / Pérdida del Ejercicio	patrimonio	9	t	\N	t	2026-03-31 21:43:41.142979
14	4.1.01	Ingresos por Ventas	ingreso	13	t	\N	t	2026-03-31 21:43:41.142979
16	5.1.01	Costo de Ventas (Ingredientes)	costo	15	t	\N	t	2026-03-31 21:43:41.142979
18	6.1.01	Gasto Agua	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
19	6.1.02	Gasto Gas	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
20	6.1.03	Gasto Electricidad	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
21	6.1.04	Gasto Internet	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
22	6.1.05	Gasto Alquiler	gasto	17	t	\N	t	2026-03-31 21:43:41.142979
\.


--
-- TOC entry 4415 (class 0 OID 19287)
-- Dependencies: 239
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.metodos_pago (id, nombre, activo, restaurante_id, created_at) FROM stdin;
1	Efectivo	t	1	2026-04-01 14:48:28.891424
2	Pago Movil	t	1	2026-04-01 14:48:39.610028
3	Tarjeta Debito/Credito	t	1	2026-04-01 14:48:42.919442
4	Divisa (USD/EUR)	t	1	2026-04-01 14:48:45.589603
\.


--
-- TOC entry 4414 (class 0 OID 19254)
-- Dependencies: 236
-- Data for Name: restaurante; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.restaurante (id, nombre, direccion, telefono, email, logo_url, moneda, zona_horaria, impuesto_porcentaje, propina_porcentaje, patrimonio_inicial, activo, created_at, updated_at) FROM stdin;
2	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 21:52:48.010658	2026-03-17 21:52:48.010658
3	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 21:59:59.449976	2026-03-17 21:59:59.449976
4	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 22:00:30.926985	2026-03-17 22:00:30.926985
5	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 22:20:35.042632	2026-03-17 22:20:35.042632
6	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-17 22:35:18.121913	2026-03-17 22:35:18.121913
7	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:33:18.852771	2026-03-18 16:33:18.852771
8	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:33:27.781321	2026-03-18 16:33:27.781321
9	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:33:35.43098	2026-03-18 16:33:35.43098
10	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:35:36.794919	2026-03-18 16:35:36.794919
11	Komanda Default	\N	\N	\N	\N	USD	America/Caracas	12.00	0.00	0.00	t	2026-03-18 16:48:52.562202	2026-03-18 16:48:52.562202
1	Example	cabudare	0412 555 1041	example@gmail.com	\N	VES	America/Caracas	10.00	20.00	0.00	t	2026-03-03 10:56:13.498568	2026-04-19 17:12:06.721702
12	Audit Test 2	Calle Falsa 123	555-1234	audit2@test.com	\N	USD	America/Caracas	10.00	5.00	0.00	t	2026-04-23 21:12:29.126028	2026-04-23 21:12:29.126028
13	IUJO	Av Pedro Leon con Carrera 57, Barquisimeto Edo. Lara	04125551041	IUJO@gmail.com	\N	USD	America/Caracas	10.00	5.00	0.00	t	2026-05-18 23:34:14.519065	2026-05-18 23:34:14.519065
\.


--
-- TOC entry 4418 (class 0 OID 19297)
-- Dependencies: 242
-- Data for Name: roles; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.roles (id, nombre, created_at) FROM stdin;
1	admin	2026-03-03 10:56:13.498568
2	cajero	2026-03-24 20:21:54.161944
3	mesero	2026-03-24 20:22:05.04884
4	cocina	2026-03-24 20:22:15.689054
5	super_admin	2026-03-31 21:43:41.176333
\.


--
-- TOC entry 4420 (class 0 OID 19305)
-- Dependencies: 244
-- Data for Name: tables; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.tables (id, nombre, capacidad, status) FROM stdin;
1	Mesa 1 (Ventana)	4	available
2	Mesa 2 (Terraza)	2	available
3	Mesa 3 (VIP)	6	available
4	Mesa 4 (Centro)	4	available
5	Mesa 5 (Esquina)	2	available
6	Mesa 6 (Premium)	8	available
7	Barra 1	1	available
8	Barra 2	1	available
9	Barra 3	1	available
10	Terraza 2	4	available
\.


--
-- TOC entry 4422 (class 0 OID 19313)
-- Dependencies: 246
-- Data for Name: unidad_medida; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.unidad_medida (id, nombre, abreviatura) FROM stdin;
1	Gramos	g
2	Litros	L
3	Kilogramos	kg
4	Unidades	und
5	Mililitros	ml
\.


--
-- TOC entry 4424 (class 0 OID 19320)
-- Dependencies: 248
-- Data for Name: usuarios; Type: TABLE DATA; Schema: core; Owner: postgres
--

COPY core.usuarios (id, restaurante_id, rol_id, nombre, email, username, password_hash, activo, created_at, updated_at) FROM stdin;
1	1	1	Rafael Alvarez	alvarezrafaelat@gmail.com	rafa	$2b$10$6JMAAOJhP4KELVmgGzmNPusKbj26cDTk1novu7g3iZIbDczvuy4cy	t	2026-03-03 10:56:13.498568	2026-03-24 20:02:26.070936
4	1	3	mesero	mesero@gmail.com	mesero	$2b$10$zA0NSzdBPINEZ4exKuAdUumphVwNFm6W4P7v.g8pBMSbbx16e4jxK	t	2026-04-19 17:26:46.221099	2026-04-19 17:26:46.221099
3	1	2	ejemplo ejemplo 2	ejemplo2@gmail.com	ejemplo1234	$2b$10$3pnS/YawKWVC/Ve.xJ87iOzqmAQkvBVP7B7MMBK/eM8l/FR84T/y2	f	2026-03-24 20:09:48.932891	2026-04-19 17:26:51.042622
2	1	4	ejemplo ejemplo	ejemplo@gmail.com	ejemplo123	$2b$10$fP3fFvAXpX7QKyH5Y8XhpOTyJisJ9oQy0uqk2rGi.kHok.sfFejUe	f	2026-03-24 20:03:50.680361	2026-04-19 17:26:54.802642
6	1	4	cocinero	cocinero@gmail.com	cocinero	$2b$10$IsS.3MDq5Hz/qznu83SUI.6gJoRzzH.KbVUwBzV3PDb.7gptCUN1m	t	2026-04-19 17:27:48.751581	2026-04-19 17:27:48.751581
5	1	2	cajero	cajero@gmail.com	cajero	$2b$10$vteitQw.UU2C5ic0SnRoX.kdWkKGafysqXaGahOBoIWJVIAX8qtZa	t	2026-04-19 17:27:18.001426	2026-04-23 20:38:59.841053
7	12	1	Admin Audit	admin@audit2.com	adminaudit2	$2b$10$gLNAwx1HEvVWUxZAVEG2eeYAw6vsGqbGEtk8hJd.YcEsQuYdsDn6K	t	2026-04-23 21:12:29.126028	2026-04-23 21:12:29.126028
10	13	4	cocinero cocinero	cocinero@gmail.com	cocineroiujo	$2b$10$eOqIuGFsaBXVYnu9MWsnR.a6U7Rzt0qzdy9/jMpJvepZElmPvUuRK	t	2026-05-18 23:38:32.532967	2026-05-18 23:38:32.532967
11	13	2	cajero cajero	cajero@gmail.com	cajeroiujo	$2b$10$mGgQMtkxEdwZirqmNo3/1.kOjSaabxghkcb03fzwzQoP4tvo/HUhe	t	2026-05-18 23:39:00.780919	2026-05-18 23:39:00.780919
8	13	1	iujo admin	iujo@gmail.com	adminiujo	$2b$10$KQWIABfzj3Dhz8mHJFQn0e1ijKilTywjVXtwIA5/Qi8ulmtNusDPi	t	2026-05-18 23:34:14.519065	2026-05-19 00:26:38.016868
9	13	3	mesero mesero	mesero@gmail.com	meseroiujo	$2b$10$cEelyKS/XvaUe9HeQgmndeoIAg3VkzbDUHInS/qbLR.8A/L1RzQOu	t	2026-05-18 23:36:32.846319	2026-05-19 00:26:46.243964
\.


--
-- TOC entry 4426 (class 0 OID 19339)
-- Dependencies: 250
-- Data for Name: banco; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.banco (id, nombre_banco, numero_cuenta, saldo_actual, activo, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4428 (class 0 OID 19351)
-- Dependencies: 252
-- Data for Name: banco_movimientos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.banco_movimientos (id, banco_id, fecha_hora, tipo, monto, concepto, referencia_tipo, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4430 (class 0 OID 19366)
-- Dependencies: 254
-- Data for Name: caja; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.caja (id, fecha_apertura, fecha_cierre, monto_inicial, monto_final, monto_teorico, diferencia, estado, usuario_apertura_id, usuario_cierre_id, observaciones, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4432 (class 0 OID 19379)
-- Dependencies: 256
-- Data for Name: caja_movimientos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.caja_movimientos (id, caja_id, fecha_hora, tipo, monto, concepto, referencia_tipo, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4434 (class 0 OID 19394)
-- Dependencies: 258
-- Data for Name: egresos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.egresos (id, fecha, monto, categoria_id, razon, descripcion, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4436 (class 0 OID 19407)
-- Dependencies: 260
-- Data for Name: gastos_operativos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.gastos_operativos (id, categoria, descripcion, monto, fecha, metodo_pago, referencia, periodo_mes, periodo_anio, usuario_id, restaurante_id, created_at) FROM stdin;
1	electricidad		50.00	2026-04-19	efectivo		4	2026	1	1	2026-04-19 15:53:51.852632
2	electricidad		35.50	2026-04-19	efectivo		4	2026	1	1	2026-04-19 15:54:19.255008
3	otros	Reparaci	120.00	2026-04-19	efectivo		4	2026	1	1	2026-04-19 16:09:18.693335
4	otros	intereses bancarios	150.00	2026-05-02	pago_movil	0102	5	2026	1	1	2026-05-02 21:08:48.286716
5	agua	gasto en factura de agua corriente	150.00	2026-05-02	pago_movil	1234	5	2026	1	1	2026-05-02 21:09:18.495557
6	agua		157.00	2026-05-18	efectivo		5	2026	1	1	2026-05-18 19:45:31.316728
7	otros	compra articulos limpieza	160.00	2026-05-18	tarjeta	0156	5	2026	1	1	2026-05-18 22:02:23.588927
8	electricidad		10.00	2026-05-19	efectivo		5	2026	8	13	2026-05-19 00:22:23.712488
\.


--
-- TOC entry 4438 (class 0 OID 19421)
-- Dependencies: 262
-- Data for Name: categoria_egresos; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.categoria_egresos (id, nombre, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4440 (class 0 OID 19429)
-- Dependencies: 264
-- Data for Name: compra_detalle; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.compra_detalle (id, compra_id, ingrediente_id, cantidad_compra, unidad_compra_id, precio_unitario, factor_conversion, restaurante_id) FROM stdin;
2	2	10	10.000	10	5.00	1.000	1
4	4	12	15.000	10	4.50	1.000	1
5	4	10	30.000	10	2.00	2.000	1
6	5	13	40.000	10	50.00	1.000	1
10	8	18	50.000	\N	0.25	1.000	1
11	9	19	50.000	\N	80.00	1.000	1
12	10	20	100.000	\N	2.50	1.000	1
13	11	21	50.000	\N	0.85	36.000	1
14	12	21	5.000	\N	0.85	36.000	1
15	13	28	50.000	\N	1.00	36.000	13
\.


--
-- TOC entry 4442 (class 0 OID 19442)
-- Dependencies: 266
-- Data for Name: compras; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.compras (id, fecha, numero_factura_proveedor, total, estado_pago, saldo_pendiente, descripcion, proveedor_id, restaurante_id, created_at) FROM stdin;
2	2026-04-19		50.00	pagada	0.00	\N	\N	1	2026-04-19 16:11:07.468906
3	2026-04-19		50.00	pagada	0.00	\N	\N	1	2026-04-19 16:11:35.513858
4	2026-04-19	0156	127.50	pagada	0.00	\N	\N	1	2026-04-19 16:58:45.147314
5	2026-05-02	V1234	2750.00	pagada	0.00	\N	1	1	2026-05-02 21:11:27.292936
7	2026-05-09		10.00	pagada	0.00	\N	\N	1	2026-05-08 21:21:25.510437
8	2026-05-08	Fac-010	12.50	pagada	0.00	\N	1	1	2026-05-08 22:26:39.615715
9	2026-05-18	1234555	4000.00	pagada	0.00	\N	6	1	2026-05-18 19:39:11.633153
10	2026-05-18	123456	250.00	pagada	0.00	\N	5	1	2026-05-18 19:46:36.140914
11	2026-05-18	123456	42.50	pendiente	42.50	\N	1	1	2026-05-18 19:54:20.251235
12	2026-05-18	123456	4.25	pagada	0.00	\N	1	1	2026-05-18 19:56:29.754181
13	2026-05-19	fac-01	50.00	pendiente	50.00	\N	7	13	2026-05-19 00:24:59.537339
\.


--
-- TOC entry 4444 (class 0 OID 19453)
-- Dependencies: 268
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.ingredientes (id, nombre, cantidad_disponible, cantidad_minima, unidad_id, costo_promedio, merma_teorica_porcentaje, restaurante_id, created_at, updated_at) FROM stdin;
25	Harina de Maiz	99.700	50.000	3	0.85	0.00	13	2026-05-18 23:57:43.64016	2026-05-19 00:09:16.198163
26	Sal	99.970	25.000	3	0.50	0.00	13	2026-05-18 23:58:19.218535	2026-05-19 00:09:16.198163
27	Agua Purificada	99.700	25.000	2	1.00	0.00	13	2026-05-18 23:58:51.375736	2026-05-19 00:09:16.198163
28	Cerveza Polar Negra Botella	1800.000	10.000	4	0.03	0.00	13	2026-05-19 00:24:59.537339	2026-05-19 00:24:59.537339
16	Zardinas enlatadas	60.000	10.000	4	1.25	0.00	1	2026-05-08 22:10:30.029057	2026-05-08 22:23:32.053439
12	vinagre	15.000	5.000	2	4.50	0.00	1	2026-04-19 16:58:45.147314	2026-05-08 22:24:04.751104
18	Papas	50.000	15.000	3	0.25	0.00	1	2026-05-08 22:26:39.615715	2026-05-08 22:27:01.820235
19	Caviar Enlatado	50.000	10.000	4	80.00	0.00	1	2026-05-18 19:39:11.633153	2026-05-18 19:39:11.633153
20	Suero Tapara	100.000	15.000	2	2.50	0.00	1	2026-05-18 19:46:36.140914	2026-05-18 19:46:36.140914
21	Polar Negra	1980.000	10.000	4	0.02	0.00	1	2026-05-18 19:54:20.251235	2026-05-18 19:56:29.754181
10	Sal de mar	50.000	0.000	1	1.57	0.00	1	2026-04-19 16:11:07.468906	2026-05-18 23:25:18.457076
22	Agua Mineral Purificada	99.700	10.000	2	1.00	0.00	1	2026-05-18 22:27:29.891059	2026-05-18 23:25:18.457076
13	Harina de Maiz	999.700	0.000	3	50.00	0.00	1	2026-05-02 21:11:27.292936	2026-05-18 23:25:18.457076
\.


--
-- TOC entry 4446 (class 0 OID 19467)
-- Dependencies: 270
-- Data for Name: mermas; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.mermas (id, ingrediente_id, cantidad, tipo, razon, reportado_por, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4448 (class 0 OID 19482)
-- Dependencies: 272
-- Data for Name: proveedores; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.proveedores (id, identificacion, nombre, telefono, email, direccion, restaurante_id, banco_nombre, banco_cuenta_numero, activo, observaciones, created_at, updated_at) FROM stdin;
5	V-25000001	Lacteos del Sur C.A.	0241-888-7777	info@lacteossur.com		1	Venezuela		t		2026-04-19 15:50:16.512869	2026-04-19 15:50:16.512869
1	J-12345678-9	Distribuidora de Alimentos Polar	0212-555-1234	ventas@polar.com	Caracas, Venezuela	1	Banesco	0134-XXXX-XXXX-XXXX	t	\N	2026-04-19 14:59:32.451638	2026-04-19 16:25:14.50664
6	J-31757781-4	Juandiego	0412-5551041	juandiego@gmail.com	piritu portuguesa	1	Banesco	0134-0000-0000-0000	t	ninguna	2026-04-19 16:00:09.24901	2026-05-02 21:11:58.21806
7	J-31757781-4	Polar	0412-5551041	polar@gmail.com	ninguna	13	banco exterior	0134-1111-11111-1111	t		2026-05-19 00:23:31.161915	2026-05-19 00:23:31.161915
\.


--
-- TOC entry 4450 (class 0 OID 19495)
-- Dependencies: 274
-- Data for Name: unidad_compra; Type: TABLE DATA; Schema: inventario; Owner: postgres
--

COPY inventario.unidad_compra (id, nombre, restaurante_id, created_at) FROM stdin;
8	Kilogramo (kg)	1	2026-04-19 16:03:13.667849
9	Litro (L)	1	2026-04-19 16:03:13.667849
10	Unidad (u)	1	2026-04-19 16:03:13.667849
11	Gramo (g)	1	2026-04-19 16:03:13.667849
12	Mililitro (mL)	1	2026-04-19 16:03:13.667849
13	Saco 50kg	1	2026-04-19 16:03:13.667849
14	Caja 12u	1	2026-04-19 16:03:13.667849
15	Paquete	1	2026-04-19 16:03:13.667849
16	Unidad	2	2026-05-08 20:35:50.51758
17	Unidad	3	2026-05-08 20:35:50.51758
18	Unidad	4	2026-05-08 20:35:50.51758
19	Unidad	5	2026-05-08 20:35:50.51758
20	Unidad	6	2026-05-08 20:35:50.51758
21	Unidad	7	2026-05-08 20:35:50.51758
22	Unidad	8	2026-05-08 20:35:50.51758
23	Unidad	9	2026-05-08 20:35:50.51758
24	Unidad	10	2026-05-08 20:35:50.51758
25	Unidad	11	2026-05-08 20:35:50.51758
26	Unidad	1	2026-05-08 20:35:50.51758
27	Unidad	12	2026-05-08 20:35:50.51758
\.


--
-- TOC entry 4452 (class 0 OID 19503)
-- Dependencies: 276
-- Data for Name: categories; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

COPY inventory.categories (id, nombre) FROM stdin;
1	Bebidas
2	Platos Fuertes
3	Postres
4	Cafetería
5	Entradas
6	Carnes
7	Ensaladas
\.


--
-- TOC entry 4454 (class 0 OID 19509)
-- Dependencies: 278
-- Data for Name: products; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

COPY inventory.products (id, nombre, precio_venta, categoria_id, imagen_url, activo) FROM stdin;
1	Coca Cola JUMBO	2.50	1	\N	t
2	Agua Mineral	1.00	1	\N	t
3	Jugo de Naranja	2.00	1	\N	t
4	Limonada	1.50	1	\N	t
5	Cerveza Artesanal	3.50	1	\N	t
6	Vino Tinto (Copa)	4.00	1	\N	t
7	Hamburguesa Doble	8.50	2	\N	t
8	Pizza Margarita	12.00	2	\N	t
9	Pasta Alfredo	10.50	2	\N	t
10	Sushi Roll (8 piezas)	14.00	2	\N	t
11	Tacos al Pastor (3)	7.50	2	\N	t
12	Pollo a la Plancha	9.00	2	\N	t
13	Tiramisú	4.50	3	\N	t
14	Pastel de Chocolate	5.00	3	\N	t
15	Helado 2 Sabores	3.50	3	\N	t
16	Flan Napolitano	3.00	3	\N	t
17	Café Americano	1.50	4	\N	t
18	Cappuccino	2.50	4	\N	t
19	Latte	2.50	4	\N	t
20	Espresso	1.00	4	\N	t
21	Té Matcha	3.00	4	\N	t
22	Tequeños (5)	5.50	5	\N	t
23	Papas Fritas	3.50	5	\N	t
24	Aros de Cebolla	4.00	5	\N	t
25	Nachos con Queso	6.00	5	\N	t
26	Filet Mignon	22.00	6	\N	t
27	Ribeye	25.00	6	\N	t
28	Costillas BBQ	18.00	6	\N	t
29	Ensalada César	8.00	7	\N	t
30	Ensalada Caprese	7.50	7	\N	t
31	Ensalada Mixta	6.00	7	\N	t
\.


--
-- TOC entry 4456 (class 0 OID 19517)
-- Dependencies: 280
-- Data for Name: categorias; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.categorias (id, nombre, orden, activo, restaurante_id, created_at, updated_at) FROM stdin;
1	Entradas	1	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
2	Platos Fuertes	2	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
3	Bebidas	3	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
4	Postres	4	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
5	categoria de prueba	5	t	1	2026-05-18 22:22:57.589634	2026-05-18 22:22:57.589634
6	Desayuno	1	t	13	2026-05-18 23:59:18.39874	2026-05-18 23:59:18.39874
\.


--
-- TOC entry 4458 (class 0 OID 19528)
-- Dependencies: 282
-- Data for Name: receta_ingredientes; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.receta_ingredientes (id, receta_id, ingrediente_id, cantidad, restaurante_id) FROM stdin;
34	11	10	10.000	1
35	11	22	0.150	1
36	11	13	0.150	1
37	12	27	0.150	13
38	12	25	0.150	13
39	12	26	0.015	13
\.


--
-- TOC entry 4460 (class 0 OID 19537)
-- Dependencies: 284
-- Data for Name: recetas; Type: TABLE DATA; Schema: menu; Owner: postgres
--

COPY menu.recetas (id, nombre, descripcion, categoria_id, imagen_url, costo_produccion, precio_sugerido, precio_venta, margen_utilidad, activo, restaurante_id, created_at, updated_at) FROM stdin;
1	Nachos con Guacamole	\N	1	\N	0.00	0.00	6.50	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
2	Hamburguesa Komanda	\N	2	\N	0.00	0.00	9.50	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
3	Limonada Natural	\N	3	\N	0.00	0.00	3.00	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
4	Flan Napolitano	\N	4	\N	0.00	0.00	5.00	0.00	t	1	2026-03-24 19:31:17.54503	2026-03-24 19:31:17.54503
11	Arepa	asdfgh	5		0.00	0.00	34.00	0.00	t	1	2026-05-18 23:19:03.377687	2026-05-18 23:24:48.943645
12	Arepa	ninguna	6		0.00	0.00	1.50	0.00	t	13	2026-05-19 00:01:18.496641	2026-05-19 00:01:18.496641
\.


--
-- TOC entry 4462 (class 0 OID 19557)
-- Dependencies: 287
-- Data for Name: facturas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.facturas (id, numero_factura, pedido_id, metodo_pago_id, usuario_id, cliente_nombre, cliente_identificacion, cliente_direccion, cliente_email, fecha, subtotal, descuento, impuestos, propina, total, estado, restaurante_id, created_at) FROM stdin;
\.


--
-- TOC entry 4464 (class 0 OID 19576)
-- Dependencies: 289
-- Data for Name: mesas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.mesas (id, numero, nombre, capacidad, estado, restaurante_id, created_at, updated_at) FROM stdin;
10	2		4	libre	1	2026-04-24 19:01:24.51284	2026-04-24 19:01:24.51284
11	3	Calle	4	libre	1	2026-04-24 19:01:37.539465	2026-04-24 19:01:37.539465
9	1		4	libre	1	2026-04-24 19:01:13.713194	2026-05-18 23:26:18.870635
12	1	mesa comedor	6	libre	13	2026-05-19 00:02:19.590492	2026-05-19 00:15:38.112276
\.


--
-- TOC entry 4466 (class 0 OID 19587)
-- Dependencies: 291
-- Data for Name: meseros; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.meseros (id, nombre, activo, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4468 (class 0 OID 19597)
-- Dependencies: 293
-- Data for Name: pedido_detalle; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.pedido_detalle (id, pedido_id, receta_id, cantidad, precio_unitario, subtotal, notas, restaurante_id) FROM stdin;
1	1	4	1	5.00	5.00	\N	1
2	1	2	1	9.50	9.50	\N	1
3	2	4	1	5.00	5.00	\N	1
4	2	2	1	9.50	9.50	\N	1
5	2	3	1	3.00	3.00	\N	1
6	2	1	1	6.50	6.50	\N	1
7	3	4	1	5.00	5.00	\N	1
8	3	2	1	9.50	9.50	\N	1
9	3	3	1	3.00	3.00	\N	1
10	3	1	1	6.50	6.50	\N	1
11	4	4	2	5.00	10.00	\N	1
12	4	3	4	3.00	12.00	\N	1
13	4	1	4	6.50	26.00	\N	1
14	4	2	2	9.50	19.00	\N	1
15	5	4	3	5.00	15.00	\N	1
16	5	2	2	9.50	19.00	\N	1
17	5	3	4	3.00	12.00	\N	1
18	5	1	4	6.50	26.00	\N	1
22	13	1	1	6.50	6.50	\N	1
23	14	2	1	9.50	9.50	\N	1
24	15	2	1	9.50	9.50	\N	1
25	16	4	1	5.00	5.00	Socket Test	1
26	17	4	1	5.00	5.00	Real-Time Validation	1
27	18	1	4	6.50	26.00	\N	1
28	19	3	3	3.00	9.00	\N	1
29	20	1	1	6.50	6.50	\N	1
30	20	2	1	9.50	9.50	\N	1
31	20	3	2	3.00	6.00	\N	1
32	21	1	1	6.50	6.50	\N	1
33	21	2	1	9.50	9.50	\N	1
34	21	3	3	3.00	9.00	\N	1
35	22	2	1	9.50	9.50	\N	1
36	23	1	1	6.50	6.50	\N	1
37	23	3	1	3.00	3.00	\N	1
38	24	1	1	6.50	6.50	\N	1
39	25	2	1	9.50	9.50	\N	1
40	25	3	1	3.00	3.00	\N	1
41	28	1	1	6.50	6.50	\N	1
42	29	1	1	6.50	6.50	\N	1
43	29	2	1	9.50	9.50	\N	1
44	29	3	1	3.00	3.00	\N	1
45	29	4	1	5.00	5.00	\N	1
46	30	1	1	6.50	6.50	\N	1
47	31	2	1	9.50	9.50	\N	1
48	31	3	1	3.00	3.00	\N	1
49	32	2	1	9.50	9.50	\N	1
50	33	1	1	6.50	6.50	\N	1
51	34	2	2	9.50	19.00	\N	1
52	34	4	1	5.00	5.00	\N	1
53	34	3	2	3.00	6.00	\N	1
54	35	2	2	9.50	19.00	\N	1
55	35	4	1	5.00	5.00	\N	1
56	35	3	2	3.00	6.00	\N	1
57	36	3	1	3.00	3.00	\N	1
58	37	1	2	6.50	13.00	\N	1
59	37	3	2	3.00	6.00	\N	1
60	38	3	2	3.00	6.00	\N	1
61	38	2	2	9.50	19.00	\N	1
62	39	3	2	3.00	6.00	\N	1
63	39	4	2	5.00	10.00	\N	1
64	40	11	2	34.00	68.00	\N	1
65	42	12	2	1.50	3.00	\N	13
\.


--
-- TOC entry 4470 (class 0 OID 19610)
-- Dependencies: 295
-- Data for Name: pedidos; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.pedidos (id, codigo, mesa_id, mesero_id, cliente, estado, estado_cuenta, fecha_hora, subtotal, descuento, impuestos, total, restaurante_id, created_at, updated_at) FROM stdin;
37	PED-20260503-0001	9	\N	cliente super elegante	entregado	pagada	2026-05-02 21:30:19.834172	19.00	0.00	1.90	20.90	1	2026-05-02 21:30:19.834172	2026-05-02 21:32:54.147476
38	PED-20260519-0001	9	\N	pedrito	entregado	pagada	2026-05-18 20:17:29.073295	25.00	0.00	2.50	27.50	1	2026-05-18 20:17:29.073295	2026-05-18 20:20:33.180477
39	PED-20260519-0002	9	\N	pedrito	entregado	pagada	2026-05-18 20:21:38.741418	16.00	0.00	1.60	17.60	1	2026-05-18 20:21:38.741418	2026-05-18 20:22:16.733027
40	PED-20260519-0003	9	\N	\N	entregado	pagada	2026-05-18 23:25:18.457076	68.00	0.00	6.80	74.80	1	2026-05-18 23:25:18.457076	2026-05-18 23:26:18.870635
42	R13-PED-20260519-0001	12	\N	\N	entregado	pagada	2026-05-19 00:09:16.198163	3.00	0.00	0.30	3.30	13	2026-05-19 00:09:16.198163	2026-05-19 00:15:38.112276
15	PED-20260404-0003	\N	\N	\N	listo	pagada	2026-04-04 00:16:00.581704	9.50	0.00	0.95	10.45	1	2026-04-04 00:16:00.581704	2026-04-16 22:02:26.574258
13	PED-20260404-0001	\N	\N	\N	listo	pagada	2026-04-04 00:02:27.408462	6.50	0.00	0.65	7.15	1	2026-04-04 00:02:27.408462	2026-04-16 22:02:28.849279
14	PED-20260404-0002	\N	\N	\N	listo	pagada	2026-04-04 00:12:52.31896	9.50	0.00	0.95	10.45	1	2026-04-04 00:12:52.31896	2026-04-16 22:02:29.003262
18	PED-20260404-0006	\N	\N	\N	listo	pagada	2026-04-04 00:33:29.339811	26.00	0.00	2.60	28.60	1	2026-04-04 00:33:29.339811	2026-04-16 22:02:29.330142
22	PED-20260417-0001	\N	\N	\N	listo	pagada	2026-04-16 20:36:02.623098	9.50	0.00	0.95	10.45	1	2026-04-16 20:36:02.623098	2026-04-16 22:02:31.249229
24	PED-20260417-0003	\N	\N	\N	listo	pagada	2026-04-16 21:40:42.656259	6.50	0.00	0.65	7.15	1	2026-04-16 21:40:42.656259	2026-04-16 22:02:32.40598
16	PED-20260404-0004	\N	\N	\N	listo	pagada	2026-04-04 00:19:26.132213	5.00	0.00	0.50	5.50	1	2026-04-04 00:19:26.132213	2026-04-24 19:00:52.059544
17	PED-20260404-0005	\N	\N	\N	listo	pagada	2026-04-04 00:31:51.480405	5.00	0.00	0.50	5.50	1	2026-04-04 00:31:51.480405	2026-04-24 19:00:52.059544
20	PED-20260409-0001	\N	\N	\N	listo	pagada	2026-04-09 11:20:37.461517	22.00	0.00	2.20	24.20	1	2026-04-09 11:20:37.461517	2026-04-24 19:00:52.059544
21	PED-20260414-0001	\N	\N	\N	listo	pagada	2026-04-14 10:50:01.639167	25.00	0.00	2.50	27.50	1	2026-04-14 10:50:01.639167	2026-04-24 19:00:52.059544
23	PED-20260417-0002	\N	\N	rafael	listo	pagada	2026-04-16 21:12:05.38234	9.50	0.00	0.95	10.45	1	2026-04-16 21:12:05.38234	2026-04-24 19:00:52.059544
25	PED-20260417-0004	\N	\N	\N	listo	pagada	2026-04-16 22:03:07.028868	12.50	0.00	1.25	13.75	1	2026-04-16 22:03:07.028868	2026-04-24 19:00:52.059544
1	PED-20260324-0001	\N	\N	\N	entregado	pagada	2026-03-24 19:32:19.598162	14.50	0.00	1.45	15.95	1	2026-03-24 19:32:19.598162	2026-04-24 19:00:52.059544
2	PED-20260324-0002	\N	\N	\N	entregado	pagada	2026-03-24 19:37:56.254636	24.00	0.00	2.40	26.40	1	2026-03-24 19:37:56.254636	2026-04-24 19:00:52.059544
3	PED-20260324-0003	\N	\N	\N	entregado	pagada	2026-03-24 19:38:02.017175	24.00	0.00	2.40	26.40	1	2026-03-24 19:38:02.017175	2026-04-24 19:00:52.059544
5	PED-20260331-0001	\N	\N	\N	entregado	pagada	2026-03-31 16:13:25.688786	72.00	0.00	7.20	79.20	1	2026-03-31 16:13:25.688786	2026-04-24 19:00:52.059544
28	PED-20260419-0001	\N	\N	Prueba	entregado	pagada	2026-04-19 17:53:12.778435	6.50	0.00	0.65	7.15	1	2026-04-19 17:53:12.778435	2026-04-24 19:00:52.059544
29	PED-20260419-0002	\N	\N	\N	entregado	pagada	2026-04-19 17:57:52.097927	24.00	0.00	2.40	26.40	1	2026-04-19 17:57:52.097927	2026-04-24 19:00:52.059544
32	PED-20260424-0002	\N	\N	\N	entregado	pagada	2026-04-24 13:27:53.546246	9.50	0.00	0.95	10.45	1	2026-04-24 13:27:53.546246	2026-04-24 19:00:52.059544
34	PED-20260424-0004	\N	\N	Gregorio Valles	entregado	pagada	2026-04-24 18:46:19.830914	30.00	0.00	3.00	33.00	1	2026-04-24 18:46:19.830914	2026-04-24 19:00:52.059544
35	PED-20260424-0005	\N	\N	Gregorio Valles	entregado	pagada	2026-04-24 18:47:40.808388	30.00	0.00	3.00	33.00	1	2026-04-24 18:47:40.808388	2026-04-24 19:00:52.059544
36	PED-20260424-0006	\N	\N	\N	anulado	abierta	2026-04-24 18:51:14.195529	3.00	0.00	0.30	3.30	1	2026-04-24 18:51:14.195529	2026-04-24 19:00:52.059544
30	PED-20260419-0003	\N	\N	\N	entregado	pagada	2026-04-19 18:01:07.081599	6.50	0.00	0.65	7.15	1	2026-04-19 18:01:07.081599	2026-04-24 19:00:55.200182
19	PED-20260404-0007	\N	\N	\N	listo	pagada	2026-04-04 00:33:51.007441	9.00	0.00	0.90	9.90	1	2026-04-04 00:33:51.007441	2026-04-24 19:00:57.469949
4	PED-20260324-0004	\N	\N	\N	entregado	pagada	2026-03-24 19:38:21.838216	67.00	0.00	6.70	73.70	1	2026-03-24 19:38:21.838216	2026-04-24 19:00:57.469949
31	PED-20260424-0001	\N	\N	\N	entregado	pagada	2026-04-23 21:04:55.616863	12.50	0.00	1.25	13.75	1	2026-04-23 21:04:55.616863	2026-04-24 19:01:00.636624
33	PED-20260424-0003	\N	\N	\N	entregado	pagada	2026-04-24 13:38:26.40887	6.50	0.00	0.65	7.15	1	2026-04-24 13:38:26.40887	2026-04-24 19:01:03.199696
\.


--
-- TOC entry 4472 (class 0 OID 19627)
-- Dependencies: 297
-- Data for Name: reservas; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.reservas (id, mesa_id, cliente_nombre, cliente_telefono, fecha_reserva, cantidad_personas, estado, notas, restaurante_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4474 (class 0 OID 19641)
-- Dependencies: 299
-- Data for Name: transacciones_pago; Type: TABLE DATA; Schema: operaciones; Owner: postgres
--

COPY operaciones.transacciones_pago (id, pedido_id, metodo, monto, referencia, tasa_cambio, usuario_id, restaurante_id, created_at) FROM stdin;
1	13	efectivo	100.00	\N	1.0000	\N	1	2026-04-04 00:02:27.408462
2	14	divisa	10.64	\N	1.0000	\N	1	2026-04-04 00:12:52.31896
3	15	divisa	10.64	\N	1.0000	\N	1	2026-04-04 00:16:00.581704
4	16	efectivo	100.00	\N	1.0000	\N	1	2026-04-04 00:19:26.132213
5	17	efectivo	100.00	\N	1.0000	\N	1	2026-04-04 00:31:51.480405
6	18	efectivo	29.12	\N	1.0000	\N	1	2026-04-04 00:33:29.339811
7	19	divisa	10.08	\N	1.0000	\N	1	2026-04-04 00:33:51.007441
8	20	divisa	24.64	\N	1.0000	\N	1	2026-04-09 11:20:37.461517
9	21	pago_movil	28.00	\N	1.0000	\N	1	2026-04-14 10:50:01.639167
10	22	divisa	10.64	\N	1.0000	\N	1	2026-04-16 20:36:02.623098
11	23	divisa	10.64	\N	1.0000	\N	1	2026-04-16 21:12:05.38234
12	24	divisa	7.28	\N	1.0000	\N	1	2026-04-16 21:40:42.656259
13	25	divisa	14.00	\N	1.0000	\N	1	2026-04-16 22:03:07.028868
14	1	divisa	15.95	\N	1.0000	1	1	2026-04-23 20:12:23.587429
15	2	divisa	26.40	\N	1.0000	1	1	2026-04-23 20:19:51.019828
16	3	divisa	26.40	\N	1.0000	1	1	2026-04-23 20:22:01.040533
17	4	divisa	73.70	\N	1.0000	1	1	2026-04-23 20:25:49.802483
18	5	divisa	79.20	79.2	1.0000	5	1	2026-04-23 20:58:07.398259
19	28	divisa	7.15	7.15	1.0000	5	1	2026-04-23 20:58:14.847819
20	29	divisa	26.40	26.4	1.0000	5	1	2026-04-23 20:58:19.894282
21	30	divisa	7.15	6.50	1.0000	5	1	2026-04-23 20:58:26.816428
22	31	pago_movil	13.75	1234	1.0000	5	1	2026-04-23 21:08:06.779955
23	32	pago_movil	10.45	13456	1.0000	5	1	2026-04-24 13:29:49.277638
24	33	divisa	7.15	\N	1.0000	5	1	2026-04-24 18:50:02.133111
25	34	divisa	33.00	\N	1.0000	5	1	2026-04-24 18:50:04.000746
26	35	divisa	33.00	\N	1.0000	5	1	2026-04-24 18:50:05.511531
27	37	efectivo	20.90	0102	1.0000	5	1	2026-05-02 21:32:54.147476
28	38	divisa	27.50	\N	1.0000	5	1	2026-05-18 20:20:33.180477
29	39	divisa	17.60	\N	1.0000	5	1	2026-05-18 20:22:16.733027
30	40	pago_movil	74.80	1234	1.0000	5	1	2026-05-18 23:26:18.870635
31	42	divisa	3.30	\N	1.0000	11	13	2026-05-19 00:15:38.112276
\.


--
-- TOC entry 4476 (class 0 OID 19657)
-- Dependencies: 302
-- Data for Name: banco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banco (id, nombre_banco, numero_cuenta, saldo_actual, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4478 (class 0 OID 19667)
-- Dependencies: 304
-- Data for Name: banco_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banco_movimientos (id, banco_id, fecha_hora, monto, concepto, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4480 (class 0 OID 19679)
-- Dependencies: 306
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja (id, fecha_apertura, fecha_cierre, monto_inicial, monto_final, usuario_apertura_id, usuario_cierre_id, observaciones, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4482 (class 0 OID 19690)
-- Dependencies: 308
-- Data for Name: caja_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja_movimientos (id, caja_id, fecha_hora, monto, concepto, referencia_id, metodo_pago_id, usuario_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4484 (class 0 OID 19702)
-- Dependencies: 310
-- Data for Name: categoria_egresos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_egresos (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4486 (class 0 OID 19709)
-- Dependencies: 312
-- Data for Name: compra_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compra_detalle (id, compra_id, ingrediente_id, cantidad, precio_unitario, unidad_compra_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4488 (class 0 OID 19720)
-- Dependencies: 314
-- Data for Name: compras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compras (id, fecha, total, descripcion, proveedor_id, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4490 (class 0 OID 19728)
-- Dependencies: 316
-- Data for Name: egresos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.egresos (id, fecha, monto, categoria_id, razon, descripcion, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4492 (class 0 OID 19740)
-- Dependencies: 318
-- Data for Name: facturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facturas (id, numero_factura, pedido_id, fecha, subtotal, impuestos, total, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4494 (class 0 OID 19752)
-- Dependencies: 320
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredientes (id, nombre, cantidad_disponible, cantidad_minima, unidad_id, costo_promedio, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4496 (class 0 OID 19763)
-- Dependencies: 322
-- Data for Name: mesas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mesas (id, numero, nombre, capacidad, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4498 (class 0 OID 19771)
-- Dependencies: 324
-- Data for Name: meseros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meseros (id, nombre, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4500 (class 0 OID 19779)
-- Dependencies: 326
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metodos_pago (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4502 (class 0 OID 19786)
-- Dependencies: 328
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity, unit_price, subtotal, notes, created_at) FROM stdin;
\.


--
-- TOC entry 4503 (class 0 OID 19798)
-- Dependencies: 329
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, restaurant_id, user_id, table_id, status, subtotal, tax_amount, total_amount, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4504 (class 0 OID 19815)
-- Dependencies: 330
-- Data for Name: pedido_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_detalle (id, pedido_id, receta_id, cantidad, precio_unitario, subtotal, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4506 (class 0 OID 19826)
-- Dependencies: 332
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (id, codigo, mesa_id, mesero_id, cliente, fecha_hora, total, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4508 (class 0 OID 19835)
-- Dependencies: 334
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedores (id, identificacion, nombre, telefono, email, direccion, restaurante_id, banco_nombre, banco_cuenta_numero, activo, observaciones, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4510 (class 0 OID 19848)
-- Dependencies: 336
-- Data for Name: receta_ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receta_ingredientes (id, receta_id, ingrediente_id, cantidad, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4512 (class 0 OID 19857)
-- Dependencies: 338
-- Data for Name: recetas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recetas (id, nombre, descripcion, costo_produccion, precio_sugerido, precio_venta, margen_utilidad, activo, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4514 (class 0 OID 19871)
-- Dependencies: 340
-- Data for Name: restaurante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurante (id, nombre, patrimonio_inicial, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4516 (class 0 OID 19880)
-- Dependencies: 342
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4518 (class 0 OID 19887)
-- Dependencies: 344
-- Data for Name: unidad_compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_compra (id, nombre, restaurante_id) FROM stdin;
\.


--
-- TOC entry 4520 (class 0 OID 19894)
-- Dependencies: 346
-- Data for Name: unidad_medida; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_medida (id, nombre, abreviatura) FROM stdin;
\.


--
-- TOC entry 4522 (class 0 OID 19901)
-- Dependencies: 348
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, restaurante_id, rol_id, nombre, email, username, activo) FROM stdin;
\.


--
-- TOC entry 4524 (class 0 OID 19912)
-- Dependencies: 350
-- Data for Name: order_items; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.order_items (id, order_id, product_id, quantity, unit_price, subtotal, notes, created_at) FROM stdin;
\.


--
-- TOC entry 4525 (class 0 OID 19921)
-- Dependencies: 351
-- Data for Name: orders; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.orders (id, restaurant_id, user_id, table_id, status, subtotal, tax_amount, total_amount, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4625 (class 0 OID 0)
-- Dependencies: 229
-- Name: asiento_lineas_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.asiento_lineas_id_seq', 20, true);


--
-- TOC entry 4626 (class 0 OID 0)
-- Dependencies: 231
-- Name: asientos_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.asientos_id_seq', 10, true);


--
-- TOC entry 4627 (class 0 OID 0)
-- Dependencies: 233
-- Name: libro_diario_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.libro_diario_id_seq', 150, true);


--
-- TOC entry 4628 (class 0 OID 0)
-- Dependencies: 235
-- Name: plan_cuentas_id_seq; Type: SEQUENCE SET; Schema: contabilidad; Owner: postgres
--

SELECT pg_catalog.setval('contabilidad.plan_cuentas_id_seq', 22, true);


--
-- TOC entry 4629 (class 0 OID 0)
-- Dependencies: 240
-- Name: metodos_pago_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.metodos_pago_id_seq', 4, true);


--
-- TOC entry 4630 (class 0 OID 0)
-- Dependencies: 241
-- Name: restaurante_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.restaurante_id_seq', 13, true);


--
-- TOC entry 4631 (class 0 OID 0)
-- Dependencies: 243
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.roles_id_seq', 5, true);


--
-- TOC entry 4632 (class 0 OID 0)
-- Dependencies: 245
-- Name: tables_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.tables_id_seq', 10, true);


--
-- TOC entry 4633 (class 0 OID 0)
-- Dependencies: 247
-- Name: unidad_medida_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.unidad_medida_id_seq', 5, true);


--
-- TOC entry 4634 (class 0 OID 0)
-- Dependencies: 249
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: core; Owner: postgres
--

SELECT pg_catalog.setval('core.usuarios_id_seq', 11, true);


--
-- TOC entry 4635 (class 0 OID 0)
-- Dependencies: 251
-- Name: banco_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.banco_id_seq', 1, false);


--
-- TOC entry 4636 (class 0 OID 0)
-- Dependencies: 253
-- Name: banco_movimientos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.banco_movimientos_id_seq', 1, false);


--
-- TOC entry 4637 (class 0 OID 0)
-- Dependencies: 255
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.caja_id_seq', 1, false);


--
-- TOC entry 4638 (class 0 OID 0)
-- Dependencies: 257
-- Name: caja_movimientos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.caja_movimientos_id_seq', 1, false);


--
-- TOC entry 4639 (class 0 OID 0)
-- Dependencies: 259
-- Name: egresos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.egresos_id_seq', 1, false);


--
-- TOC entry 4640 (class 0 OID 0)
-- Dependencies: 261
-- Name: gastos_operativos_id_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.gastos_operativos_id_seq', 8, true);


--
-- TOC entry 4641 (class 0 OID 0)
-- Dependencies: 263
-- Name: categoria_egresos_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.categoria_egresos_id_seq', 1, false);


--
-- TOC entry 4642 (class 0 OID 0)
-- Dependencies: 265
-- Name: compra_detalle_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.compra_detalle_id_seq', 15, true);


--
-- TOC entry 4643 (class 0 OID 0)
-- Dependencies: 267
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.compras_id_seq', 13, true);


--
-- TOC entry 4644 (class 0 OID 0)
-- Dependencies: 269
-- Name: ingredientes_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.ingredientes_id_seq', 28, true);


--
-- TOC entry 4645 (class 0 OID 0)
-- Dependencies: 271
-- Name: mermas_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.mermas_id_seq', 1, false);


--
-- TOC entry 4646 (class 0 OID 0)
-- Dependencies: 273
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.proveedores_id_seq', 7, true);


--
-- TOC entry 4647 (class 0 OID 0)
-- Dependencies: 275
-- Name: unidad_compra_id_seq; Type: SEQUENCE SET; Schema: inventario; Owner: postgres
--

SELECT pg_catalog.setval('inventario.unidad_compra_id_seq', 27, true);


--
-- TOC entry 4648 (class 0 OID 0)
-- Dependencies: 277
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('inventory.categories_id_seq', 7, true);


--
-- TOC entry 4649 (class 0 OID 0)
-- Dependencies: 279
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('inventory.products_id_seq', 31, true);


--
-- TOC entry 4650 (class 0 OID 0)
-- Dependencies: 281
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.categorias_id_seq', 6, true);


--
-- TOC entry 4651 (class 0 OID 0)
-- Dependencies: 283
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.receta_ingredientes_id_seq', 39, true);


--
-- TOC entry 4652 (class 0 OID 0)
-- Dependencies: 285
-- Name: recetas_id_seq; Type: SEQUENCE SET; Schema: menu; Owner: postgres
--

SELECT pg_catalog.setval('menu.recetas_id_seq', 12, true);


--
-- TOC entry 4653 (class 0 OID 0)
-- Dependencies: 288
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.facturas_id_seq', 1, false);


--
-- TOC entry 4654 (class 0 OID 0)
-- Dependencies: 290
-- Name: mesas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.mesas_id_seq', 12, true);


--
-- TOC entry 4655 (class 0 OID 0)
-- Dependencies: 292
-- Name: meseros_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.meseros_id_seq', 1, false);


--
-- TOC entry 4656 (class 0 OID 0)
-- Dependencies: 294
-- Name: pedido_detalle_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.pedido_detalle_id_seq', 65, true);


--
-- TOC entry 4657 (class 0 OID 0)
-- Dependencies: 296
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.pedidos_id_seq', 42, true);


--
-- TOC entry 4658 (class 0 OID 0)
-- Dependencies: 298
-- Name: reservas_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.reservas_id_seq', 1, false);


--
-- TOC entry 4659 (class 0 OID 0)
-- Dependencies: 300
-- Name: transacciones_pago_id_seq; Type: SEQUENCE SET; Schema: operaciones; Owner: postgres
--

SELECT pg_catalog.setval('operaciones.transacciones_pago_id_seq', 31, true);


--
-- TOC entry 4660 (class 0 OID 0)
-- Dependencies: 303
-- Name: banco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banco_id_seq', 1, false);


--
-- TOC entry 4661 (class 0 OID 0)
-- Dependencies: 305
-- Name: banco_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banco_movimientos_id_seq', 1, false);


--
-- TOC entry 4662 (class 0 OID 0)
-- Dependencies: 307
-- Name: caja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_id_seq', 1, false);


--
-- TOC entry 4663 (class 0 OID 0)
-- Dependencies: 309
-- Name: caja_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_movimientos_id_seq', 1, false);


--
-- TOC entry 4664 (class 0 OID 0)
-- Dependencies: 311
-- Name: categoria_egresos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_egresos_id_seq', 1, false);


--
-- TOC entry 4665 (class 0 OID 0)
-- Dependencies: 313
-- Name: compra_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compra_detalle_id_seq', 1, false);


--
-- TOC entry 4666 (class 0 OID 0)
-- Dependencies: 315
-- Name: compras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compras_id_seq', 1, false);


--
-- TOC entry 4667 (class 0 OID 0)
-- Dependencies: 317
-- Name: egresos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.egresos_id_seq', 1, false);


--
-- TOC entry 4668 (class 0 OID 0)
-- Dependencies: 319
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facturas_id_seq', 1, false);


--
-- TOC entry 4669 (class 0 OID 0)
-- Dependencies: 321
-- Name: ingredientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredientes_id_seq', 1, false);


--
-- TOC entry 4670 (class 0 OID 0)
-- Dependencies: 323
-- Name: mesas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mesas_id_seq', 1, false);


--
-- TOC entry 4671 (class 0 OID 0)
-- Dependencies: 325
-- Name: meseros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meseros_id_seq', 1, false);


--
-- TOC entry 4672 (class 0 OID 0)
-- Dependencies: 327
-- Name: metodos_pago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metodos_pago_id_seq', 1, false);


--
-- TOC entry 4673 (class 0 OID 0)
-- Dependencies: 331
-- Name: pedido_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_detalle_id_seq', 1, false);


--
-- TOC entry 4674 (class 0 OID 0)
-- Dependencies: 333
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 1, false);


--
-- TOC entry 4675 (class 0 OID 0)
-- Dependencies: 335
-- Name: proveedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedores_id_seq', 1, false);


--
-- TOC entry 4676 (class 0 OID 0)
-- Dependencies: 337
-- Name: receta_ingredientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receta_ingredientes_id_seq', 1, false);


--
-- TOC entry 4677 (class 0 OID 0)
-- Dependencies: 339
-- Name: recetas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recetas_id_seq', 1, false);


--
-- TOC entry 4678 (class 0 OID 0)
-- Dependencies: 341
-- Name: restaurante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restaurante_id_seq', 1, false);


--
-- TOC entry 4679 (class 0 OID 0)
-- Dependencies: 343
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- TOC entry 4680 (class 0 OID 0)
-- Dependencies: 345
-- Name: unidad_compra_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_compra_id_seq', 1, false);


--
-- TOC entry 4681 (class 0 OID 0)
-- Dependencies: 347
-- Name: unidad_medida_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_medida_id_seq', 1, false);


--
-- TOC entry 4682 (class 0 OID 0)
-- Dependencies: 349
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, false);


--
-- TOC entry 3906 (class 2606 OID 19994)
-- Name: asiento_lineas asiento_lineas_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas
    ADD CONSTRAINT asiento_lineas_pkey PRIMARY KEY (id);


--
-- TOC entry 3910 (class 2606 OID 19996)
-- Name: asientos asientos_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos
    ADD CONSTRAINT asientos_pkey PRIMARY KEY (id);


--
-- TOC entry 3917 (class 2606 OID 19998)
-- Name: libro_diario libro_diario_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario
    ADD CONSTRAINT libro_diario_pkey PRIMARY KEY (id);


--
-- TOC entry 3920 (class 2606 OID 20000)
-- Name: plan_cuentas plan_cuentas_codigo_restaurante_unique; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_codigo_restaurante_unique UNIQUE (codigo, restaurante_id);


--
-- TOC entry 3922 (class 2606 OID 20002)
-- Name: plan_cuentas plan_cuentas_pkey; Type: CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT plan_cuentas_pkey PRIMARY KEY (id);


--
-- TOC entry 3926 (class 2606 OID 20004)
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 3924 (class 2606 OID 20006)
-- Name: restaurante restaurante_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.restaurante
    ADD CONSTRAINT restaurante_pkey PRIMARY KEY (id);


--
-- TOC entry 3928 (class 2606 OID 20008)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3930 (class 2606 OID 20010)
-- Name: tables tables_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- TOC entry 3932 (class 2606 OID 20012)
-- Name: unidad_medida unidad_medida_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.unidad_medida
    ADD CONSTRAINT unidad_medida_pkey PRIMARY KEY (id);


--
-- TOC entry 3934 (class 2606 OID 20014)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 3936 (class 2606 OID 20016)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 3941 (class 2606 OID 20018)
-- Name: banco_movimientos banco_movimientos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT banco_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 3938 (class 2606 OID 20020)
-- Name: banco banco_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco
    ADD CONSTRAINT banco_pkey PRIMARY KEY (id);


--
-- TOC entry 3950 (class 2606 OID 20022)
-- Name: caja_movimientos caja_movimientos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT caja_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 3946 (class 2606 OID 20024)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 3955 (class 2606 OID 20026)
-- Name: egresos egresos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 3959 (class 2606 OID 20028)
-- Name: gastos_operativos gastos_operativos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.gastos_operativos
    ADD CONSTRAINT gastos_operativos_pkey PRIMARY KEY (id);


--
-- TOC entry 3963 (class 2606 OID 20030)
-- Name: categoria_egresos categoria_egresos_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos
    ADD CONSTRAINT categoria_egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 3965 (class 2606 OID 20032)
-- Name: compra_detalle compra_detalle_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT compra_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 3969 (class 2606 OID 20034)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- TOC entry 3976 (class 2606 OID 20036)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3980 (class 2606 OID 20038)
-- Name: mermas mermas_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT mermas_pkey PRIMARY KEY (id);


--
-- TOC entry 3984 (class 2606 OID 20040)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 3986 (class 2606 OID 20042)
-- Name: unidad_compra unidad_compra_pkey; Type: CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra
    ADD CONSTRAINT unidad_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 3988 (class 2606 OID 20044)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3990 (class 2606 OID 20046)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3992 (class 2606 OID 20048)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- TOC entry 3997 (class 2606 OID 20050)
-- Name: receta_ingredientes receta_ingredientes_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 3999 (class 2606 OID 20052)
-- Name: receta_ingredientes receta_ingredientes_receta_id_ingrediente_id_key; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_receta_id_ingrediente_id_key UNIQUE (receta_id, ingrediente_id);


--
-- TOC entry 4004 (class 2606 OID 20054)
-- Name: recetas recetas_pkey; Type: CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT recetas_pkey PRIMARY KEY (id);


--
-- TOC entry 4006 (class 2606 OID 20056)
-- Name: facturas facturas_numero_factura_key; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT facturas_numero_factura_key UNIQUE (numero_factura);


--
-- TOC entry 4008 (class 2606 OID 20058)
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- TOC entry 4015 (class 2606 OID 20060)
-- Name: mesas mesas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (id);


--
-- TOC entry 4018 (class 2606 OID 20062)
-- Name: meseros meseros_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros
    ADD CONSTRAINT meseros_pkey PRIMARY KEY (id);


--
-- TOC entry 4022 (class 2606 OID 20064)
-- Name: pedido_detalle pedido_detalle_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT pedido_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4029 (class 2606 OID 20928)
-- Name: pedidos pedidos_codigo_key; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT pedidos_codigo_key UNIQUE (codigo);


--
-- TOC entry 4031 (class 2606 OID 20068)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 4035 (class 2606 OID 20070)
-- Name: reservas reservas_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT reservas_pkey PRIMARY KEY (id);


--
-- TOC entry 4039 (class 2606 OID 20072)
-- Name: transacciones_pago transacciones_pago_pkey; Type: CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.transacciones_pago
    ADD CONSTRAINT transacciones_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 4088 (class 2606 OID 20074)
-- Name: order_items PK_005269d8574e6fac0493715c308; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "PK_005269d8574e6fac0493715c308" PRIMARY KEY (id);


--
-- TOC entry 4090 (class 2606 OID 20076)
-- Name: orders PK_710e2d4957aa5878dfe94e4ac2f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "PK_710e2d4957aa5878dfe94e4ac2f" PRIMARY KEY (id);


--
-- TOC entry 4044 (class 2606 OID 20078)
-- Name: banco_movimientos banco_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT banco_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 4041 (class 2606 OID 20080)
-- Name: banco banco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco
    ADD CONSTRAINT banco_pkey PRIMARY KEY (id);


--
-- TOC entry 4051 (class 2606 OID 20082)
-- Name: caja_movimientos caja_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT caja_movimientos_pkey PRIMARY KEY (id);


--
-- TOC entry 4048 (class 2606 OID 20084)
-- Name: caja caja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id);


--
-- TOC entry 4055 (class 2606 OID 20086)
-- Name: categoria_egresos categoria_egresos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos
    ADD CONSTRAINT categoria_egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 4057 (class 2606 OID 20088)
-- Name: compra_detalle compra_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT compra_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4061 (class 2606 OID 20090)
-- Name: compras compras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);


--
-- TOC entry 4066 (class 2606 OID 20092)
-- Name: egresos egresos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT egresos_pkey PRIMARY KEY (id);


--
-- TOC entry 4070 (class 2606 OID 20094)
-- Name: facturas facturas_numero_factura_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_numero_factura_key UNIQUE (numero_factura);


--
-- TOC entry 4072 (class 2606 OID 20096)
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- TOC entry 4078 (class 2606 OID 20098)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4081 (class 2606 OID 20100)
-- Name: mesas mesas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (id);


--
-- TOC entry 4084 (class 2606 OID 20102)
-- Name: meseros meseros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros
    ADD CONSTRAINT meseros_pkey PRIMARY KEY (id);


--
-- TOC entry 4086 (class 2606 OID 20104)
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id);


--
-- TOC entry 4094 (class 2606 OID 20106)
-- Name: pedido_detalle pedido_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT pedido_detalle_pkey PRIMARY KEY (id);


--
-- TOC entry 4098 (class 2606 OID 20108)
-- Name: pedidos pedidos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_codigo_key UNIQUE (codigo);


--
-- TOC entry 4100 (class 2606 OID 20110)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- TOC entry 4104 (class 2606 OID 20112)
-- Name: proveedores proveedores_identificacion_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_identificacion_key UNIQUE (identificacion);


--
-- TOC entry 4106 (class 2606 OID 20114)
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id);


--
-- TOC entry 4110 (class 2606 OID 20116)
-- Name: receta_ingredientes receta_ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4112 (class 2606 OID 20118)
-- Name: receta_ingredientes receta_ingredientes_receta_id_ingrediente_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT receta_ingredientes_receta_id_ingrediente_id_key UNIQUE (receta_id, ingrediente_id);


--
-- TOC entry 4116 (class 2606 OID 20120)
-- Name: recetas recetas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_pkey PRIMARY KEY (id);


--
-- TOC entry 4118 (class 2606 OID 20122)
-- Name: restaurante restaurante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurante
    ADD CONSTRAINT restaurante_pkey PRIMARY KEY (id);


--
-- TOC entry 4120 (class 2606 OID 20124)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4122 (class 2606 OID 20126)
-- Name: unidad_compra unidad_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra
    ADD CONSTRAINT unidad_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 4124 (class 2606 OID 20128)
-- Name: unidad_medida unidad_medida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida
    ADD CONSTRAINT unidad_medida_pkey PRIMARY KEY (id);


--
-- TOC entry 4128 (class 2606 OID 20130)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4130 (class 2606 OID 20132)
-- Name: usuarios usuarios_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_username_key UNIQUE (username);


--
-- TOC entry 4132 (class 2606 OID 20134)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4134 (class 2606 OID 20136)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3907 (class 1259 OID 20137)
-- Name: idx_asiento_lineas_asiento; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_asiento_lineas_asiento ON contabilidad.asiento_lineas USING btree (asiento_id);


--
-- TOC entry 3908 (class 1259 OID 20138)
-- Name: idx_asiento_lineas_cuenta; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_asiento_lineas_cuenta ON contabilidad.asiento_lineas USING btree (cuenta_id, restaurante_id);


--
-- TOC entry 3911 (class 1259 OID 20139)
-- Name: idx_asientos_fecha; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_asientos_fecha ON contabilidad.asientos USING btree (fecha, restaurante_id);


--
-- TOC entry 3912 (class 1259 OID 20140)
-- Name: idx_asientos_origen; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_asientos_origen ON contabilidad.asientos USING btree (origen_tipo, origen_id);


--
-- TOC entry 3913 (class 1259 OID 20141)
-- Name: idx_libro_fecha; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_fecha ON contabilidad.libro_diario USING btree (fecha);


--
-- TOC entry 3914 (class 1259 OID 20142)
-- Name: idx_libro_referencia; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_referencia ON contabilidad.libro_diario USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 3915 (class 1259 OID 20143)
-- Name: idx_libro_tipo; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_libro_tipo ON contabilidad.libro_diario USING btree (tipo);


--
-- TOC entry 3918 (class 1259 OID 20144)
-- Name: idx_plan_cuentas_tipo; Type: INDEX; Schema: contabilidad; Owner: postgres
--

CREATE INDEX idx_plan_cuentas_tipo ON contabilidad.plan_cuentas USING btree (tipo);


--
-- TOC entry 3939 (class 1259 OID 20145)
-- Name: idx_banco_activo; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_activo ON finanzas.banco USING btree (activo);


--
-- TOC entry 3942 (class 1259 OID 20146)
-- Name: idx_banco_mov_banco; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_banco ON finanzas.banco_movimientos USING btree (banco_id);


--
-- TOC entry 3943 (class 1259 OID 20147)
-- Name: idx_banco_mov_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_fecha ON finanzas.banco_movimientos USING btree (fecha_hora);


--
-- TOC entry 3944 (class 1259 OID 20148)
-- Name: idx_banco_mov_referencia; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_banco_mov_referencia ON finanzas.banco_movimientos USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 3947 (class 1259 OID 20149)
-- Name: idx_caja_estado; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_estado ON finanzas.caja USING btree (estado);


--
-- TOC entry 3948 (class 1259 OID 20150)
-- Name: idx_caja_fechas; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_fechas ON finanzas.caja USING btree (fecha_apertura, fecha_cierre);


--
-- TOC entry 3951 (class 1259 OID 20151)
-- Name: idx_caja_mov_caja; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_caja ON finanzas.caja_movimientos USING btree (caja_id);


--
-- TOC entry 3952 (class 1259 OID 20152)
-- Name: idx_caja_mov_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_fecha ON finanzas.caja_movimientos USING btree (fecha_hora);


--
-- TOC entry 3953 (class 1259 OID 20153)
-- Name: idx_caja_mov_referencia; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_caja_mov_referencia ON finanzas.caja_movimientos USING btree (referencia_tipo, referencia_id);


--
-- TOC entry 3956 (class 1259 OID 20154)
-- Name: idx_egresos_categoria; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_egresos_categoria ON finanzas.egresos USING btree (categoria_id);


--
-- TOC entry 3957 (class 1259 OID 20155)
-- Name: idx_egresos_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_egresos_fecha ON finanzas.egresos USING btree (fecha);


--
-- TOC entry 3960 (class 1259 OID 20156)
-- Name: idx_gastos_categoria; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_gastos_categoria ON finanzas.gastos_operativos USING btree (categoria, restaurante_id);


--
-- TOC entry 3961 (class 1259 OID 20157)
-- Name: idx_gastos_restaurante_fecha; Type: INDEX; Schema: finanzas; Owner: postgres
--

CREATE INDEX idx_gastos_restaurante_fecha ON finanzas.gastos_operativos USING btree (restaurante_id, fecha);


--
-- TOC entry 3966 (class 1259 OID 20158)
-- Name: idx_compra_detalle_compra; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compra_detalle_compra ON inventario.compra_detalle USING btree (compra_id);


--
-- TOC entry 3967 (class 1259 OID 20159)
-- Name: idx_compra_detalle_ingrediente; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compra_detalle_ingrediente ON inventario.compra_detalle USING btree (ingrediente_id);


--
-- TOC entry 3970 (class 1259 OID 20160)
-- Name: idx_compras_fecha; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compras_fecha ON inventario.compras USING btree (fecha);


--
-- TOC entry 3971 (class 1259 OID 20161)
-- Name: idx_compras_proveedor; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_compras_proveedor ON inventario.compras USING btree (proveedor_id);


--
-- TOC entry 3972 (class 1259 OID 20162)
-- Name: idx_ingredientes_nombre; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_nombre ON inventario.ingredientes USING btree (nombre);


--
-- TOC entry 3973 (class 1259 OID 20163)
-- Name: idx_ingredientes_restaurante; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_restaurante ON inventario.ingredientes USING btree (restaurante_id);


--
-- TOC entry 3974 (class 1259 OID 20164)
-- Name: idx_ingredientes_stock; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_ingredientes_stock ON inventario.ingredientes USING btree (cantidad_disponible, cantidad_minima);


--
-- TOC entry 3977 (class 1259 OID 20165)
-- Name: idx_mermas_fecha; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_mermas_fecha ON inventario.mermas USING btree (created_at);


--
-- TOC entry 3978 (class 1259 OID 20166)
-- Name: idx_mermas_ingrediente; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_mermas_ingrediente ON inventario.mermas USING btree (ingrediente_id);


--
-- TOC entry 3981 (class 1259 OID 20167)
-- Name: idx_proveedores_nombre; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_proveedores_nombre ON inventario.proveedores USING btree (nombre);


--
-- TOC entry 3982 (class 1259 OID 20168)
-- Name: idx_proveedores_restaurante; Type: INDEX; Schema: inventario; Owner: postgres
--

CREATE INDEX idx_proveedores_restaurante ON inventario.proveedores USING btree (restaurante_id, nombre);


--
-- TOC entry 3993 (class 1259 OID 20169)
-- Name: idx_categorias_restaurante; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_categorias_restaurante ON menu.categorias USING btree (restaurante_id, orden);


--
-- TOC entry 3994 (class 1259 OID 20170)
-- Name: idx_receta_ingredientes_ingrediente; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_ingrediente ON menu.receta_ingredientes USING btree (ingrediente_id);


--
-- TOC entry 3995 (class 1259 OID 20171)
-- Name: idx_receta_ingredientes_receta; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_receta ON menu.receta_ingredientes USING btree (receta_id);


--
-- TOC entry 4000 (class 1259 OID 20172)
-- Name: idx_recetas_activo; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_activo ON menu.recetas USING btree (activo);


--
-- TOC entry 4001 (class 1259 OID 20173)
-- Name: idx_recetas_categoria; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_categoria ON menu.recetas USING btree (categoria_id);


--
-- TOC entry 4002 (class 1259 OID 20174)
-- Name: idx_recetas_nombre; Type: INDEX; Schema: menu; Owner: postgres
--

CREATE INDEX idx_recetas_nombre ON menu.recetas USING btree (nombre);


--
-- TOC entry 4009 (class 1259 OID 20175)
-- Name: idx_facturas_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_fecha ON operaciones.facturas USING btree (fecha);


--
-- TOC entry 4010 (class 1259 OID 20176)
-- Name: idx_facturas_fecha_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_fecha_estado ON operaciones.facturas USING btree (fecha, estado);


--
-- TOC entry 4011 (class 1259 OID 20177)
-- Name: idx_facturas_numero; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_facturas_numero ON operaciones.facturas USING btree (numero_factura);


--
-- TOC entry 4012 (class 1259 OID 20178)
-- Name: idx_mesas_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_mesas_estado ON operaciones.mesas USING btree (estado);


--
-- TOC entry 4013 (class 1259 OID 20179)
-- Name: idx_mesas_numero; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_mesas_numero ON operaciones.mesas USING btree (numero);


--
-- TOC entry 4016 (class 1259 OID 20180)
-- Name: idx_meseros_nombre; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_meseros_nombre ON operaciones.meseros USING btree (nombre);


--
-- TOC entry 4019 (class 1259 OID 20181)
-- Name: idx_pedido_detalle_pedido; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_pedido ON operaciones.pedido_detalle USING btree (pedido_id);


--
-- TOC entry 4020 (class 1259 OID 20182)
-- Name: idx_pedido_detalle_receta; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_receta ON operaciones.pedido_detalle USING btree (receta_id);


--
-- TOC entry 4023 (class 1259 OID 20929)
-- Name: idx_pedidos_codigo; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_codigo ON operaciones.pedidos USING btree (codigo);


--
-- TOC entry 4024 (class 1259 OID 20184)
-- Name: idx_pedidos_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_estado ON operaciones.pedidos USING btree (estado);


--
-- TOC entry 4025 (class 1259 OID 20185)
-- Name: idx_pedidos_estado_cuenta; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_estado_cuenta ON operaciones.pedidos USING btree (estado_cuenta);


--
-- TOC entry 4026 (class 1259 OID 20186)
-- Name: idx_pedidos_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha ON operaciones.pedidos USING btree (fecha_hora);


--
-- TOC entry 4027 (class 1259 OID 20187)
-- Name: idx_pedidos_fecha_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha_estado ON operaciones.pedidos USING btree (fecha_hora, estado);


--
-- TOC entry 4032 (class 1259 OID 20188)
-- Name: idx_reservas_estado; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_reservas_estado ON operaciones.reservas USING btree (estado);


--
-- TOC entry 4033 (class 1259 OID 20189)
-- Name: idx_reservas_fecha; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_reservas_fecha ON operaciones.reservas USING btree (fecha_reserva);


--
-- TOC entry 4036 (class 1259 OID 20190)
-- Name: idx_trans_pago_metodo; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_trans_pago_metodo ON operaciones.transacciones_pago USING btree (metodo, restaurante_id);


--
-- TOC entry 4037 (class 1259 OID 20191)
-- Name: idx_trans_pago_pedido; Type: INDEX; Schema: operaciones; Owner: postgres
--

CREATE INDEX idx_trans_pago_pedido ON operaciones.transacciones_pago USING btree (pedido_id);


--
-- TOC entry 4042 (class 1259 OID 20192)
-- Name: idx_banco_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_activo ON public.banco USING btree (activo);


--
-- TOC entry 4045 (class 1259 OID 20193)
-- Name: idx_banco_movimientos_banco; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_movimientos_banco ON public.banco_movimientos USING btree (banco_id);


--
-- TOC entry 4046 (class 1259 OID 20194)
-- Name: idx_banco_movimientos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_banco_movimientos_fecha ON public.banco_movimientos USING btree (fecha_hora);


--
-- TOC entry 4049 (class 1259 OID 20195)
-- Name: idx_caja_fechas; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_fechas ON public.caja USING btree (fecha_apertura, fecha_cierre);


--
-- TOC entry 4052 (class 1259 OID 20196)
-- Name: idx_caja_movimientos_caja; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_movimientos_caja ON public.caja_movimientos USING btree (caja_id);


--
-- TOC entry 4053 (class 1259 OID 20197)
-- Name: idx_caja_movimientos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_movimientos_fecha ON public.caja_movimientos USING btree (fecha_hora);


--
-- TOC entry 4058 (class 1259 OID 20198)
-- Name: idx_compra_detalle_compra; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compra_detalle_compra ON public.compra_detalle USING btree (compra_id);


--
-- TOC entry 4059 (class 1259 OID 20199)
-- Name: idx_compra_detalle_ingrediente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compra_detalle_ingrediente ON public.compra_detalle USING btree (ingrediente_id);


--
-- TOC entry 4062 (class 1259 OID 20200)
-- Name: idx_compras_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_fecha ON public.compras USING btree (fecha);


--
-- TOC entry 4063 (class 1259 OID 20201)
-- Name: idx_compras_fecha_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_fecha_proveedor ON public.compras USING btree (fecha, proveedor_id);


--
-- TOC entry 4064 (class 1259 OID 20202)
-- Name: idx_compras_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_compras_proveedor ON public.compras USING btree (proveedor_id);


--
-- TOC entry 4067 (class 1259 OID 20203)
-- Name: idx_egresos_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_egresos_categoria ON public.egresos USING btree (categoria_id);


--
-- TOC entry 4068 (class 1259 OID 20204)
-- Name: idx_egresos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_egresos_fecha ON public.egresos USING btree (fecha);


--
-- TOC entry 4073 (class 1259 OID 20205)
-- Name: idx_facturas_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_fecha ON public.facturas USING btree (fecha);


--
-- TOC entry 4074 (class 1259 OID 20206)
-- Name: idx_facturas_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_numero ON public.facturas USING btree (numero_factura);


--
-- TOC entry 4075 (class 1259 OID 20207)
-- Name: idx_ingredientes_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ingredientes_nombre ON public.ingredientes USING btree (nombre);


--
-- TOC entry 4076 (class 1259 OID 20208)
-- Name: idx_ingredientes_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ingredientes_stock ON public.ingredientes USING btree (cantidad_disponible, cantidad_minima);


--
-- TOC entry 4079 (class 1259 OID 20209)
-- Name: idx_mesas_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mesas_numero ON public.mesas USING btree (numero);


--
-- TOC entry 4082 (class 1259 OID 20210)
-- Name: idx_meseros_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_meseros_nombre ON public.meseros USING btree (nombre);


--
-- TOC entry 4091 (class 1259 OID 20211)
-- Name: idx_pedido_detalle_pedido; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_pedido ON public.pedido_detalle USING btree (pedido_id);


--
-- TOC entry 4092 (class 1259 OID 20212)
-- Name: idx_pedido_detalle_receta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedido_detalle_receta ON public.pedido_detalle USING btree (receta_id);


--
-- TOC entry 4095 (class 1259 OID 20213)
-- Name: idx_pedidos_codigo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_codigo ON public.pedidos USING btree (codigo);


--
-- TOC entry 4096 (class 1259 OID 20214)
-- Name: idx_pedidos_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pedidos_fecha ON public.pedidos USING btree (fecha_hora);


--
-- TOC entry 4101 (class 1259 OID 20215)
-- Name: idx_proveedores_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proveedores_nombre ON public.proveedores USING btree (nombre);


--
-- TOC entry 4102 (class 1259 OID 20216)
-- Name: idx_proveedores_restaurante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proveedores_restaurante ON public.proveedores USING btree (restaurante_id, nombre);


--
-- TOC entry 4107 (class 1259 OID 20217)
-- Name: idx_receta_ingredientes_ingrediente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_ingrediente ON public.receta_ingredientes USING btree (ingrediente_id);


--
-- TOC entry 4108 (class 1259 OID 20218)
-- Name: idx_receta_ingredientes_receta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receta_ingredientes_receta ON public.receta_ingredientes USING btree (receta_id);


--
-- TOC entry 4113 (class 1259 OID 20219)
-- Name: idx_recetas_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recetas_activo ON public.recetas USING btree (activo);


--
-- TOC entry 4114 (class 1259 OID 20220)
-- Name: idx_recetas_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_recetas_nombre ON public.recetas USING btree (nombre);


--
-- TOC entry 4125 (class 1259 OID 20221)
-- Name: idx_usuarios_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_email ON public.usuarios USING btree (email);


--
-- TOC entry 4126 (class 1259 OID 20222)
-- Name: idx_usuarios_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_username ON public.usuarios USING btree (username);


--
-- TOC entry 4243 (class 2620 OID 20223)
-- Name: restaurante trg_restaurante_updated; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_restaurante_updated BEFORE UPDATE ON core.restaurante FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4244 (class 2620 OID 20224)
-- Name: usuarios trg_usuarios_updated; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_usuarios_updated BEFORE UPDATE ON core.usuarios FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4245 (class 2620 OID 20225)
-- Name: banco trg_banco_updated; Type: TRIGGER; Schema: finanzas; Owner: postgres
--

CREATE TRIGGER trg_banco_updated BEFORE UPDATE ON finanzas.banco FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4246 (class 2620 OID 20226)
-- Name: ingredientes trg_ingredientes_updated; Type: TRIGGER; Schema: inventario; Owner: postgres
--

CREATE TRIGGER trg_ingredientes_updated BEFORE UPDATE ON inventario.ingredientes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4247 (class 2620 OID 20227)
-- Name: proveedores trg_proveedores_updated; Type: TRIGGER; Schema: inventario; Owner: postgres
--

CREATE TRIGGER trg_proveedores_updated BEFORE UPDATE ON inventario.proveedores FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4248 (class 2620 OID 20228)
-- Name: categorias trg_categorias_updated; Type: TRIGGER; Schema: menu; Owner: postgres
--

CREATE TRIGGER trg_categorias_updated BEFORE UPDATE ON menu.categorias FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4249 (class 2620 OID 20229)
-- Name: recetas trg_recetas_updated; Type: TRIGGER; Schema: menu; Owner: postgres
--

CREATE TRIGGER trg_recetas_updated BEFORE UPDATE ON menu.recetas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4250 (class 2620 OID 20230)
-- Name: mesas trg_mesas_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_mesas_updated BEFORE UPDATE ON operaciones.mesas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4251 (class 2620 OID 20231)
-- Name: meseros trg_meseros_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_meseros_updated BEFORE UPDATE ON operaciones.meseros FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4252 (class 2620 OID 20232)
-- Name: pedidos trg_pedidos_updated; Type: TRIGGER; Schema: operaciones; Owner: postgres
--

CREATE TRIGGER trg_pedidos_updated BEFORE UPDATE ON operaciones.pedidos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4253 (class 2620 OID 20233)
-- Name: proveedores update_proveedores_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_proveedores_updated_at BEFORE UPDATE ON public.proveedores FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4254 (class 2620 OID 20234)
-- Name: restaurante update_restaurante_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_restaurante_updated_at BEFORE UPDATE ON public.restaurante FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4135 (class 2606 OID 20235)
-- Name: asiento_lineas fk_asiento_lineas_asiento; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas
    ADD CONSTRAINT fk_asiento_lineas_asiento FOREIGN KEY (asiento_id) REFERENCES contabilidad.asientos(id) ON DELETE CASCADE;


--
-- TOC entry 4136 (class 2606 OID 20240)
-- Name: asiento_lineas fk_asiento_lineas_cuenta; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas
    ADD CONSTRAINT fk_asiento_lineas_cuenta FOREIGN KEY (cuenta_id) REFERENCES contabilidad.plan_cuentas(id);


--
-- TOC entry 4137 (class 2606 OID 20245)
-- Name: asiento_lineas fk_asiento_lineas_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asiento_lineas
    ADD CONSTRAINT fk_asiento_lineas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4138 (class 2606 OID 20250)
-- Name: asientos fk_asientos_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.asientos
    ADD CONSTRAINT fk_asientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4139 (class 2606 OID 20255)
-- Name: libro_diario fk_libro_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.libro_diario
    ADD CONSTRAINT fk_libro_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4140 (class 2606 OID 20260)
-- Name: plan_cuentas fk_plan_cuentas_padre; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_plan_cuentas_padre FOREIGN KEY (padre_id) REFERENCES contabilidad.plan_cuentas(id);


--
-- TOC entry 4141 (class 2606 OID 20265)
-- Name: plan_cuentas fk_plan_cuentas_restaurante; Type: FK CONSTRAINT; Schema: contabilidad; Owner: postgres
--

ALTER TABLE ONLY contabilidad.plan_cuentas
    ADD CONSTRAINT fk_plan_cuentas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4143 (class 2606 OID 20270)
-- Name: usuarios FK_7ba064af415d3da35c33731f743; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.usuarios
    ADD CONSTRAINT "FK_7ba064af415d3da35c33731f743" FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id);


--
-- TOC entry 4142 (class 2606 OID 20275)
-- Name: metodos_pago fk_metodos_pago_restaurante; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.metodos_pago
    ADD CONSTRAINT fk_metodos_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4145 (class 2606 OID 20280)
-- Name: banco_movimientos fk_banco_mov_banco; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_banco FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id);


--
-- TOC entry 4146 (class 2606 OID 20285)
-- Name: banco_movimientos fk_banco_mov_metodo_pago; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4147 (class 2606 OID 20290)
-- Name: banco_movimientos fk_banco_mov_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4148 (class 2606 OID 20295)
-- Name: banco_movimientos fk_banco_mov_usuario; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco_movimientos
    ADD CONSTRAINT fk_banco_mov_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4144 (class 2606 OID 20300)
-- Name: banco fk_banco_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.banco
    ADD CONSTRAINT fk_banco_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4152 (class 2606 OID 20305)
-- Name: caja_movimientos fk_caja_mov_caja; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_caja FOREIGN KEY (caja_id) REFERENCES finanzas.caja(id);


--
-- TOC entry 4153 (class 2606 OID 20310)
-- Name: caja_movimientos fk_caja_mov_metodo_pago; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4154 (class 2606 OID 20315)
-- Name: caja_movimientos fk_caja_mov_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4155 (class 2606 OID 20320)
-- Name: caja_movimientos fk_caja_mov_usuario; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja_movimientos
    ADD CONSTRAINT fk_caja_mov_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4149 (class 2606 OID 20325)
-- Name: caja fk_caja_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4150 (class 2606 OID 20330)
-- Name: caja fk_caja_usuario_apertura; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_usuario_apertura FOREIGN KEY (usuario_apertura_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4151 (class 2606 OID 20335)
-- Name: caja fk_caja_usuario_cierre; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.caja
    ADD CONSTRAINT fk_caja_usuario_cierre FOREIGN KEY (usuario_cierre_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4156 (class 2606 OID 20340)
-- Name: egresos fk_egresos_categoria; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT fk_egresos_categoria FOREIGN KEY (categoria_id) REFERENCES inventario.categoria_egresos(id);


--
-- TOC entry 4157 (class 2606 OID 20345)
-- Name: egresos fk_egresos_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT fk_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4158 (class 2606 OID 20350)
-- Name: gastos_operativos fk_gastos_restaurante; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.gastos_operativos
    ADD CONSTRAINT fk_gastos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4159 (class 2606 OID 20355)
-- Name: categoria_egresos fk_cat_egresos_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.categoria_egresos
    ADD CONSTRAINT fk_cat_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4160 (class 2606 OID 20360)
-- Name: compra_detalle fk_compra_det_compra; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_compra FOREIGN KEY (compra_id) REFERENCES inventario.compras(id) ON DELETE CASCADE;


--
-- TOC entry 4161 (class 2606 OID 20365)
-- Name: compra_detalle fk_compra_det_ingrediente; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4162 (class 2606 OID 20370)
-- Name: compra_detalle fk_compra_det_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compra_detalle
    ADD CONSTRAINT fk_compra_det_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4163 (class 2606 OID 20380)
-- Name: compras fk_compras_proveedor; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT fk_compras_proveedor FOREIGN KEY (proveedor_id) REFERENCES inventario.proveedores(id);


--
-- TOC entry 4164 (class 2606 OID 20385)
-- Name: compras fk_compras_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.compras
    ADD CONSTRAINT fk_compras_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4165 (class 2606 OID 20390)
-- Name: ingredientes fk_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT fk_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4166 (class 2606 OID 20395)
-- Name: ingredientes fk_ingredientes_unidad; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.ingredientes
    ADD CONSTRAINT fk_ingredientes_unidad FOREIGN KEY (unidad_id) REFERENCES core.unidad_medida(id);


--
-- TOC entry 4167 (class 2606 OID 20400)
-- Name: mermas fk_mermas_ingrediente; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4168 (class 2606 OID 20405)
-- Name: mermas fk_mermas_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4169 (class 2606 OID 20410)
-- Name: mermas fk_mermas_usuario; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.mermas
    ADD CONSTRAINT fk_mermas_usuario FOREIGN KEY (reportado_por) REFERENCES core.usuarios(id);


--
-- TOC entry 4170 (class 2606 OID 20415)
-- Name: proveedores fk_proveedores_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.proveedores
    ADD CONSTRAINT fk_proveedores_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4171 (class 2606 OID 20420)
-- Name: unidad_compra fk_unidad_compra_restaurante; Type: FK CONSTRAINT; Schema: inventario; Owner: postgres
--

ALTER TABLE ONLY inventario.unidad_compra
    ADD CONSTRAINT fk_unidad_compra_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4172 (class 2606 OID 20425)
-- Name: products products_categoria_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.products
    ADD CONSTRAINT products_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES inventory.categories(id);


--
-- TOC entry 4173 (class 2606 OID 20430)
-- Name: categorias fk_categorias_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.categorias
    ADD CONSTRAINT fk_categorias_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4174 (class 2606 OID 20435)
-- Name: receta_ingredientes fk_receta_ing_ingrediente; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES inventario.ingredientes(id);


--
-- TOC entry 4175 (class 2606 OID 20440)
-- Name: receta_ingredientes fk_receta_ing_receta; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_receta FOREIGN KEY (receta_id) REFERENCES menu.recetas(id) ON DELETE CASCADE;


--
-- TOC entry 4176 (class 2606 OID 20445)
-- Name: receta_ingredientes fk_receta_ing_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.receta_ingredientes
    ADD CONSTRAINT fk_receta_ing_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4177 (class 2606 OID 20450)
-- Name: recetas fk_recetas_categoria; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT fk_recetas_categoria FOREIGN KEY (categoria_id) REFERENCES menu.categorias(id);


--
-- TOC entry 4178 (class 2606 OID 20455)
-- Name: recetas fk_recetas_restaurante; Type: FK CONSTRAINT; Schema: menu; Owner: postgres
--

ALTER TABLE ONLY menu.recetas
    ADD CONSTRAINT fk_recetas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4179 (class 2606 OID 20460)
-- Name: facturas fk_facturas_metodo_pago; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES core.metodos_pago(id);


--
-- TOC entry 4180 (class 2606 OID 20465)
-- Name: facturas fk_facturas_pedido; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id);


--
-- TOC entry 4181 (class 2606 OID 20470)
-- Name: facturas fk_facturas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4182 (class 2606 OID 20475)
-- Name: facturas fk_facturas_usuario; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.facturas
    ADD CONSTRAINT fk_facturas_usuario FOREIGN KEY (usuario_id) REFERENCES core.usuarios(id);


--
-- TOC entry 4183 (class 2606 OID 20480)
-- Name: mesas fk_mesas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.mesas
    ADD CONSTRAINT fk_mesas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4184 (class 2606 OID 20485)
-- Name: meseros fk_meseros_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.meseros
    ADD CONSTRAINT fk_meseros_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4185 (class 2606 OID 20490)
-- Name: pedido_detalle fk_pedido_det_pedido; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4186 (class 2606 OID 20495)
-- Name: pedido_detalle fk_pedido_det_receta; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_receta FOREIGN KEY (receta_id) REFERENCES menu.recetas(id);


--
-- TOC entry 4187 (class 2606 OID 20500)
-- Name: pedido_detalle fk_pedido_det_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedido_detalle
    ADD CONSTRAINT fk_pedido_det_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4188 (class 2606 OID 20505)
-- Name: pedidos fk_pedidos_mesa; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_mesa FOREIGN KEY (mesa_id) REFERENCES operaciones.mesas(id);


--
-- TOC entry 4189 (class 2606 OID 20510)
-- Name: pedidos fk_pedidos_mesero; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_mesero FOREIGN KEY (mesero_id) REFERENCES operaciones.meseros(id);


--
-- TOC entry 4190 (class 2606 OID 20515)
-- Name: pedidos fk_pedidos_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.pedidos
    ADD CONSTRAINT fk_pedidos_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4191 (class 2606 OID 20520)
-- Name: reservas fk_reservas_mesa; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT fk_reservas_mesa FOREIGN KEY (mesa_id) REFERENCES operaciones.mesas(id);


--
-- TOC entry 4192 (class 2606 OID 20525)
-- Name: reservas fk_reservas_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.reservas
    ADD CONSTRAINT fk_reservas_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4193 (class 2606 OID 20530)
-- Name: transacciones_pago fk_trans_pago_pedido; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.transacciones_pago
    ADD CONSTRAINT fk_trans_pago_pedido FOREIGN KEY (pedido_id) REFERENCES operaciones.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4194 (class 2606 OID 20535)
-- Name: transacciones_pago fk_trans_pago_restaurante; Type: FK CONSTRAINT; Schema: operaciones; Owner: postgres
--

ALTER TABLE ONLY operaciones.transacciones_pago
    ADD CONSTRAINT fk_trans_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES core.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4223 (class 2606 OID 20540)
-- Name: order_items FK_145532db85752b29c57d2b7b1f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_145532db85752b29c57d2b7b1f1" FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4196 (class 2606 OID 20545)
-- Name: banco_movimientos fk_banco_movimientos_banco; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_banco FOREIGN KEY (banco_id) REFERENCES public.banco(id);


--
-- TOC entry 4197 (class 2606 OID 20550)
-- Name: banco_movimientos fk_banco_movimientos_metodo_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES public.metodos_pago(id);


--
-- TOC entry 4198 (class 2606 OID 20555)
-- Name: banco_movimientos fk_banco_movimientos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4199 (class 2606 OID 20560)
-- Name: banco_movimientos fk_banco_movimientos_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco_movimientos
    ADD CONSTRAINT fk_banco_movimientos_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4195 (class 2606 OID 20565)
-- Name: banco fk_banco_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banco
    ADD CONSTRAINT fk_banco_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4203 (class 2606 OID 20570)
-- Name: caja_movimientos fk_caja_movimientos_caja; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_caja FOREIGN KEY (caja_id) REFERENCES public.caja(id);


--
-- TOC entry 4204 (class 2606 OID 20575)
-- Name: caja_movimientos fk_caja_movimientos_metodo_pago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_metodo_pago FOREIGN KEY (metodo_pago_id) REFERENCES public.metodos_pago(id);


--
-- TOC entry 4205 (class 2606 OID 20580)
-- Name: caja_movimientos fk_caja_movimientos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4206 (class 2606 OID 20585)
-- Name: caja_movimientos fk_caja_movimientos_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT fk_caja_movimientos_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4200 (class 2606 OID 20590)
-- Name: caja fk_caja_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4201 (class 2606 OID 20595)
-- Name: caja fk_caja_usuario_apertura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_usuario_apertura FOREIGN KEY (usuario_apertura_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4202 (class 2606 OID 20600)
-- Name: caja fk_caja_usuario_cierre; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_caja_usuario_cierre FOREIGN KEY (usuario_cierre_id) REFERENCES public.usuarios(id);


--
-- TOC entry 4207 (class 2606 OID 20605)
-- Name: categoria_egresos fk_categoria_egresos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_egresos
    ADD CONSTRAINT fk_categoria_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4208 (class 2606 OID 20610)
-- Name: compra_detalle fk_compra_detalle_compra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_compra FOREIGN KEY (compra_id) REFERENCES public.compras(id) ON DELETE CASCADE;


--
-- TOC entry 4209 (class 2606 OID 20615)
-- Name: compra_detalle fk_compra_detalle_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES public.ingredientes(id);


--
-- TOC entry 4210 (class 2606 OID 20620)
-- Name: compra_detalle fk_compra_detalle_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4211 (class 2606 OID 20625)
-- Name: compra_detalle fk_compra_detalle_unidad_compra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra_detalle
    ADD CONSTRAINT fk_compra_detalle_unidad_compra FOREIGN KEY (unidad_compra_id) REFERENCES public.unidad_compra(id);


--
-- TOC entry 4212 (class 2606 OID 20630)
-- Name: compras fk_compras_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT fk_compras_proveedor FOREIGN KEY (proveedor_id) REFERENCES public.proveedores(id);


--
-- TOC entry 4213 (class 2606 OID 20635)
-- Name: compras fk_compras_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compras
    ADD CONSTRAINT fk_compras_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4214 (class 2606 OID 20640)
-- Name: egresos fk_egresos_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT fk_egresos_categoria FOREIGN KEY (categoria_id) REFERENCES public.categoria_egresos(id);


--
-- TOC entry 4215 (class 2606 OID 20645)
-- Name: egresos fk_egresos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egresos
    ADD CONSTRAINT fk_egresos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4216 (class 2606 OID 20650)
-- Name: facturas fk_facturas_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT fk_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id);


--
-- TOC entry 4217 (class 2606 OID 20655)
-- Name: facturas fk_facturas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT fk_facturas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4218 (class 2606 OID 20660)
-- Name: ingredientes fk_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT fk_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4219 (class 2606 OID 20665)
-- Name: ingredientes fk_ingredientes_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT fk_ingredientes_unidad FOREIGN KEY (unidad_id) REFERENCES public.unidad_medida(id);


--
-- TOC entry 4220 (class 2606 OID 20670)
-- Name: mesas fk_mesas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT fk_mesas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4221 (class 2606 OID 20675)
-- Name: meseros fk_meseros_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meseros
    ADD CONSTRAINT fk_meseros_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4222 (class 2606 OID 20680)
-- Name: metodos_pago fk_metodos_pago_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metodos_pago
    ADD CONSTRAINT fk_metodos_pago_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4224 (class 2606 OID 20685)
-- Name: pedido_detalle fk_pedido_detalle_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_pedido FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- TOC entry 4225 (class 2606 OID 20690)
-- Name: pedido_detalle fk_pedido_detalle_receta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_receta FOREIGN KEY (receta_id) REFERENCES public.recetas(id);


--
-- TOC entry 4226 (class 2606 OID 20695)
-- Name: pedido_detalle fk_pedido_detalle_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT fk_pedido_detalle_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4227 (class 2606 OID 20700)
-- Name: pedidos fk_pedidos_mesa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_mesa FOREIGN KEY (mesa_id) REFERENCES public.mesas(id);


--
-- TOC entry 4228 (class 2606 OID 20705)
-- Name: pedidos fk_pedidos_mesero; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_mesero FOREIGN KEY (mesero_id) REFERENCES public.meseros(id);


--
-- TOC entry 4229 (class 2606 OID 20710)
-- Name: pedidos fk_pedidos_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4230 (class 2606 OID 20715)
-- Name: proveedores fk_proveedores_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT fk_proveedores_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4231 (class 2606 OID 20720)
-- Name: receta_ingredientes fk_receta_ingredientes_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_ingrediente FOREIGN KEY (ingrediente_id) REFERENCES public.ingredientes(id);


--
-- TOC entry 4232 (class 2606 OID 20725)
-- Name: receta_ingredientes fk_receta_ingredientes_receta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_receta FOREIGN KEY (receta_id) REFERENCES public.recetas(id) ON DELETE CASCADE;


--
-- TOC entry 4233 (class 2606 OID 20730)
-- Name: receta_ingredientes fk_receta_ingredientes_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_ingredientes
    ADD CONSTRAINT fk_receta_ingredientes_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4234 (class 2606 OID 20735)
-- Name: recetas fk_recetas_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT fk_recetas_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4235 (class 2606 OID 20740)
-- Name: roles fk_roles_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT fk_roles_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4236 (class 2606 OID 20745)
-- Name: unidad_compra fk_unidad_compra_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_compra
    ADD CONSTRAINT fk_unidad_compra_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4237 (class 2606 OID 20750)
-- Name: usuarios fk_usuarios_restaurante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuarios_restaurante FOREIGN KEY (restaurante_id) REFERENCES public.restaurante(id) ON DELETE CASCADE;


--
-- TOC entry 4238 (class 2606 OID 20755)
-- Name: usuarios fk_usuarios_rol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) REFERENCES public.roles(id);


--
-- TOC entry 4239 (class 2606 OID 20760)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES sales.orders(id) ON DELETE CASCADE;


--
-- TOC entry 4240 (class 2606 OID 20765)
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES inventory.products(id);


--
-- TOC entry 4241 (class 2606 OID 20770)
-- Name: orders orders_restaurant_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_restaurant_id_fkey FOREIGN KEY (restaurant_id) REFERENCES core.restaurante(id);


--
-- TOC entry 4242 (class 2606 OID 20775)
-- Name: orders orders_table_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES core.tables(id);


-- Completed on 2026-05-19 00:30:49 -04

--
-- PostgreSQL database dump complete
--

\unrestrict mG8YTp6RWD4QMwFrZeqlkC4EwIFbE2Z9W1YcLMTWijrC4IHeQvY1m5Yxf7GImPc


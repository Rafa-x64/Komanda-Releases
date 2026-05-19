"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
// @ts-ignore
const pg_1 = require("pg");
const fs = __importStar(require("fs"));
async function run() {
    const client = new pg_1.Client({
        host: "localhost",
        port: 5432,
        user: "postgres",
        password: "postgres",
        database: "komanda_db",
    });
    try {
        await client.connect();
        // Get tables
        const res = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name;
    `);
        const schema = {};
        for (const row of res.rows) {
            const tableName = row.table_name;
            // Get columns for each table
            const colRes = await client.query(`
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = $1;
      `, [tableName]);
            schema[tableName] = colRes.rows;
        }
        fs.writeFileSync("schema_output.json", JSON.stringify(schema, null, 2));
        console.log("Schema written to schema_output.json");
    }
    catch (error) {
        fs.writeFileSync("schema_output.json", JSON.stringify({ error: error.message }, null, 2));
        console.error("Error written to schema_output.json");
    }
    finally {
        await client.end();
    }
}
run();

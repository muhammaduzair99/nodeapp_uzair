require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const mysql = require('mysql2/promise');

const app = express();
const port = 3000;

// PostgreSQL connection pool
const pgPool = new Pool({
  user: process.env.PG_USER,
  host: process.env.PG_HOST,
  database: process.env.PG_DATABASE,
  password: process.env.PG_PASSWORD,
  port: 5432,
  ssl: { rejectUnauthorized: false }
});

// MySQL connection config
const mysqlConfig = {
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
};

app.get('/', (req, res) => {
  res.send('🚀 Hello from Dockerized Node.js App!');
});

app.get('/pgsql', async (req, res) => {
  try {
    const result = await pgPool.query('SELECT NOW()');
    res.send(`✅ PostgreSQL connected! Server time: ${result.rows[0].now}`);
  } catch (err) {
    console.error('❌ PostgreSQL error:', err.message);
    res.status(500).send('❌ PostgreSQL connection failed.');
  }
});

app.get('/mysql', async (req, res) => {
  try {
    const connection = await mysql.createConnection(mysqlConfig);
    const [rows] = await connection.execute('SELECT NOW() AS now');
    await connection.end();
    res.send(`✅ MySQL connected! Server time: ${rows[0].now}`);
  } catch (err) {
    console.error('❌ MySQL error:', err.message);
    res.status(500).send('❌ MySQL connection failed.');
  }
});

app.get('/check-all', async (req, res) => {
  const result = {
    docker: true,
    pgsql: false,
    mysql: false
  };

  // Check PostgreSQL
  try {
    const pgResult = await pgPool.query('SELECT 1');
    result.pgsql = pgResult ? true : false;
  } catch (err) {
    console.error('PostgreSQL check failed:', err.message);
  }

  // Check MySQL
  try {
    const connection = await mysql.createConnection(mysqlConfig);
    await connection.execute('SELECT 1');
    await connection.end();
    result.mysql = true;
  } catch (err) {
    console.error('MySQL check failed:', err.message);
  }

  res.json(result);
});

app.listen(port, () => {
  console.log(`🚀 App is running at http://localhost:${port}`);
});

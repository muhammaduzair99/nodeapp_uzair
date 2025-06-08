const express = require('express');
const mysql = require('mysql2');
const { Client } = require('pg');
require('dotenv').config();

const app = express();

// MySQL connection
const mysqlConnection = mysql.createConnection({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
  port: process.env.MYSQL_PORT,
});

// PostgreSQL connection
const pgClient = new Client({
  host: process.env.POSTGRES_HOST,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DATABASE,
  port: process.env.POSTGRES_PORT,
});

// Test MySQL connection
mysqlConnection.connect(err => {
  if (err) {
    console.error('❌ MySQL connection failed:', err.stack);
  } else {
    console.log('✅ Connected to MySQL RDS');
  }
});

// Test PostgreSQL connection
pgClient.connect(err => {
  if (err) {
    console.error('❌ PostgreSQL connection failed:', err.stack);
  } else {
    console.log('✅ Connected to PostgreSQL RDS');
  }
});

app.get('/', (req, res) => {
  res.send('Hello from Dockerized Node.js App with RDS connections!');
});

app.listen(3000, () => {
  console.log('App running on port 3000');
});

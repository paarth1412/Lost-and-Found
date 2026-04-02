// db.js — MariaDB connection using mysql2
// Required by server.js

const mysql = require('mysql2')

const db = mysql.createConnection({
  host:     'localhost',
  user:     'root',
  password: 'Pranav@9100',           // ← put your MariaDB password here
  database: 'lost_and_found'
})

db.connect((err) => {
  if (err) {
    console.error('Database connection failed:', err.message)
    process.exit(1)
  }
  console.log('Connected to MariaDB — lost_and_found')
})

module.exports = db

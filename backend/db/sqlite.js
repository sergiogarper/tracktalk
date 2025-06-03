const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.resolve(__dirname, 'tracktalk.db');

// Crea la conexion
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error al conectar con la base de datos:', err.message);
  } else {
    console.log('Conexión con SQLite establecida');
  }
});

db.run('PRAGMA foreign_keys = ON');

module.exports = db;

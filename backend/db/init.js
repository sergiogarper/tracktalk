const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.resolve(__dirname, 'tracktalk.db');
const db = new sqlite3.Database(dbPath);

db.serialize(() => {
  db.run('PRAGMA foreign_keys = ON');

  db.run(`
    CREATE TABLE IF NOT EXISTS Usuario (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      pass TEXT NOT NULL,
      fecha_registro TEXT
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS Cancion (
      id TEXT PRIMARY KEY,
      nombre TEXT NOT NULL,
      artista TEXT,
      url TEXT,
      imagen_url TEXT,
      preview_url TEXT
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS Chat (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      usuario_id INTEGER,
      fecha TEXT,
      FOREIGN KEY (usuario_id) REFERENCES Usuario(id)
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS Mensaje (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      chat_id INTEGER,
      emisor TEXT CHECK (emisor IN ('usuario', 'ia')),
      contenido TEXT NOT NULL,
      fecha_envio TEXT,
      FOREIGN KEY (chat_id) REFERENCES Chat(id)
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS Recomendacion (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      mensaje_id INTEGER,
      cancion_id TEXT,
      FOREIGN KEY (mensaje_id) REFERENCES Mensaje(id),
      FOREIGN KEY (cancion_id) REFERENCES Cancion(id)
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS Favorito (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      usuario_id INTEGER,
      cancion_id TEXT,
      fecha_guardado TEXT,
      FOREIGN KEY (usuario_id) REFERENCES Usuario(id),
      FOREIGN KEY (cancion_id) REFERENCES Cancion(id)
    )
  `);

  console.log('Todas las tablas han sido creadas correctamente!!');
});

db.close();

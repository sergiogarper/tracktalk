const db = require('../db/sqlite');

// Añadir una canción a favoritos
const addFavorito = (req, res) => {
  const { usuario_id, cancion } = req.body;

  if (!usuario_id || !cancion || !cancion.id || !cancion.nombre) {
    return res.status(400).json({ error: 'Datos incompletos' });
  }

  // Verificar si el favorito ya existe para ese usuario y canción
  const checkQuery = `SELECT * FROM Favorito WHERE usuario_id = ? AND cancion_id = ?`;

  db.get(checkQuery, [usuario_id, cancion.id], (err, row) => {
    if (err) {
      console.error('Error al comprobar duplicado:', err);
      return res.status(500).json({ error: 'Error al comprobar duplicado' });
    }

    if (row) {
      return res.status(409).json({ error: 'La canción ya está en favoritos' });
    }

    // Insertar canción si no existe
    const insertCancionQuery = `
      INSERT OR IGNORE INTO Cancion (id, nombre, artista, url, imagen_url, preview_url)
      VALUES (?, ?, ?, ?, ?, ?)
    `;

    db.run(
      insertCancionQuery,
      [cancion.id, cancion.nombre, cancion.artista, cancion.imagen_url, cancion.preview_url],
      (err) => {
        if (err) {
          console.error('Error al guardar la canción:', err);
          return res.status(500).json({ error: 'Error al guardar la canción' });
        }

        // Insertar favorito
        const insertFavoritoQuery = `
          INSERT INTO Favorito (usuario_id, cancion_id, fecha_guardado)
          VALUES (?, ?, datetime('now'))
        `;

        db.run(insertFavoritoQuery, [usuario_id, cancion.id], function (err) {
          if (err) {
            console.error('Error al guardar favorito:', err);
            return res.status(500).json({ error: 'Error al guardar favorito' });
          }

          return res.status(201).json({ message: 'Favorito guardado correctamente' });
        });
      }
    );
  });
};

// Obtener canciones favoritas de un usuario
const getFavoritos = (req, res) => {
  const usuarioId = req.params.usuarioId;

  if (!usuarioId) {
    return res.status(400).json({ error: 'Falta el ID del usuario' });
  }

  const query = `
    SELECT C.*
    FROM Favorito F
    JOIN Cancion C ON F.cancion_id = C.id
    WHERE F.usuario_id = ?
    ORDER BY F.fecha_guardado DESC
  `;

  db.all(query, [usuarioId], (err, rows) => {
    if (err) {
      console.error('Error al obtener favoritos:', err);
      return res.status(500).json({ error: 'Error al obtener favoritos' });
    }

    return res.status(200).json({ favoritos: rows });
  });
};

module.exports = { addFavorito, getFavoritos };

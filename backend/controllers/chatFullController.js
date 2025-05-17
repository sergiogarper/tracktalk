const db = require('../db/sqlite');
const { generarRecomendacion } = require('../services/recomendacionService');

async function procesarMensajeChat(req, res) {
  const { usuario_id, mensaje_usuario, chat_id } = req.body;

  if (!usuario_id || !mensaje_usuario) {
    return res.status(400).json({ error: 'Faltan campos obligatorios: usuario_id o mensaje_usuario' });
  }

  try {
    const fecha = new Date().toISOString();

    // 1. Usar chat_id si se pasa, si no, crear uno nuevo
    let chatId = chat_id;

    if (!chatId) {
      chatId = await new Promise((resolve, reject) => {
        db.run(
          'INSERT INTO Chat (usuario_id, fecha) VALUES (?, ?)',
          [usuario_id, fecha],
          function (err) {
            if (err) reject(err);
            else resolve(this.lastID);
          }
        );
      });
    }

    // 2. Guardar el mensaje del usuario
    const mensajeUsuarioId = await new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO Mensaje (chat_id, emisor, contenido, fecha_envio) VALUES (?, "usuario", ?, ?)',
        [chatId, mensaje_usuario, fecha],
        function (err) {
          if (err) reject(err);
          else resolve(this.lastID);
        }
      );
    });

    // 3. Generar respuesta de la IA y recomendaciones
    const { mensajeIA, canciones } = await generarRecomendacion(mensaje_usuario);

    // 4. Guardar mensaje IA
    const mensajeIAId = await new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO Mensaje (chat_id, emisor, contenido, fecha_envio) VALUES (?, "ia", ?, ?)',
        [chatId, mensajeIA, fecha],
        function (err) {
          if (err) reject(err);
          else resolve(this.lastID);
        }
      );
    });

    // 5. Insertar canciones y recomendaciones
    for (const cancion of canciones) {
      await new Promise((resolve, reject) => {
        db.run(
          'INSERT OR IGNORE INTO Cancion (id, nombre, artista, imagen_url, preview_url) VALUES (?, ?, ?, ?, ?)',
          [cancion.id, cancion.nombre, cancion.artista, cancion.imagen, cancion.preview],
          err => err ? reject(err) : resolve()
        );
      });

      await new Promise((resolve, reject) => {
        db.run(
          'INSERT INTO Recomendacion (mensaje_id, cancion_id) VALUES (?, ?)',
          [mensajeIAId, cancion.id],
          err => err ? reject(err) : resolve()
        );
      });
    }

    // 6. Devolver resultado
    res.json({
      chat_id: chatId,
      mensaje_usuario,
      mensaje_ia: mensajeIA,
      canciones,
    });

  } catch (err) {
    console.error('❌ Error al procesar el mensaje completo:', err);
    res.status(500).json({ error: 'Error interno del servidor al procesar el mensaje' });
  }
}

module.exports = { procesarMensajeChat };

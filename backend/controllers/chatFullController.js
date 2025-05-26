const db = require("../db/sqlite");
const { generarRecomendacion } = require("../services/recomendacionService");

async function procesarMensajeChat(req, res) {
  const { usuario_id, mensaje_usuario, chat_id } = req.body;

  if (!usuario_id || !mensaje_usuario) {
    return res
      .status(400)
      .json({
        error: "Faltan campos obligatorios: usuario_id o mensaje_usuario",
      });
  }

  try {
    const fecha = new Date().toISOString();

    // 1. Usar chat_id si se pasa, si no, crear uno nuevo
    let chatId = chat_id;

    if (!chatId) {
      chatId = await new Promise((resolve, reject) => {
        db.run(
          "INSERT INTO Chat (usuario_id, fecha) VALUES (?, ?)",
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
    const { mensajeIA, canciones } = await generarRecomendacion(
      mensaje_usuario
    );

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
          "INSERT OR IGNORE INTO Cancion (id, nombre, artista, url, imagen_url, preview_url) VALUES (?, ?, ?, ?, ?, ?)",
          [
            cancion.id,
            cancion.nombre,
            cancion.artista,
            cancion.url,
            cancion.imagen,
            cancion.preview,
          ],
          (err) => (err ? reject(err) : resolve())
        );
      });

      await new Promise((resolve, reject) => {
        db.run(
          "INSERT INTO Recomendacion (mensaje_id, cancion_id) VALUES (?, ?)",
          [mensajeIAId, cancion.id],
          (err) => (err ? reject(err) : resolve())
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
    console.error("❌ Error al procesar el mensaje completo:", err);
    res
      .status(500)
      .json({ error: "Error interno del servidor al procesar el mensaje" });
  }
}

function obtenerHistorialChats(req, res) {
  const usuarioId = req.params.usuario_id;

  db.all(
    "SELECT id AS chat_id, fecha FROM Chat WHERE usuario_id = ? ORDER BY fecha DESC",
    [usuarioId],
    (err, rows) => {
      if (err) {
        console.error("❌ Error al obtener historial:", err);
        return res.status(500).json({ error: "Error al obtener el historial" });
      }

      res.json(rows);
    }
  );
}

function obtenerChatCompleto(req, res) {
  const { usuario_id, chat_id } = req.params;

  db.all(
    `SELECT M.id, M.emisor, M.contenido, M.fecha_envio,
            GROUP_CONCAT(R.cancion_id) AS canciones
     FROM Mensaje M
     LEFT JOIN Recomendacion R ON M.id = R.mensaje_id
     JOIN Chat C ON C.id = M.chat_id
     WHERE M.chat_id = ? AND C.usuario_id = ?
     GROUP BY M.id
     ORDER BY M.fecha_envio ASC`,
    [chat_id, usuario_id],
    async (err, rows) => {
      if (err) {
        console.error("❌ Error al obtener el chat completo:", err);
        return res.status(500).json({ error: "Error al obtener el chat" });
      }

      const mensajes = [];

      for (const row of rows) {
        const isUser = row.emisor === "usuario";
        let recomendaciones = [];

        if (!isUser && row.canciones) {
          const ids = row.canciones.split(",");
          recomendaciones = await Promise.all(
            ids.map(
              (id) =>
                new Promise((resolve, reject) => {
                  db.get(
                    "SELECT id, nombre, artista, url, imagen_url AS imagen, preview_url AS preview FROM Cancion WHERE id = ?",
                    [id],
                    (err, data) => (err ? reject(err) : resolve(data))
                  );
                })
            )
          );
        }

        mensajes.push({
          text: row.contenido,
          isUser,
          recomendaciones,
        });
      }

      res.json(mensajes);
    }
  );
}

module.exports = {
  procesarMensajeChat,
  obtenerHistorialChats,
  obtenerChatCompleto,
};

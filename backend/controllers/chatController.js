const { generarRecomendacion } = require('../services/recomendacionService');

const MAX_QUERY_LENGTH = 250;

async function recomendarCanciones(req, res) {
  const { mensaje } = req.body;

  if (!mensaje) {
    return res.status(400).json({ error: 'El campo "mensaje" es obligatorio' });
  }

  if (mensaje.length > MAX_QUERY_LENGTH) {
    return res.status(400).json({
      error: `El mensaje excede el límite permitido de ${MAX_QUERY_LENGTH} caracteres`,
    });
  }

  try {
    const { mensajeIA, canciones } = await generarRecomendacion(mensaje);

    res.json({
      mensaje_bonito: mensajeIA,
      canciones,
    });
  } catch (error) {
    console.error(error.response?.data || error.message);
    res.status(500).json({ error: 'Error en el servidor al generar recomendaciones' });
  }
}

module.exports = { recomendarCanciones };

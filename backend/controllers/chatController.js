const OpenAI = require('openai');
const extractSongs = require('../utils/extractSongs');
const { buscarPreviews } = require('../services/spotifyService');
const systemPrompt = require('../systemPrompt');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

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
    const respuestaIA = await openai.chat.completions.create({
      model: 'gpt-4o',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: mensaje },
      ],
    });

    const textoRespuesta = respuestaIA.choices[0].message.content.trim();
    const lineas = textoRespuesta.split('\n').map(line => line.trim()).filter(line => line);

    const indicePrimerRecomendacion = lineas.findIndex(linea => linea.match(/^1\.\s/));
    const mensajeBonito = indicePrimerRecomendacion !== -1
      ? lineas.slice(0, indicePrimerRecomendacion).join(' ')
      : lineas.join(' ');

    const recomendacionesTexto = indicePrimerRecomendacion !== -1
      ? lineas.slice(indicePrimerRecomendacion).join('\n')
      : '';

    const cancionesExtraidas = recomendacionesTexto
      ? extractSongs(recomendacionesTexto)
      : [];

    const resultados = await buscarPreviews(cancionesExtraidas);

    res.json({
      mensaje_bonito: mensajeBonito,
      canciones: resultados,
    });

  } catch (error) {
    console.error(error.response?.data || error.message);
    res.status(500).json({ error: 'Error en el servidor al generar recomendaciones' });
  }
}

module.exports = { recomendarCanciones };

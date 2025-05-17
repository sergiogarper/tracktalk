const OpenAI = require('openai');
const extractSongs = require('../utils/extractSongs');
const { buscarPreviews } = require('./spotifyService');
const systemPrompt = require('../systemPrompt');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

async function generarRecomendacion(mensajeUsuario) {
  const respuestaIA = await openai.chat.completions.create({
    model: 'gpt-4o',
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: mensajeUsuario },
    ],
  });

  const textoRespuesta = respuestaIA.choices[0].message.content.trim();
  const lineas = textoRespuesta.split('\n').map(l => l.trim()).filter(Boolean);

  const indiceRecomendaciones = lineas.findIndex(linea => /^1\./.test(linea));
  const mensajeIA = indiceRecomendaciones !== -1
    ? lineas.slice(0, indiceRecomendaciones).join(' ')
    : lineas.join(' ');

  const recomendacionesTexto = indiceRecomendaciones !== -1
    ? lineas.slice(indiceRecomendaciones).join('\n')
    : '';

  const cancionesExtraidas = extractSongs(recomendacionesTexto);
  const canciones = await buscarPreviews(cancionesExtraidas);

  return {
    mensajeIA,
    canciones
  };
}

module.exports = { generarRecomendacion };

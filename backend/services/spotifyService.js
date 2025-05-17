// AQUI BUSCO LA PREVIEW DE CADA CANCIÓN EXTRAIDA
const spotifyPreviewFinder = require('spotify-preview-finder');

async function buscarPreviews(cancionesExtraidas) {
  const resultados = [];

  for (let cancion of cancionesExtraidas) {
    const query = `${cancion.titulo} ${cancion.artista}`;
    try {
      const result = await spotifyPreviewFinder(query, 1);
      if (result.success && result.results.length > 0) {
        const song = result.results[0];
        resultados.push({
          nombre: song.name,
          artista: cancion.artista,
          url: song.spotifyUrl,
          preview: song.previewUrls[0] || null,
        });
      } else {
        console.warn(`No se encontró preview para: ${query}`);
      }
    } catch (err) {
      console.warn(`Error al buscar preview de ${query}:`, err.message);
    }
  }

  return resultados;
}

module.exports = { buscarPreviews };
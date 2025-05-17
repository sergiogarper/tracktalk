const spotifyPreviewFinder = require('spotify-preview-finder');
const axios = require('axios');
const obtenerTokenSpotify = require('./spotifyAuth');

async function buscarInfoExtra(nombre, artista) {
  const token = await obtenerTokenSpotify();
  const query = encodeURIComponent(`${nombre} ${artista}`);

  const url = `https://api.spotify.com/v1/search?q=${query}&type=track&limit=1`;

  try {
    const response = await axios.get(url, {
      headers: { Authorization: `Bearer ${token}` },
    });

    const track = response.data.tracks.items[0];

    if (track) {
      return {
        id: track.id,
        imagen: track.album?.images?.[0]?.url || null,
        artista: track.artists?.[0]?.name || artista,
      };
    }
  } catch (err) {
    console.warn(`No se pudo obtener info extra para: ${nombre} - ${artista}`);
  }

  return {
    id: null,
    imagen: null,
    artista: artista,
  };
}

async function buscarPreviews(cancionesExtraidas) {
  const resultados = [];

  for (let cancion of cancionesExtraidas) {
    const query = `${cancion.titulo} ${cancion.artista}`;
    try {
      const result = await spotifyPreviewFinder(query, 1);
      if (result.success && result.results.length > 0) {
        const song = result.results[0];

        const extra = await buscarInfoExtra(song.name, cancion.artista);

        resultados.push({
          id: extra.id,
          nombre: song.name,
          artista: extra.artista,
          url: song.spotifyUrl,
          preview: song.previewUrls[0] || null,
          imagen: extra.imagen,
        });
      }
    } catch (err) {
      console.warn(`Error al buscar preview de ${query}:`, err.message);
    }
  }

  return resultados;
}

module.exports = { buscarPreviews };

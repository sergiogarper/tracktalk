const spotifyPreviewFinder = require("spotify-preview-finder");
const axios = require("axios");
const obtenerTokenSpotify = require("./spotifyAuth");

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

async function obtenerCancionesRecientes(artista, limite = 5) {
  const token = await obtenerTokenSpotify();

  try {
    const resArtista = await axios.get(
      `https://api.spotify.com/v1/search?q=${encodeURIComponent(artista)}&type=artist&limit=1`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );

    const artistaId = resArtista.data.artists.items[0]?.id;
    if (!artistaId) return [];

    const resAlbums = await axios.get(
      `https://api.spotify.com/v1/artists/${artistaId}/albums?include_groups=single,album&market=ES&limit=50`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );

    const ahora = new Date();
    const hace6Meses = new Date();
    hace6Meses.setMonth(hace6Meses.getMonth() - 6);

    const albumsFiltrados = resAlbums.data.items
      .filter(album => album.release_date_precision === "day")
      .filter(album => {
        const fecha = new Date(album.release_date);
        return fecha >= hace6Meses;
      })
      .sort((a, b) => new Date(b.release_date) - new Date(a.release_date));

    const canciones = [];

    for (const album of albumsFiltrados) {
      const resTracks = await axios.get(
        `https://api.spotify.com/v1/albums/${album.id}/tracks`,
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );

      for (const track of resTracks.data.items) {
        let preview = track.preview_url;

        if (!preview) {
          try {
            const result = await spotifyPreviewFinder(`${track.name} ${artista}`, 1);
            if (result.success && result.results.length > 0) {
              preview = result.results[0].previewUrls[0] || null;
            }
          } catch (err) {
            console.warn(`Error al buscar preview externo para ${track.name}:`, err.message);
          }
        }

        canciones.push({
          id: track.id,
          nombre: track.name,
          artista,
          url: track.external_urls.spotify,
          imagen: album.images[0]?.url || null,
          preview,
        });

        if (canciones.length >= limite) break;
      }

      if (canciones.length >= limite) break;
    }

    return canciones;
  } catch (err) {
    console.error("Error al obtener canciones recientes:", err.message);
    return [];
  }
}


module.exports = { buscarPreviews, obtenerCancionesRecientes };

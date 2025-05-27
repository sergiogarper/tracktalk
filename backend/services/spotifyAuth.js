// services/spotifyAuth.js
const axios = require('axios');

let cachedToken = null;
let tokenTimestamp = null;

async function obtenerTokenSpotify() {
  const ahora = Date.now();

  if (cachedToken && ahora - tokenTimestamp < 3600 * 1000) {
    return cachedToken;
  }

  const clientId = process.env.SPOTIFY_CLIENT_ID;
  const clientSecret = process.env.SPOTIFY_CLIENT_SECRET;
  const auth = Buffer.from(`${clientId}:${clientSecret}`).toString('base64');

  try {
    const response = await axios.post(
      'https://accounts.spotify.com/api/token',
      new URLSearchParams({ grant_type: 'client_credentials' }),
      {
        headers: {
          'Authorization': `Basic ${auth}`,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      }
    );

    cachedToken = response.data.access_token;
    tokenTimestamp = ahora;
    return cachedToken;
  } catch (err) {
    console.error('Error al obtener token de Spotify:', err.message);
    throw err;
  }
}

module.exports = obtenerTokenSpotify;

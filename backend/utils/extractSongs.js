function extraerCancionesDeRespuesta(texto) {
  const lineas = texto.split('\n').map(line => line.trim()).filter(line => line);
  const canciones = [];

  for (let linea of lineas) {
    const match = linea.match(/^\d+\.\s*(.+?)\s*-\s*(.+)$/);
    if (match) {
      canciones.push({
        artista: match[1],
        titulo: match[2],
      });
    }
  }

  return canciones;
}

module.exports = extraerCancionesDeRespuesta;
class Cancion {
  final String id;
  final String nombre;
  final String artista;
  final String url;
  final String? preview;
  final String? imagen;

  Cancion({
    required this.id,
    required this.nombre,
    required this.artista,
    required this.url,
    this.preview,
    this.imagen,
  });

  factory Cancion.fromJson(Map<String, dynamic> json) {
    return Cancion(
      id: json['id'],
      nombre: json['nombre'],
      artista: json['artista'],
      url: json['url'],
      preview: json['preview'],
      imagen: json['imagen'],
    );
  }
}

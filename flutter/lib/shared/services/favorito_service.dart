import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tracktalk/shared/models/cancion_model.dart';
import 'package:tracktalk/shared/constants/api_config.dart';

class FavoritoService {
  static Future<bool> guardarFavorito(int usuarioId, Cancion cancion) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/favoritos');

    final body = jsonEncode({
      'usuario_id': usuarioId,
      'cancion': {
        'id': cancion.id,
        'nombre': cancion.nombre,
        'artista': cancion.artista,
        'url': cancion.url,
        'imagen_url': cancion.imagen,
        'preview_url': cancion.preview,
      },
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) return true;
    if (response.statusCode == 409) return false;

    throw Exception('Error al guardar favorito');
  }

  static Future<bool> eliminarFavorito(int usuarioId, String cancionId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/favoritos/delete');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario_id': usuarioId,
        'cancion_id': cancionId,
      }),
    );

    if (response.statusCode == 200) return true;
    if (response.statusCode == 404) return false;

    throw Exception('Error al eliminar favorito');
  }

  static Future<List<Cancion>> obtenerFavoritos(int usuarioId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/favoritos/$usuarioId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> favoritos = data['favoritos'];
      return favoritos.map((json) => Cancion.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener favoritos');
    }
  }
}

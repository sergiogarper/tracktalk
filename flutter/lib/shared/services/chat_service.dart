import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/respuesta_chat.dart';
import 'package:tracktalk/shared/constants/api_config.dart';

class ChatService {
  final String baseUrl = '${ApiConfig.baseUrl}/chat';

  Future<RespuestaChat> enviarMensaje({
    required int usuarioId,
    required String mensajeUsuario,
    int? chatId,
  }) async {
    final body = {
      'usuario_id': usuarioId,
      'mensaje_usuario': mensajeUsuario,
    };

    if (chatId != null) {
      body['chat_id'] = chatId;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/mensaje'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return RespuestaChat.fromJson(data);
    } else {
      throw Exception('Error al procesar el mensaje');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerHistorialChats(
      int usuarioId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/chat/historial/$usuarioId'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el historial');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerChatCompleto(
      int usuarioId, int chatId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/chat/completo/$usuarioId/$chatId'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el chat completo');
    }
  }
}

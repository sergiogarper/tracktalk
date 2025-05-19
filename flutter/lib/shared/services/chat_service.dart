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
}

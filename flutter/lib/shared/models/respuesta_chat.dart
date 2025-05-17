import 'cancion_model.dart';

class RespuestaChat {
  final int chatId;
  final String mensajeIA;
  final List<Cancion> canciones;

  RespuestaChat({
    required this.chatId,
    required this.mensajeIA,
    required this.canciones,
  });

  factory RespuestaChat.fromJson(Map<String, dynamic> json) {
    return RespuestaChat(
      chatId: json['chat_id'],
      mensajeIA: json['mensaje_ia'],
      canciones:
          (json['canciones'] as List).map((e) => Cancion.fromJson(e)).toList(),
    );
  }
}

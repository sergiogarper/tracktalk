import 'package:tracktalk/shared/models/cancion_model.dart';

class ChatMemory {
  static final List<Map<String, dynamic>> _messages = [];
  static int? _chatId;

  static List<Map<String, dynamic>> get messages => _messages;

  static int? get chatId => _chatId;
  static set chatId(int? id) => _chatId = id;

  static void addMessage(Map<String, dynamic> msg) {
    _messages.add(msg);
  }

  static void clearMessages() {
    _messages.clear();
    _chatId = null;
  }

  static void setMessages(List<dynamic> mensajes) {
    _messages.clear();
    for (var msg in mensajes) {
      _messages.add({
        'text': msg['text'],
        'isUser': msg['isUser'],
        'recomendaciones': msg['recomendaciones'] != null
            ? (msg['recomendaciones'] as List<dynamic>)
                .map((json) => Cancion.fromJson(json))
                .toList()
            : null,
      });
    }
  }
}

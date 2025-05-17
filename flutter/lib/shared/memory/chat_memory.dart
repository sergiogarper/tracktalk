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
    _chatId = null; // 🧹 resetea también el chatId cuando se reinicia
  }
}

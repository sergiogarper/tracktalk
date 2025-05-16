class ChatMemory {
  static final ChatMemory _instance = ChatMemory._internal();

  factory ChatMemory() {
    return _instance;
  }

  ChatMemory._internal();

  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  void addMessage(Map<String, dynamic> message) {
    _messages.add(message);
  }

  void clearMessages() {
    _messages.clear();
  }
}

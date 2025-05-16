import 'package:flutter/material.dart';
import 'package:tracktalk/shared/widgets/custom_bottom_navbar.dart';

import 'package:tracktalk/shared/memory/chat_memory.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final userMessage = _controller.text.trim();
    setState(() {
      ChatMemory().addMessage({
        'text': userMessage,
        'isUser': true,
      });
    });
    _controller.clear();

    _scrollToBottom();

    // SIMULACION TEMPORAL DEL BOT
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        ChatMemory().addMessage({
          'text':
              '🎶 ¡Por supuesto! Aquí tienes algunas recomendaciones musicales: \n\n1. "Sinfonía de la Aurora"\n2. "Ecos del Tiempo"\n3. "Melodías del Horizonte"\n4. "Armonía Celestial"\n5. "Ritmos del Universo"',
          'isUser': false,
        });
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFFFAF8F6),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      'assets/images/wallpaper.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icon.png',
                            height: 100,
                          ),
                          const Text(
                            'Chat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 54,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu, size: 42),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text(
                                'Opciones',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.chat),
                                    title: const Text('Nuevo chat'),
                                    onTap: () {
                                      setState(() {
                                        ChatMemory().clearMessages();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    // SIN FUNCIONALIDAD AUN
                                    leading: const Icon(Icons.history),
                                    title: const Text('Historial de chats'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: ChatMemory().messages.length,
                      itemBuilder: (context, index) {
                        final msg = ChatMemory().messages[index];
                        return Align(
                          alignment: msg['isUser']
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ChatBubble(
                            message: msg['text'],
                            isUser: msg['isUser'],
                            timestamp: DateTime.now(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ChatInputField(
                  controller: _controller,
                  onSend: _handleSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFF2E4E45) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isUser ? 18 : 0),
          bottomRight: Radius.circular(isUser ? 0 : 18),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 4.0,
        children: [
          Text(
            message,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
          Align(
            alignment: isUser ? Alignment.bottomLeft : Alignment.bottomRight,
            child: Text(
              '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                color: isUser ? Colors.white70 : Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Escribe aquí tu mensaje...',
                hintStyle: const TextStyle(letterSpacing: -1),
                filled: true,
                fillColor: const Color.fromRGBO(255, 255, 255, 0.9),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF2E4E45), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF2E4E45), width: 2.5),
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: const Color(0xFF2E4E45),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}

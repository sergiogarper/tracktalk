// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracktalk/shared/memory/chat_memory.dart';
import 'package:tracktalk/shared/services/chat_service.dart';
import 'package:tracktalk/shared/widgets/custom_bottom_navbar.dart';
import 'package:tracktalk/shared/models/usuario_global.dart';
import 'package:tracktalk/shared/models/respuesta_chat.dart';
import 'package:tracktalk/shared/models/cancion_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final ChatService chatService = ChatService();
  bool esperandoRespuesta = false;

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

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToBottom();
  }

  void _handleSendMessage() async {
    if (_controller.text.trim().isEmpty || UsuarioGlobal.id == null) return;

    final userMessage = _controller.text.trim();
    setState(() {
      ChatMemory.addMessage({'text': userMessage, 'isUser': true});
      _controller.clear();
      esperandoRespuesta = true;
    });

    _scrollToBottom();

    try {
      final RespuestaChat respuesta = await chatService.enviarMensaje(
        usuarioId: UsuarioGlobal.id!,
        mensajeUsuario: userMessage,
        chatId: ChatMemory.chatId,
      );

      setState(() {
        ChatMemory.addMessage({
          'text': respuesta.mensajeIA,
          'isUser': false,
          'recomendaciones': respuesta.canciones,
        });
        ChatMemory.chatId ??= respuesta.chatId;
        esperandoRespuesta = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        ChatMemory.addMessage({
          'text': '⚠️ Hubo un error al procesar tu mensaje.',
          'isUser': false,
        });
        esperandoRespuesta = false;
      });
    }
    _scrollToBottom();
  }

  Widget buildRecommendationCard(Cancion cancion, BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/player', extra: {
        'cancion': cancion,
        'from': 'chat',
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(246, 248, 243, 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cancion.imagen != null
                  ? Image.network(
                      cancion.imagen!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/default_cover.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cancion.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cancion.artista,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.play_circle_fill),
              iconSize: 40,
              color: const Color(0xFF2E4E45),
              onPressed: () => context.push('/player', extra: {
                'cancion': cancion,
                'from': 'chat',
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Container(color: const Color(0xFFFAF8F6)),
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
                      left: 10, right: 20, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Image.asset('assets/images/icon.png', height: 100),
                        const Text(
                          'Chat',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 54,
                          ),
                        ),
                      ]),
                      IconButton(
                        icon: const Icon(Icons.menu, size: 42),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text('Opciones',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.chat),
                                    title: const Text('Nuevo chat'),
                                    onTap: () {
                                      setState(() {
                                        ChatMemory.clearMessages();
                                        ChatMemory.chatId = null;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.history),
                                    title: const Text('Historial de chats'),
                                    onTap: () async {
                                      final userId = UsuarioGlobal.id;
                                      if (userId == null) return;

                                      try {
                                        final historial = await chatService
                                            .obtenerHistorialChats(userId);
                                        Navigator.of(context).pop();

                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Historial de chats'),
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: historial.length,
                                                itemBuilder: (context, index) {
                                                  final chat = historial[index];
                                                  final fecha = DateTime.parse(
                                                      chat['fecha']);
                                                  final chatId =
                                                      chat['chat_id'];

                                                  return ListTile(
                                                    leading: const Icon(Icons
                                                        .chat_bubble_outline),
                                                    title: Text(
                                                        'Chat del ${fecha.day}/${fecha.month} - ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}'),
                                                    onTap: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      final completo =
                                                          await chatService
                                                              .obtenerChatCompleto(
                                                                  userId,
                                                                  chatId);
                                                      setState(() {
                                                        ChatMemory.chatId =
                                                            chatId;
                                                        ChatMemory.setMessages(
                                                            completo);
                                                      });

                                                      _scrollToBottom();
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Error al cargar el historial')),
                                        );
                                      }
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
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        ...ChatMemory.messages.map((msg) {
                          final isUser = msg['isUser'] as bool;
                          final text = msg['text'] as String;
                          final List<Cancion>? recomendaciones =
                              msg['recomendaciones'] as List<Cancion>?;

                          return Column(
                            crossAxisAlignment: isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              ChatBubble(
                                message: text,
                                isUser: isUser,
                                timestamp: DateTime.now(),
                              ),
                              if (!isUser && recomendaciones != null)
                                ...recomendaciones.map((cancion) =>
                                    buildRecommendationCard(cancion, context)),
                            ],
                          );
                        }),
                        if (esperandoRespuesta)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'TrackTalk está escribiendo...',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                ChatInputFieldWidget(
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

class ChatInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputFieldWidget({
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

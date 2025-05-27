import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracktalk/shared/models/cancion_model.dart';
import 'package:tracktalk/shared/models/usuario_global.dart';
import 'package:tracktalk/shared/services/favorito_service.dart';
import 'package:tracktalk/shared/widgets/custom_bottom_navbar.dart';
import 'package:tracktalk/shared/memory/chat_memory.dart';
import 'package:tracktalk/shared/memory/player_memory.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Cancion> favoritos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    try {
      if (UsuarioGlobal.id != null) {
        final canciones =
            await FavoritoService.obtenerFavoritos(UsuarioGlobal.id!);
        setState(() {
          favoritos = canciones;
          cargando = false;
        });
      }
    } catch (_) {
      setState(() => cargando = false);
    }
  }

  String _tituloSinArtista(String nombre) {
    return nombre.split(' - ').first.trim();
  }

  Widget buildFavoriteCard(Cancion cancion, BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/player', extra: {
        'cancion': cancion,
        'from': 'home',
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
              child: Image.network(
                cancion.imagen!,
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
                    _tituloSinArtista(cancion.nombre),
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
                'from': 'home',
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userName = UsuarioGlobal.nombre ?? 'usuario';
    final String avatarUrl =
        'https://robohash.org/$userName/?set=set5&size=200x200';

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0, top: 10.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/icon.png', height: 100),
                            const Text(
                              'Mi perfil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text('Opciones'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.logout),
                                      title: const Text('Cerrar sesión'),
                                      onTap: () {
                                        ChatMemory.clearMessages();
                                        UsuarioGlobal.reset();
                                        PlayerMemory.limpiar();
                                        Navigator.of(context).pop();
                                        context.go('/login');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings,
                              size: 36, color: Color(0xFF2E4E45)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(129, 156, 122, 0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(4),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(avatarUrl),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '👋 Hola, $userName!',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Tus favoritas',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (cargando)
                    const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                  else if (favoritos.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          '¡Aún no tienes canciones favoritas! 😔 \nAgrega algunas para verlas aquí.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: favoritos.length,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        itemBuilder: (context, index) =>
                            buildFavoriteCard(favoritos[index], context),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

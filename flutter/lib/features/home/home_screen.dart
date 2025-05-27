import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracktalk/shared/memory/chat_memory.dart';
import 'package:tracktalk/shared/memory/player_memory.dart';
import 'package:tracktalk/shared/widgets/custom_bottom_navbar.dart';

import 'package:tracktalk/shared/models/usuario_global.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SIMULACIÓN DE FAVORITOS DEL USUARIO hasta aplicar backend
    final List<Map<String, String>> favorites = [
      {
        'image': 'assets/images/song-covers/song1.png',
        'title': 'Cinnamon Curls',
        'artist': 'Tom Misch',
      },
      {
        'image': 'assets/images/song-covers/song2.png',
        'title': '7 Days',
        'artist': 'Craig David',
      },
      {
        'image': 'assets/images/song-covers/song3.png',
        'title': 'Messy in Heaven',
        'artist': 'Venbee & Goddard',
      },
      {
        'image': 'assets/images/song-covers/song4.png',
        'title': 'Trash - Demo',
        'artist': 'Artemas',
      },
      {
        'image': 'assets/images/song-covers/song5.jpeg',
        'title': 'Loving is easy',
        'artist': 'Rex Orange County, Benny Sings',
      },
      {
        'image': 'assets/images/song-covers/song6.jpeg',
        'title': 'Hey girl',
        'artist': 'boy pablo',
      },
    ];

    final String userName = UsuarioGlobal.nombre ?? 'usuario';
    final String avatarUrl =
        'https://robohash.org/$userName/?set=set5&size=200x200';

    return Scaffold(
      body: Stack(
        children: [
          // Fondo de pantalla
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/icon.png',
                              height: 100,
                            ),
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
                                title: const Text(
                                  'Opciones',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          icon: const Icon(
                            Icons.settings,
                            color: Color(0xFF2E4E45),
                            size: 36,
                          ),
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
                                color: Color.fromRGBO(0, 0, 0, 0.25),
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
                  if (favorites.isEmpty)
                    Expanded(
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
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: favorites.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              itemBuilder: (context, index) {
                                final song = favorites[index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(246, 248, 243, 1),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            const Color.fromRGBO(0, 0, 0, 0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          song['image']!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song['title']!,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              song['artist']!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.play_circle_fill),
                                        iconSize: 40,
                                        color: const Color(0xFF2E4E45),
                                        onPressed: () {
                                          context.go('/player');
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tracktalk/shared/models/cancion_model.dart';
import 'package:tracktalk/shared/widgets/custom_bottom_navbar.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracktalk/shared/memory/player_memory.dart';
import 'package:tracktalk/shared/services/favorito_service.dart';
import 'package:tracktalk/shared/models/usuario_global.dart';

class PlayerScreen extends StatefulWidget {
  final Cancion? cancion;
  final String from;

  const PlayerScreen({super.key, this.cancion, required this.from});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  double _currentValue = 0;
  bool _isPlaying = false;
  Cancion? cancionActual;
  bool esFavorita = false;

  @override
  void initState() {
    super.initState();

    if (widget.cancion != null) {
      PlayerMemory.guardar(widget.cancion!, 0, true);
      PlayerMemory.posicion = 0;
    }

    cancionActual = widget.cancion ?? PlayerMemory.ultimaCancion;

    if (cancionActual != null) {
      _playPreview(cancionActual!, startAt: PlayerMemory.posicion);
      _currentValue = PlayerMemory.posicion;
      _isPlaying = PlayerMemory.estabaReproduciendo;

      _player.onPositionChanged.listen((Duration position) {
        setState(() {
          _currentValue = position.inSeconds.toDouble().clamp(0, 30);
        });
      });

      _player.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
          _currentValue = 0;
        });
      });
      _comprobarFavorito();
    }
  }

  Future<void> _comprobarFavorito() async {
    if (UsuarioGlobal.id == null || cancionActual == null) return;

    final favoritos = await FavoritoService.obtenerFavoritos(UsuarioGlobal.id!);
    final esta = favoritos.any((fav) => fav.id == cancionActual!.id);
    setState(() => esFavorita = esta);
  }

  void _playPreview(Cancion cancion, {double startAt = 0}) async {
    final previewUrl = cancion.preview;
    if (previewUrl != null && previewUrl.isNotEmpty) {
      await _player.play(UrlSource(previewUrl));
      await _player.seek(Duration(seconds: startAt.toInt()));
      setState(() => _isPlaying = true);
    }
  }

  void _pausePreview() async {
    await _player.pause();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    if (cancionActual != null) {
      PlayerMemory.guardar(cancionActual!, _currentValue, _isPlaying);
    }
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(double seconds) {
    final int totalSeconds = seconds.floor();
    final minutes = (totalSeconds ~/ 60).toString().padLeft(1, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _seekTo(double seconds) {
    _player.seek(Duration(seconds: seconds.toInt()));
  }

  String _tituloSinArtista(String nombre) {
    return nombre.split(' - ').first.trim();
  }

  @override
  Widget build(BuildContext context) {
    final c = cancionActual;
    final hayCancion = c != null;

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F6),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/wallpaper.webp',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 32),
                      onPressed: () {
                        if (widget.from == 'chat') {
                          context.go('/chat');
                        } else {
                          context.go('/home');
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.8,
                      maxHeight: screenWidth * 0.8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: hayCancion && c.imagen != null
                          ? Image.network(
                              c.imagen!,
                              fit: BoxFit.cover,
                            )
                          : Opacity(
                              opacity: 0,
                              child: Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final title = hayCancion
                          ? _tituloSinArtista(c.nombre)
                          : 'Sin canción seleccionada';

                      final textPainter = TextPainter(
                        text: TextSpan(
                          text: title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout(maxWidth: constraints.maxWidth);

                      final isOverflowing = textPainter.didExceedMaxLines;

                      return SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: isOverflowing
                            ? Marquee(
                                text: title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                                scrollAxis: Axis.horizontal,
                                blankSpace: 40.0,
                                velocity: 30.0,
                                pauseAfterRound: Duration(seconds: 2),
                                startPadding: 10.0,
                                accelerationDuration: Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration:
                                    Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              )
                            : Text(
                                title,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      hayCancion
                          ? c.artista
                          : 'Selecciona una antes de reproducir',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          esFavorita ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xFF2E4E45),
                          size: 32,
                        ),
                        onPressed: hayCancion
                            ? () async {
                                if (UsuarioGlobal.id == null || c.id.isEmpty) {
                                  return;
                                }

                                try {
                                  if (esFavorita) {
                                    await FavoritoService.eliminarFavorito(
                                        UsuarioGlobal.id!, c.id);
                                    setState(() => esFavorita = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Eliminado de favoritos')),
                                    );
                                  } else {
                                    final exito =
                                        await FavoritoService.guardarFavorito(
                                            UsuarioGlobal.id!, c);
                                    if (exito) {
                                      setState(() => esFavorita = true);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Añadido a favoritos')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Ya estaba en favoritos')),
                                      );
                                    }
                                  }
                                } catch (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Error al modificar favorito')),
                                  );
                                }
                              }
                            : null,
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.spotify,
                          size: 28,
                          color: hayCancion
                              ? const Color(0xFF2E4E45)
                              : Colors.grey,
                        ),
                        onPressed: hayCancion && c.url != null
                            ? () async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Abriendo Spotify...'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                final Uri spotifyUrl = Uri.parse(c.url!);
                                if (await canLaunchUrl(spotifyUrl)) {
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  await launchUrl(spotifyUrl,
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'No se pudo abrir el enlace de Spotify'),
                                    ),
                                  );
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Slider(
                        value: _currentValue,
                        min: 0,
                        max: 30,
                        onChanged: hayCancion
                            ? (value) {
                                _seekTo(value);
                              }
                            : null,
                        activeColor: const Color(0xFF2E4E45),
                        inactiveColor: const Color.fromRGBO(46, 78, 69, 0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(_currentValue),
                                style: const TextStyle(fontSize: 16)),
                            const Text('0:30', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_5, size: 50),
                        color: const Color(0xFF2E4E45),
                        onPressed: hayCancion
                            ? () {
                                final newTime =
                                    (_currentValue - 5).clamp(0, 30).toDouble();
                                _seekTo(newTime);
                                setState(() {
                                  _currentValue = newTime;
                                });
                              }
                            : null,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 60,
                        ),
                        color: const Color(0xFF2E4E45),
                        onPressed: hayCancion
                            ? () {
                                _isPlaying ? _pausePreview() : _playPreview(c);
                              }
                            : null,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.forward_5, size: 50),
                        color: const Color(0xFF2E4E45),
                        onPressed: hayCancion
                            ? () {
                                final newTime =
                                    (_currentValue + 5).clamp(0, 30).toDouble();
                                _seekTo(newTime);
                                setState(() {
                                  _currentValue = newTime;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    hayCancion
                        ? 'Reproduciendo preview'
                        : 'Sin preview disponible',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      letterSpacing: -0.5,
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

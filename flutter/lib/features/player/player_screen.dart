import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tracktalk/shared/models/cancion_model.dart';
import 'package:tracktalk/shared/widgets/custom_bottom_navbar.dart';

class PlayerScreen extends StatefulWidget {
  final Cancion? cancion;

  const PlayerScreen({super.key, this.cancion});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  double _currentValue = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.cancion != null) {
      _playPreview();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    }
  }

  void _playPreview() async {
    final previewUrl = widget.cancion?.preview;
    if (previewUrl != null && previewUrl.isNotEmpty) {
      await _player.play(UrlSource(previewUrl));
      setState(() => _isPlaying = true);
    }
  }

  void _pausePreview() async {
    await _player.pause();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.cancion;
    final hayCancion = c != null;

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
                        context.go('/home');
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      image: hayCancion && c.imagen != null
                          ? DecorationImage(
                              image: NetworkImage(c.imagen!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                  'assets/images/song-covers/placeholder.png'),
                              fit: BoxFit.cover,
                            ),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    hayCancion ? c.nombre : 'Sin canción seleccionada',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hayCancion
                        ? c.artista
                        : 'Selecciona una antes de reproducir',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border, size: 28),
                        onPressed: hayCancion ? () {} : null,
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: const Icon(Icons.share, size: 28),
                        onPressed: hayCancion ? () {} : null,
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
                                setState(() {
                                  _currentValue = value;
                                });
                              }
                            : null,
                        activeColor: const Color(0xFF2E4E45),
                        inactiveColor: const Color.fromRGBO(46, 78, 69, 0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('0:00', style: TextStyle(fontSize: 16)),
                            Text('0:30', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 40),
                        color: const Color(0xFF2E4E45),
                        onPressed: hayCancion ? () {} : null,
                      ),
                      const SizedBox(width: 30),
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
                                _isPlaying ? _pausePreview() : _playPreview();
                              }
                            : null,
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 40),
                        color: const Color(0xFF2E4E45),
                        onPressed: hayCancion ? () {} : null,
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

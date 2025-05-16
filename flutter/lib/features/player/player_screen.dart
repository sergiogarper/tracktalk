import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracktalk/shared/widgets/custom_bottom_navbar.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double _currentValue = 0; // Valor del slider

  @override
  Widget build(BuildContext context) {
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
                      image: const DecorationImage(
                        image:
                            AssetImage('assets/images/song-covers/song1.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Cinnamon Curls',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tom Misch',
                    style: TextStyle(
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
                        onPressed: () {},
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: const Icon(Icons.share, size: 28),
                        onPressed: () {},
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
                        onChanged: (value) {
                          setState(() {
                            _currentValue = value;
                          });
                        },
                        activeColor: const Color(0xFF2E4E45),
                        inactiveColor: const Color.fromRGBO(46, 78, 69, 0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0:${_currentValue.toInt().toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Text(
                              '0:30',
                              style: TextStyle(fontSize: 16),
                            ),
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
                        onPressed: () {},
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Icons.pause_circle_filled, size: 60),
                        color: const Color(0xFF2E4E45),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 40),
                        color: const Color(0xFF2E4E45),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Reproduciendo preview',
                    style: TextStyle(
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

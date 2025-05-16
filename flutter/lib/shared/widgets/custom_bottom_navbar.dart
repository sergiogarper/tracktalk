import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF2E4E45);
    const Color background = Color(0xB3F6F8F3);
    const Color indicatorColor = Color(0xFF2E4E45);

    return Container(
      decoration: BoxDecoration(
        color: background,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: green,
        unselectedItemColor: Color.fromRGBO(46, 78, 69, 0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/player');
              break;
            case 1:
              context.go('/chat');
              break;
            case 2:
              context.go('/home');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.headset, size: 48),
                if (currentIndex == 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Opacity(
                    opacity: currentIndex == 1 ? 1.0 : 0.5,
                    child: Image.asset(
                      currentIndex == 1
                          ? 'assets/images/icon.png'
                          : 'assets/images/icon-desat.webp',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (currentIndex == 1)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E4E45),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_outline, size: 48),
                if (currentIndex == 2)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

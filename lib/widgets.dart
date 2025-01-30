import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF1E3A5F), // Varsayılan renk
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      splashColor: const Color.fromRGBO(255, 255, 255, 0.3),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const MainMenuButton({super.key, 
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      title: title,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: const Color(0xFF1E3A5F), // Ana Menü için mavi renk
    );
  }
}

class GameModeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const GameModeButton({super.key, 
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      title: title,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: Colors.green, // Oyun modu butonları için yeşil renk
    );
  }
}

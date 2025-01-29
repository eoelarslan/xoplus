import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const MainMenuButton({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title, style: const TextStyle(fontSize: 20)),
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
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
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title, style: const TextStyle(fontSize: 20)),
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
    );
  }
}

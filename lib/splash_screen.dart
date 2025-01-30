import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(_fadeRoute(const HomePage()));
    });
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9C27B0),  // Açık mor
            Color(0xFF4A148C),  // Koyu mor
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,  // Scaffold'ın arka planını transparent yapıyoruz
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/xoplus_splash_screen.jpeg',
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                'XOPlus',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF121212),
                   
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Color(0xFF121212)),
            ],
          ),
        ),
      ),
    );
  }
}
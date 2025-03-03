import 'package:flutter/material.dart';
import 'dart:async';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int dotCount = 0;

  @override
  void initState() {
    super.initState();

    // Start animation for dots
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        dotCount = (dotCount + 1) % 4; // Cycles between 0, 1, 2, 3 dots
      });
    });

    // Navigate to Welcome Page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "GAME ARCADE" text in gaming-style font
            const Text(
              'GAME ARCADE',
              style: TextStyle(
                fontSize: 40, // Bigger text
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily:
                    'PressStart2P', // Gaming-style font (add in pubspec.yaml)
              ),
            ),

            const SizedBox(height: 20),

            // Orange glowing dots animation
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity:
                        index < dotCount ? 1.0 : 0.2, // Show dots gradually
                    child: Container(
                      width: 12, // Bigger dots
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withAlpha(
                              (0.8 * 255).toInt(),
                            ), // Correct fix for opacity
                            blurRadius: 8, // Glow effect
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
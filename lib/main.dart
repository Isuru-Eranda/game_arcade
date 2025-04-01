import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_arcade/firebase_options.dart';
import 'package:game_arcade/screens/home_screen.dart';
import 'package:game_arcade/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:game_arcade/controllers/auth_controller.dart';
import 'package:game_arcade/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const GameArcadeApp(),
    ),
  );
}

class GameArcadeApp extends StatelessWidget {
  const GameArcadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Arcade',
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

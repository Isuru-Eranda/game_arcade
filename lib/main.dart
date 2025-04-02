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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF200E12), Color(0xFF000000)],
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Game Arcade',
        theme: ThemeData(
          fontFamily: 'Jersey10',
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          primaryColor: Colors.orange,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            background: Colors.transparent,
            surface: Colors.transparent,
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

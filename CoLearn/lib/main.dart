import 'package:colearn/views/splash/splash.dart';
import 'package:colearn/views/auth/login.dart'; // Import Login
import 'package:colearn/views/auth/signup.dart'; // Import Signup
import 'package:colearn/views/home/home.dart';   // Import Home
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'consts/consts.dart';

/// Point d'entrée de l'application Flutter.
void main() {
  runApp(const MyApp());
}

/// Widget racine de l'application.
///
/// Configure GetX, le thème global (font, couleurs) et les routes nommées.
/// Démarre sur le `SplashScreen`.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        fontFamily: regular,
      ),
      // Start with the Splash Screen
      home: const SplashScreen(),

      // Define the Named Routes here
      getPages: [
        GetPage(name: '/LoginScreen', page: () => const LoginScreen()),
        GetPage(name: '/SignupScreen', page: () => const SignupScreen()),
        GetPage(name: '/HomeScreen', page: () => const HomeScreen()),
      ],
    );
  }
}
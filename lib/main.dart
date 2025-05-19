import 'package:crypto_project/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(CipherApp());

class CipherApp extends StatelessWidget {
  const CipherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cipher Tools',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1E1E2C),
        primaryColor: Colors.deepPurple,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

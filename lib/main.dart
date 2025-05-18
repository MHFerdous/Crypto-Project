import 'package:crypto_project/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(CipherApp());

class CipherApp extends StatelessWidget {
  const CipherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cipher Tools',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121218),
        primaryColor: Colors.deepPurple,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:crypto_project/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pwnvemfifyatnytaerrq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3bnZlbWZpZnlhdG55dGFlcnJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg1NzUyNzIsImV4cCI6MjA1NDE1MTI3Mn0.EK9hzWvOlBMBLL0-R2YEGAXfRTSDq-jPl_XeDpMKRUE',
  );

  runApp(CipherApp());
}

class CipherApp extends StatelessWidget {
  const CipherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121218),
        primaryColor: Colors.deepPurple,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

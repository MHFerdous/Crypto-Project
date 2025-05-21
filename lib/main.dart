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
      /*theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121218),
        primaryColor: Colors.deepPurple,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),*/
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2C2C3E),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.red),
          ),
          disabledBorder: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

import 'package:crypto_project/screens/auth/login_screen.dart';
import 'package:crypto_project/screens/auth/sign_up_screen.dart';
import 'package:crypto_project/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pwnvemfifyatnytaerrq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3bnZlbWZpZnlhdG55dGFlcnJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg1NzUyNzIsImV4cCI6MjA1NDE1MTI3Mn0.EK9hzWvOlBMBLL0-R2YEGAXfRTSDq-jPl_XeDpMKRUE',
  );

 runApp(CipherApp());
}

class CipherApp extends StatelessWidget {
  const CipherApp({super.key});

  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('supabase_token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cipher Tools',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121218),
        primaryColor: Colors.deepPurple,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: FutureBuilder<bool>(
        future: checkToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data == true) {
            // return SignupScreen(); return here your landing page
          } else {
            return LoginScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:crypto_project/screens/auth/login_screen.dart';
import 'package:crypto_project/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> _logOut(BuildContext context) async {
  final navigator = Navigator.of(context);
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) =>
                          const Center(child: CircularProgressIndicator()),
                );

                await Future.delayed(const Duration(seconds: 2));

                try {
                  await Supabase.instance.client.auth.signOut();
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Logged out...')),
                  );
                  navigator.pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                } catch (e) {
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              },
              child: const Text('Yes'),
            ),
          ],
        ),
  );
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: Text('Cipher Tools'),
    backgroundColor: Colors.black,
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserProfileScreen()),
          );
        },
        icon: Icon(Icons.person_2_outlined),
      ),
      IconButton(
        onPressed: () {
          _logOut(context);
        },
        icon: Icon(Icons.logout),
      ),
    ],
  );
}

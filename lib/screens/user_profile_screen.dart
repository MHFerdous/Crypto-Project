import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: ${user?.email}', style: const TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'phone: ${user?.phone ?? 'unknown'}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Last Signin At: ${user?.lastSignInAt}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

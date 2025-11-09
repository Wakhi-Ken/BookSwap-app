import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/providers/auth_provider.dart';

/// Settings screen displaying user info and sign-out option
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 4, 63),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: ${user.email}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Display name: ${user.displayName ?? ''}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Notifications',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              value: true,
              onChanged: (v) {},
              title: const Text(
                'New offers (simulated)',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              activeThumbColor: const Color.fromARGB(255, 206, 202, 5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 11, 68),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await ref.read(authServiceProvider).signOut();
                },
                child: const Text('Sign out', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

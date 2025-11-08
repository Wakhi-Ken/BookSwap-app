import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/providers/auth_provider.dart';
import 'package:book_swap_app/theme/app_theme.dart'; // import universal colors

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppColors.blue)),
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: ${user.email}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Display name: ${user.displayName ?? ''}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Notifications',
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              value: true,
              onChanged: (v) {},
              title: const Text(
                'New offers (simulated)',
                style: TextStyle(color: Colors.white),
              ),
              activeColor: AppColors.blue,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/providers/auth_provider.dart';
import 'package:book_swap_app/theme/app_theme.dart'; // universal colors

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

/// State class for VerifyEmailScreen
class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _sending = false;
  bool _refreshing = false;

  /// Builds the VerifyEmailScreen UI
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text(
          'Verify Email',
          style: TextStyle(color: AppColors.blue),
        ),
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification email was sent to ${user?.email}. Please verify your email.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
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
                onPressed: _sending ? null : _resend,
                child: _sending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Resend verification',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 8),
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
                onPressed: _refreshing ? null : _refresh,
                child: _refreshing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'I have verified',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Resends the verification email
  Future<void> _resend() async {
    setState(() => _sending = true);
    try {
      await ref.read(authServiceProvider).currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification email sent')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending verification: $e')));
    } finally {
      setState(() => _sending = false);
    }
  }

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    await ref.read(authServiceProvider).reloadUser();
    setState(() => _refreshing = false);
  }
}

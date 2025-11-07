import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/providers/auth_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _sending = false;
  bool _refreshing = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification email was sent to ${user?.email}. Please verify your email.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sending ? null : _resend,
              child: _sending
                  ? const CircularProgressIndicator()
                  : const Text('Resend verification'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _refreshing ? null : _refresh,
              child: _refreshing
                  ? const CircularProgressIndicator()
                  : const Text('I have verified'),
            ),
          ],
        ),
      ),
    );
  }

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

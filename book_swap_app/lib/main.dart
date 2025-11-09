import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/providers/auth_provider.dart';
import 'package:book_swap_app/screens/login_screen.dart';
import 'package:book_swap_app/screens/home_screen.dart';
import 'package:book_swap_app/screens/verify_email_screen.dart';
import 'package:book_swap_app/theme/app_theme.dart';
import 'firebase_options.dart';

/// Entry point of the BookSwap application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: BookSwapApp()));
}

/// Main application widget for BookSwap
class BookSwapApp extends ConsumerWidget {
  const BookSwapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookSwap',
      theme: AppTheme.theme,
      home: authState.when(
        data: (user) {
          // User not logged in
          if (user == null) return const LoginScreen();

          // Google sign-in users are auto-verified
          if (user.providerData.any(
            (info) => info.providerId == 'google.com',
          )) {
            return const HomeScreen();
          }

          // For email/password sign-up users, check verification
          if (!user.emailVerified) return const VerifyEmailScreen();

          // Default to home if verified
          return const HomeScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) =>
            Scaffold(body: Center(child: Text('Authentication error: $error'))),
      ),
    );
  }
}

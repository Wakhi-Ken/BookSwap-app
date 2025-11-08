import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_swap_app/services/auth_service.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provides a single instance of [AuthService] across the app.
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Watches Firebase authentication state changes.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});

/// Provider for the currently logged-in Firebase user.
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.asData?.value;
});

/// Simple state notifier for login/signup progress.
final authLoadingProvider = StateProvider<bool>((ref) => false);

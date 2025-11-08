import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:book_swap_app/models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream of auth state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Currently logged-in user
  User? get currentUser => _auth.currentUser;

  /// --- SIGN UP (Email/Password) ---
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user!;
      await user.updateDisplayName(displayName);
      await user.sendEmailVerification();

      final userProfile = UserProfile(
        uid: user.uid,
        displayName: displayName,
        email: user.email ?? email,
        photoUrl: user.photoURL ?? '',
        createdAt: DateTime.now(),
      );
      await _db.collection('users').doc(user.uid).set(userProfile.toMap());
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseErrorMessage(e));
    } catch (e) {
      throw Exception("Sign-up failed: $e");
    }
  }

  /// --- SIGN IN (Email/Password) ---
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Sync Firestore profile if missing
      final user = credential.user!;
      final userDoc = _db.collection('users').doc(user.uid);
      final docSnap = await userDoc.get();
      if (!docSnap.exists) {
        final profile = UserProfile(
          uid: user.uid,
          displayName: user.displayName ?? '',
          email: user.email ?? email,
          photoUrl: user.photoURL ?? '',
          createdAt: DateTime.now(),
        );
        await userDoc.set(profile.toMap());
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseErrorMessage(e));
    } catch (e) {
      throw Exception("Sign-in failed: $e");
    }
  }

  /// --- GOOGLE SIGN-IN ---
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google Sign-In aborted');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user!;

      // Create Firestore profile if not exists
      final userDoc = _db.collection('users').doc(user.uid);
      final docSnap = await userDoc.get();
      if (!docSnap.exists) {
        final profile = UserProfile(
          uid: user.uid,
          displayName: user.displayName ?? 'Unnamed User',
          email: user.email ?? '',
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );
        await userDoc.set(profile.toMap());
      }

      return userCred;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// --- SIGN OUT ---
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// --- RELOAD USER ---
  Future<void> reloadUser() async => await _auth.currentUser?.reload();

  /// --- USER-FRIENDLY FIREBASE ERRORS ---
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}

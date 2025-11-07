import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/services/storage_service.dart';
import 'package:book_swap_app/repositories/book_repository.dart';
import 'package:book_swap_app/repositories/swap_repository.dart';
import 'package:book_swap_app/services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);
final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepository(
    ref.read(firestoreServiceProvider),
    ref.read(storageServiceProvider),
  ),
);
final swapRepositoryProvider = Provider<SwapRepository>(
  (ref) => SwapRepository(ref.read(firestoreServiceProvider)),
);


// =========================================================
// End of scaffold
// =========================================================


// Notes:
// - Add firebase_options.dart using `flutterfire configure` (FlutterFire CLI) or use your own FirebaseOptions.
// - This scaffold focuses on core flows. You should expand error handling, storage path retention, security rules, and refine UI to match the screenshot provided in your assignment.
// - Some DateTime/Timestamp conversions used simplistically; you may want to use FieldValue.serverTimestamp() in production.


// If you want, I can now:
// - Generate a ZIP of these files.
// - Expand any specific file with more features (detailed chat, accept/reject UI, better security rules).
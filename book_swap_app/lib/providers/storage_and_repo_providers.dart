import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/services/storage_service.dart';
import 'package:book_swap_app/repositories/book_repository.dart';
import 'package:book_swap_app/repositories/swap_repository.dart';
import 'package:book_swap_app/services/firestore_service.dart';

/// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

/// Storage service provider
final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);
final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepository(
    ref.read(firestoreServiceProvider),
    ref.read(storageServiceProvider),
  ),
);

/// Swap repository provider
final swapRepositoryProvider = Provider<SwapRepository>(
  (ref) => SwapRepository(ref.read(firestoreServiceProvider)),
);

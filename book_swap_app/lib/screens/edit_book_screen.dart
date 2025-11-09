import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/repositories/book_repository.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/widgets/image_input.dart';
import 'package:book_swap_app/providers/storage_and_repo_providers.dart';
import 'package:book_swap_app/theme/app_theme.dart';

/// Screen for creating or editing a book
class EditBookScreen extends ConsumerStatefulWidget {
  final Book? book;
  const EditBookScreen({this.book, super.key});

  @override
  ConsumerState<EditBookScreen> createState() => _EditBookScreenState();
}

/// State class for EditBookScreen
class _EditBookScreenState extends ConsumerState<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _author = '';
  String _condition = 'Good';
  File? _pickedImage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _title = widget.book!.title;
      _author = widget.book!.author;
      _condition = widget.book!.condition;
    }
  }

  /// Builds the EditBookScreen UI
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final repo = BookRepository(
      ref.read(firestoreServiceProvider),
      ref.read(storageServiceProvider),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          widget.book == null ? 'Create Book' : 'Edit Book',
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 10, 70),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 175, 164, 6)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (v) => _title = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _author,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                decoration: const InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (v) => _author = v,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _condition,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                dropdownColor: AppColors.black,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2,
                    ),
                  ),
                ),
                items: ['New', 'Like New', 'Good', 'Used', 'Worn']
                    .map(
                      (c) => DropdownMenuItem<String>(
                        value: c,
                        child: Text(
                          c,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => _condition = v!,
              ),
              const SizedBox(height: 12),
              ImageInput(onPick: (f) => setState(() => _pickedImage = f)),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator(
                      color: Color.fromARGB(255, 187, 207, 7),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _loading = true);
                          try {
                            if (widget.book == null) {
                              await repo.createBook(
                                ownerId: user.uid,
                                title: _title,
                                author: _author,
                                condition: _condition,
                                imageFile: _pickedImage,
                              );
                            } else {
                              final data = {
                                'title': _title,
                                'author': _author,
                                'condition': _condition,
                                'updatedAt': DateTime.now(),
                              };
                              await repo.updateBook(widget.book!.id, data);
                            }
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            setState(() => _loading = false);
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/repositories/book_repository.dart';
import 'package:book_swap_app/services/firestore_service.dart';
import 'package:book_swap_app/services/storage_service.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/widgets/image_input.dart';
import 'package:book_swap_app/providers/storage_and_repo_providers.dart';
import 'package:book_swap_app/theme/app_theme.dart'; // import universal colors

class EditBookScreen extends ConsumerStatefulWidget {
  final Book? book;
  const EditBookScreen({this.book, super.key});

  @override
  ConsumerState<EditBookScreen> createState() => _EditBookScreenState();
}

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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final repo = BookRepository(
      ref.read(firestoreServiceProvider),
      ref.read(storageServiceProvider),
    );

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          widget.book == null ? 'Create Book' : 'Edit Book',
          style: const TextStyle(color: AppColors.blue),
        ),
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: AppColors.blue),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue, width: 2),
                  ),
                ),
                onChanged: (v) => _title = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _author,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(color: AppColors.blue),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue, width: 2),
                  ),
                ),
                onChanged: (v) => _author = v,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _condition,
                style: const TextStyle(color: Colors.white),
                dropdownColor: AppColors.black,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  labelStyle: TextStyle(color: AppColors.blue),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue, width: 2),
                  ),
                ),
                items: ['New', 'Like New', 'Good', 'Used']
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c,
                          style: const TextStyle(color: Colors.white),
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
                  ? const CircularProgressIndicator(color: AppColors.blue)
                  : SizedBox(
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

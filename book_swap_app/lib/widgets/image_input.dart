import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget to pick an image from the gallery and display it.
class ImageInput extends StatefulWidget {
  final void Function(File) onPick;
  const ImageInput({required this.onPick, super.key});

  /// Creates state for ImageInput
  @override
  State<ImageInput> createState() => _ImageInputState();
}

/// State class for ImageInput
class _ImageInputState extends State<ImageInput> {
  File? _picked;
  final ImagePicker _picker = ImagePicker();

  /// Handles image picking from gallery
  Future<void> _pick() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
    );
    if (x == null) return;
    final f = File(x.path);
    setState(() => _picked = f);
    widget.onPick(f);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_picked != null)
          Image.file(_picked!, height: 140, fit: BoxFit.cover),
        TextButton.icon(
          onPressed: _pick,
          icon: const Icon(Icons.image),
          label: const Text('Pick Image'),
        ),
      ],
    );
  }
}

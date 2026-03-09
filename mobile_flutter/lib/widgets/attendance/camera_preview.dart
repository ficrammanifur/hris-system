import 'dart:io';
import 'package:flutter/material.dart';

class CameraPreview extends StatelessWidget {
  final File? photo;
  final VoidCallback onTap;

  const CameraPreview({super.key, this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          image: photo != null
              ? DecorationImage(image: FileImage(photo!), fit: BoxFit.cover)
              : null,
        ),
        child: photo == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_rounded, size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('Tap to take selfie', style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              )
            : null,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'capture_review_screen.dart';
import 'slip_groups_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (file == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CaptureReviewScreen(imageFile: File(file.path)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LekAI")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              icon: Icons.camera,
              text: "Open Camera",
              onTap: () => _handleImage(context, ImageSource.camera),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              icon: Icons.photo,
              text: "Open Gallery",
              onTap: () => _handleImage(context, ImageSource.gallery),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SlipGroupsScreen()),
              ),
              child: const Text("View Saved Slips"),
            ),
          ],
        ),
      ),
    );
  }
}

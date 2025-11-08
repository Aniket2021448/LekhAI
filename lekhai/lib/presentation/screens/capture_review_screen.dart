import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/services/ocr_service.dart';
import '../../../data/services/gemini_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/slip.dart';

class CaptureReviewScreen extends StatefulWidget {
  final File imageFile;
  const CaptureReviewScreen({super.key, required this.imageFile});

  @override
  State<CaptureReviewScreen> createState() => _CaptureReviewScreenState();
}

class _CaptureReviewScreenState extends State<CaptureReviewScreen> {
  bool loading = false;

  Future<void> processSlip() async {
    setState(() => loading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ocr = OCRService();
      final gemini = GeminiService();
      final storage = StorageService();

      final rawText = await ocr.extractTextFromFile(widget.imageFile.path);

      // Show a tiny preview in logs (optional)
      // debugPrint('OCR first 200 chars: ${rawText.substring(0, rawText.length.clamp(0, 200))}');

      final structured = await gemini.convertToStructured(rawText);

      final customer =
          (structured['customer_name'] ?? 'Unknown').toString().trim().isEmpty
          ? 'Unknown'
          : structured['customer_name'].toString();

      final parsedDate =
          DateTime.tryParse(structured['date']?.toString() ?? '') ??
          DateTime.now();

      final savedPath = await storage.saveSlipImage(
        widget.imageFile,
        customer,
        parsedDate,
      );

      final slip = Slip(
        customerName: customer,
        date: parsedDate,
        imagePath: savedPath,
        structuredData: structured,
      );

      await storage.saveSlip(slip);

      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Saved!')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Could not parse receipt. Saved to “Unsorted”. ($e)'),
        ),
      );

      // Fallback: still save the image under Unknown so user doesn’t lose it
      try {
        final storage = StorageService();
        final savedPath = await storage.saveSlipImage(
          widget.imageFile,
          'Unknown',
          DateTime.now(),
        );
        final slip = Slip(
          customerName: 'Unknown',
          date: DateTime.now(),
          imagePath: savedPath,
          structuredData: {'error': e.toString()},
        );
        await storage.saveSlip(slip);
      } catch (_) {
        /* ignore secondary failure */
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Slip")),
      body: Column(
        children: [
          Expanded(child: Image.file(widget.imageFile, fit: BoxFit.cover)),
          loading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: processSlip,
                      child: const Text("Recognize & Save"),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

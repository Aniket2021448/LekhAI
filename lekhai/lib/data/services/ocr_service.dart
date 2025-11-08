import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  /// Extract text from image (English + Hindi / Hinglish)
  Future<String> extractTextFromFile(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);

    // Latin (English / Hinglish / Numbers)
    final latinRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    // Devanagari (Hindi / Marathi)
    final devRecognizer = TextRecognizer(
      script: TextRecognitionScript.devanagiri,
    );

    final latinResult = await latinRecognizer.processImage(inputImage);
    final devResult = await devRecognizer.processImage(inputImage);

    latinRecognizer.close();
    devRecognizer.close();

    // Merge & clean
    final merged = "${latinResult.text}\n${devResult.text}".trim();
    final uniqueLines = merged
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet() // remove duplicates
        .toList();

    return uniqueLines.join('\n');
  }
}

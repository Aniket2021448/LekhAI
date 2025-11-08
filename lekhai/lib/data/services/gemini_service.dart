import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/json_utils.dart';

class GeminiService {
  // TODO: put your API key in a secure place (env/remote)
  static const apiKey = 'AIzaSyC7RP_aPGBlfatHr9cgvreRh2CDFzKlkMQ';

  // Minimal, stable schema you want back
  static const _schemaHint = '''
You are an extraction service. Return ONLY JSON, no commentary.
Use this JSON schema:
{
  "customer_name": "string",
  "date": "ISO8601 string (yyyy-MM-dd or full timestamp)",
  "total": "number | null",
  "items": [
    {"name": "string", "qty": "number|null", "price": "number|null"}
  ]
}
''';

  Future<Map<String, dynamic>> convertToStructured(String ocrText) async {
    // If your SDK supports response_mime_type, use it. Otherwise strong instruction above.
    final prompt =
        '''
$_schemaHint

Extract data from this text (may be English/Hindi/Hinglish):
---
$ocrText
---
Only output JSON.
''';

    // Example with REST (adjust endpoint if using SDK)
    final uri = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
    );

    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
      // If available in your chosen endpoint:
      // "generationConfig": {"responseMimeType": "application/json"}
    };

    final resp = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (resp.statusCode != 200) {
      // Never crash — return minimal structure and attach raw response
      return {
        "customer_name": "Unknown",
        "date": DateTime.now().toIso8601String(),
        "raw_error": "HTTP ${resp.statusCode}",
        "raw_body": resp.body,
      };
    }

    // Pull model text (this depends on the endpoint’s response shape)
    final decoded = jsonDecode(resp.body);
    final candidates = decoded['candidates'] as List?;
    final text = (candidates != null && candidates.isNotEmpty)
        ? (candidates.first['content']?['parts']?[0]?['text'] ?? '').toString()
        : '';

    // Robust JSON extraction
    final map = safeDecodeToMap(text);

    // Ensure required fields exist so app doesn’t crash
    map.putIfAbsent('customer_name', () => 'Unknown');
    map.putIfAbsent('date', () => DateTime.now().toIso8601String());
    map.putIfAbsent('items', () => <dynamic>[]);
    map.putIfAbsent('total', () => null);

    return map;
  }
}

import 'dart:convert';

/// Strips common wrappers (```json fences, whitespace)
String _stripFences(String s) {
  var out = s.trim();
  if (out.startsWith('```')) {
    // remove triple backticks fences
    final first = out.indexOf('\n');
    if (first != -1) out = out.substring(first + 1);
    final lastFence = out.lastIndexOf('```');
    if (lastFence != -1) out = out.substring(0, lastFence);
    out = out.trim();
  }
  return out;
}

/// Attempts jsonDecode; if it fails, tries to locate the first well-formed
/// {...} or [...] block by brace matching.
Map<String, dynamic> safeDecodeToMap(String raw) {
  final cleaned = _stripFences(raw);

  // First, a straight attempt.
  try {
    final decoded = jsonDecode(cleaned);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is List) return {'data': decoded};
  } catch (_) {
    /* fallthrough */
  }

  // Brace-matching fallback for JSON object
  final obj = _extractBalanced(cleaned, '{', '}');
  if (obj != null) {
    try {
      final decoded = jsonDecode(obj);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is List) return {'data': decoded};
    } catch (_) {
      /* fallthrough */
    }
  }

  // Brace-matching fallback for JSON array
  final arr = _extractBalanced(cleaned, '[', ']');
  if (arr != null) {
    try {
      final decoded = jsonDecode(arr);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is List) return {'data': decoded};
    } catch (_) {
      /* fallthrough */
    }
  }

  // Last resort: return minimal structure so app doesn't crash
  return {
    'customer_name': 'Unknown',
    'date': DateTime.now().toIso8601String(),
    'raw': raw,
  };
}

/// Returns first balanced block between open/close, or null.
String? _extractBalanced(String s, String open, String close) {
  int start = -1, depth = 0;
  for (int i = 0; i < s.length; i++) {
    final ch = s[i];
    if (ch == open) {
      if (depth == 0) start = i;
      depth++;
    } else if (ch == close) {
      if (depth > 0) {
        depth--;
        if (depth == 0 && start != -1) {
          return s.substring(start, i + 1);
        }
      }
    }
  }
  return null;
}

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Classe pour interagir avec l'API Gemini/IA (Google Gemini)
/// Adapte l'URL et la clé API selon ton fournisseur.
/// Intégration réelle avec l'API Gemini Pro (Google AI)
/// Voir la doc officielle : https://ai.google.dev/gemini-api/docs/get-started/rest
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiChatApi {
  final String apiKey;
  final String apiUrl;

  GeminiChatApi({required this.apiKey, required this.apiUrl});

  /// Envoie un message à Gemini Pro et récupère la réponse textuelle
  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey, 
      },
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': message}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Parsing Gemini: la réponse est dans data['candidates'][0]['content']['parts'][0]['text']
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        if (content != null && content['parts'] != null && content['parts'].isNotEmpty) {
          return content['parts'][0]['text'] ?? 'Réponse IA vide';
        }
      }
      return 'Réponse IA non comprise (format inattendu)';
    } else {
      String msg = 'Erreur API: ${response.statusCode}';
      try {
        final err = jsonDecode(response.body);
        msg += '\n${err['error']?['message'] ?? ''}';
      } catch (_) {}
      throw Exception(msg);
    }
  }
}


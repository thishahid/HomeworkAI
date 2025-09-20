import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;

  GeminiService({required this.apiKey});

  Future<String> solveHomework(String imagePath) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$apiKey',
    );

    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Create the request body in the correct format
    final requestBody = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Analyze the homework problem in the image. Provide a beautiful, well-structured, step-by-step solution. Explain the reasoning for each step clearly. Use markdown for formatting, including headers for sections like \"Problem\", \"Step-by-Step Solution\", and \"Final Answer\"."
            },
            {
              "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
            }
          ]
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['candidates'] != null &&
          jsonResponse['candidates'].isNotEmpty &&
          jsonResponse['candidates'][0]['content'] != null &&
          jsonResponse['candidates'][0]['content']['parts'] != null &&
          jsonResponse['candidates'][0]['content']['parts'].isNotEmpty) {
        return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      final errorResponse = response.body;
      try {
        final errorJson = jsonDecode(errorResponse);
        throw Exception(
            errorJson['error']['message'] ?? 'Unknown error occurred');
      } catch (e) {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    }
  }
}

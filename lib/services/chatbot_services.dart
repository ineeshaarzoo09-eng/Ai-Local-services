import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  // Update endpoint to match Flask backend
  static const String baseUrl = "http://127.0.0.1:5000/ai-assistant"; 

  /// Send message to Flask API, fallback to mock if API fails
  static Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": message}), // "query" matches Flask payload
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "text": data["response"] ?? "No reply from AI",
          "service": "local_service", // Optional placeholder
          "suggestions": [],          // Optional, empty for now
        };
      } else {
        // Fallback to mock if API returns error
        return _mockResponse(message);
      }
    } catch (e) {
      // Fallback to mock in case of exception (network, parsing, etc.)
      return _mockResponse(message);
    }
  }

  /// Mock response in case API fails
  static Map<String, dynamic> _mockResponse(String message) {
    String reply;
    if (message.toLowerCase().contains("hi") || message.toLowerCase().contains("hello")) {
      reply = "Hello! I am your local services assistant. How can I help you?";
    } else if (message.toLowerCase().contains("service")) {
      reply = "We offer plumbing, electrical, cleaning, and handyman services.";
    } else {
      reply = "You said: $message";
    }

    // Optional mock suggestions
    List<String> suggestions = ["Hi", "What services do you offer?", "Thank you"];

    return {
      "text": reply,
      "service": "mock_service",
      "suggestions": suggestions,
    };
  }
}

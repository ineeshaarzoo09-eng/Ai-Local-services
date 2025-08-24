import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_final_project/services/chatbot_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": userMessage});
    });
    _controller.clear();

    // AI Response
    final dynamic reply = await ChatbotService.sendMessage(userMessage);

    Map<String, dynamic> botMessage;
    try {
      // Agar JSON string hai to decode karo
      botMessage = reply is String ? Map<String, dynamic>.from(jsonDecode(reply)) : Map<String, dynamic>.from(reply);
    } catch (_) {
      // Agar decode fail ho to fallback map
      botMessage = {"text": reply.toString()};
    }

    setState(() {
      _messages.add({
        "role": "bot",
        "text": botMessage["text"] ?? reply.toString(),
        "service": botMessage["service"]
      });
    });

    // Optional: Provider suggestion
    if (userMessage.toLowerCase().contains("plumber") ||
        userMessage.toLowerCase().contains("electrician") ||
        userMessage.toLowerCase().contains("cleaner")) {
      _fetchProviders(userMessage);
    }
  }

  Future<void> _fetchProviders(String query) async {
    String category = "Other";

    if (query.toLowerCase().contains("plumber")) {
      category = "Plumber";
    } else if (query.toLowerCase().contains("electrician")) {
      category = "Electrician";
    } else if (query.toLowerCase().contains("cleaner")) {
      category = "Cleaner";
    }

    final snapshot = await FirebaseFirestore.instance
        .collection("services")
        .where("category", isEqualTo: category)
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        final provider = doc.data();
        setState(() {
          _messages.add({
            "role": "bot",
            "text":
                "Provider found: ${provider['name'] ?? 'Unknown'} - ${provider['description'] ?? 'Service'} (Ratings: ${provider['ratings']?.toString() ?? 'N/A'})",
            "service": provider,
          });
        });
      }
    } else {
      setState(() {
        _messages.add({
          "role": "bot",
          "text": "Sorry, no $category service available right now."
        });
      });
    }
  }

  void _bookService(Map<String, dynamic> service) {
    final serviceName = service['name'] ?? 'Service';
    final serviceRatings = service['ratings']?.toString() ?? 'N/A';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Booking $serviceName (Ratings: $serviceRatings) initiated!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg["text"] ?? "",
                          style: TextStyle(
                              color: isUser ? Colors.white : Colors.black),
                        ),
                        if (!isUser && msg.containsKey("service"))
                          ElevatedButton(
                            onPressed: () => _bookService(msg["service"]),
                            child: Text(
                                "Book Now - ${msg['service']['name'] ?? 'Service'}"),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

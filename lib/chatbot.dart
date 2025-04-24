import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String Gemini_API_KEY =
    "AIzaSyC53sNh2slhRGxnBqujM5U_Ld1xHecdwD0"; // Gemini API Key

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "message": message});
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(
            'https://api.gemini.com/v1/completions'), // Replace with Gemini API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer "AIzaSyC53sNh2slhRGxnBqujM5U_Ld1xHecdwD0"', // Using the API key for authorization
        },
        body: json.encode({
          'model': 'gemini-3', // Replace with correct model
          'prompt': message, // The message sent to the API
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final botReply = responseData['choices'][0]['text'].trim();

        setState(() {
          _messages.add({"sender": "bot", "message": botReply});
        });
      } else {
        setState(() {
          _messages.add(
              {"sender": "bot", "message": "Error: Unable to get response."});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"sender": "bot", "message": "Error: $e"});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Generation"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["sender"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["message"]!,
                      style: TextStyle(
                          color: isUser ? Colors.white : Colors.black),
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
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

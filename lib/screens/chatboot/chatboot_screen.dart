import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ihsantech/screens/chatboot/model_screen.dart';
import 'package:intl/intl.dart';


class ChatbootScreen extends StatefulWidget {
  const ChatbootScreen({super.key});

  @override
  State<ChatbootScreen> createState() => _ChatbootScreenState();
}

class _ChatbootScreenState extends State<ChatbootScreen> {
  final TextEditingController promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  static const apiKey = "put here you gemini key";

  final List<ModelMessage> prompt = [];

  Future<void> sendMessage() async {
    final message = promptController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      promptController.clear();
      prompt.add(ModelMessage(isPrompt: true, message: message, time: DateTime.now()));
    });

    _scrollToBottom();

    try {
      final model = GenerativeModel(
        model: "gemini-1.5-flash",
        apiKey: apiKey,
        systemInstruction: Content.text(
          "You are an AI assistant for the ServiceHub app. Greet users when appropriate and ensure responses relate only to ServiceHub's features, services, or support. Keep responses under 200 words if possible. If the user asks about something unrelated, politely decline to answer. If someone asks about you, just answer: I was developed by Ihsan Ullah, who is an expert in Flutter and machine learning.",
        ),
      );

      final content = [Content.text(message)];
      String responseText;

      if (_isCreatorQuestion(message)) {
        responseText = "I was created by Ihsan Ullah, an expert in Flutter and Machine Learning. 🚀";
      } else {
        final response = await model.generateContent(content);
        responseText = _processResponse(response.text ?? "No response");
      }

      setState(() {
        prompt.add(ModelMessage(
          isPrompt: false,
          message: responseText,
          time: DateTime.now(),
        ));
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        prompt.add(ModelMessage(
          isPrompt: false,
          message: "Error: Unable to get a response. Please check your network connection.",
          time: DateTime.now(),
        ));
      });

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _isCreatorQuestion(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains("who made you") ||
        lowerMessage.contains("who created you") ||
        lowerMessage.contains("who developed you");
  }

  String _processResponse(String text) {
    if (prompt.isEmpty) {
      text = "Hello! 😊 How can I assist you with ServiceHub today?\n\n$text";
    }
    List<String> words = text.split(' ');
    if (words.length > 200) {
      return words.take(200).join(' ') + "...";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "What can I help you with?",
                style: TextStyle(fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: prompt.length,
                itemBuilder: (context, index) {
                  final message = prompt[index];
                  return UserPrompt(
                    isPrompt: message.isPrompt,
                    message: message.message,
                    date: DateFormat('hh:mm a').format(message.time),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: promptController,
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: sendMessage,
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.send, color: Colors.black, size: 26),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget UserPrompt({
    required bool isPrompt,
    required String message,
    required String date,
  }) {
    return Align(
      alignment: isPrompt ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPrompt ? Colors.grey : Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              date,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

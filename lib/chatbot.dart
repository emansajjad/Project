import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as GAI;

import 'const.dart'; // Make sure you have your Gemini_Api_KEY inside const.dart

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  bool isTyping = false;
  final TextEditingController promptController = TextEditingController();
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    messages.add(ChatMessage(
      sender: MessageSender.Bot,
      text: 'Hi admission seekers...',
    ));
  }

  Future<void> interactWithModel() async {
    final model = GAI.GenerativeModel(model: 'gemini-1.5-flash', apiKey: Gemini_Api_KEY);

    final promptText = promptController.text.trim()+' give short and concise answer in plain text without headings and answer in term of education purpose specifically uni students if not then say that bounded for educational purpose';
    if (promptText.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(
        sender: MessageSender.User,
        text: promptController.text.trim(),
      ));
      messages.add(ChatMessage(
        sender: MessageSender.Bot,
        text: '...',
      ));
      isTyping = true;
    });

    promptController.clear();

    final prompt = GAI.TextPart(promptText);
    final content = GAI.Content.text(prompt.text);
    final response = await model.generateContent([content]);

    setState(() {
      messages.removeLast();
      messages.add(ChatMessage(
        sender: MessageSender.Bot,
        text: response.text ?? "Sorry, I couldn't understand that.",
      ));
      isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniQuest Chatbot', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  
                  child: TextField(
                    controller: promptController,
                    decoration: const InputDecoration(
                      labelText: '  Ask a question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                InkWell(
                    onTap: interactWithModel,
                    child: CircleAvatar(child: Center(child: Icon(Icons.send, color: Colors.white,)),backgroundColor:  Color.fromARGB(255, 83, 99, 182),)),
                // ElevatedButton(
                //   onPressed: interactWithModel,
                //   child: const Text('Send'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum MessageSender { User, Bot }

class ChatMessage {
  final MessageSender sender;
  final String? text;

  ChatMessage({
    required this.sender,
    this.text,
  });
}

class ChatBubble extends StatefulWidget {
  final ChatMessage message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotAnimation;
  String displayedText = "";

  @override
  void initState() {
    super.initState();
    if (widget.message.text == '...') {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 900),
        vsync: this,
      )..repeat();
      _dotAnimation = StepTween(begin: 1, end: 3).animate(_controller)
        ..addListener(() {
          setState(() {
            displayedText = '.' * _dotAnimation.value;
          });
        });
    }
  }

  @override
  void dispose() {
    if (widget.message.text == '...') {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBot = widget.message.sender == MessageSender.Bot;
    final bgColor = isBot ? Colors.blueGrey[100] : Colors.blue[100];
    final text = widget.message.text == '...' ? displayedText : widget.message.text!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8.0),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7, // Limit width
            ),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}

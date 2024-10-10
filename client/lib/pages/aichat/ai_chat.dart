import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  bool isLoading = false;
  String partialResponse = '';
  
  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "MM",
    profileImage: "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          DashChat(
            inputOptions: InputOptions(
              trailing: [],
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              inputTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              inputDecoration: InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            messageOptions: const MessageOptions(
              showTime: true,
              textColor: Colors.black,
            ),
            currentUser: currentUser,
            onSend: _handleMessage,
            messages: messages,
          ),
          if (isLoading)
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'AI is thinking...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleMessage(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
      isLoading = true;
      partialResponse = '';
    });

    try {
      String prompt = '''
      Please provide a clear and concise response (preferably under 200 words).
      Context: ${message.text}
      ''';

      await for (final event in gemini.streamGenerateContent(prompt)) {
        final text = event.content?.parts?.firstOrNull?.text ?? '';
        
        if (text.isNotEmpty) {
          setState(() {
            partialResponse += text;
            
            if (messages.length > 1 && messages[0].user.id == geminiUser.id) {
              messages[0] = ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: partialResponse.trim(),
              );
            } else {
              messages.insert(0, ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: partialResponse.trim(),
              ));
            }
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
        partialResponse = '';
      });
    }
  }
}
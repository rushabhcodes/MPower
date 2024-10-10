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
  bool isLoading = false; // State to manage loading

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "MM",
    profileImage:
        "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: const InputOptions(
        trailing: [], // Removed the image upload button
        inputDecoration: InputDecoration(
          hintText: 'Type a message',
          hintStyle: TextStyle(color: Colors.grey), // Change hint color
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Border color on focus
          ),
        ),
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
      isLoading = true; // Set loading to true
    });
    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        String response = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}",
            ) ??
            "";
        ChatMessage message = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        setState(() {
          messages = [message, ...messages];
          isLoading = false; // Set loading to false
        });
      }, onError: (error) {
        setState(() {
          isLoading = false; // Set loading to false on error
        });
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false on catch
      });
      print(e);
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../appservices/ai_service.dart';
import '../constants/colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'You');
  final ChatUser _aiUser = ChatUser(id: '2', firstName: 'Derm AI');
  bool _isLoading = true;

  List<ChatMessage> _messages = [];
  List<ChatUser> _typingUsers = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .get();

      final chatMessages = snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage(
          text: data['text'] ?? '',
          user: data['userId'] == _currentUser.id ? _currentUser : _aiUser,
          createdAt: DateTime.parse(data['createdAt']),
        );
      }).toList();

      setState(() {
        _messages = chatMessages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _handleSend(ChatMessage message) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() {
      _messages.insert(0, message);
      _typingUsers.add(_aiUser);
    });

    // Save user's message
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('messages')
        .add({
      'text': message.text,
      'userId': _currentUser.id,
      'createdAt': message.createdAt.toIso8601String(),
    });

    try {
      final reply = await AIService.getAIResponse(message.text);

      final responseMessage = ChatMessage(
        user: _aiUser,
        createdAt: DateTime.now(),
        text: reply,
      );

      setState(() {
        _messages.insert(0, responseMessage);
      });

      // Save AI reply
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('messages')
          .add({
        'text': reply,
        'userId': _aiUser.id,
        'createdAt': responseMessage.createdAt.toIso8601String(),
      });

    } catch (e) {
      final errorMessage = ChatMessage(
        user: _aiUser,
        createdAt: DateTime.now(),
        text: 'Error: ${e.toString()}',
      );

      setState(() {
        _messages.insert(0, errorMessage);
      });
    } finally {
      setState(() {
        _typingUsers.remove(_aiUser);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'images/robot.png',
                height: 35,
                width: 35,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "DERM AI",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
        child: SpinKitFadingCircle(
          color: successColor,
          size: 50.0,
        ),// ⬅️ Spinner while loading
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: DashChat(
          currentUser: _currentUser,
          onSend: _handleSend,
          messages: _messages,
          typingUsers: _typingUsers,
          inputOptions: InputOptions(
            sendButtonBuilder: (send) => IconButton(
              icon: const Icon(Icons.send, color: successColor),
              onPressed: send,
            ),
            cursorStyle: const CursorStyle(color: Colors.black),
            inputDecoration: InputDecoration(
              hintText: 'Type your message here...',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: successColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: successColor, width: 2),
              ),
            ),
          ),
          messageOptions: const MessageOptions(
            currentUserContainerColor: successColor,
            containerColor: Color(0xFF232023),
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

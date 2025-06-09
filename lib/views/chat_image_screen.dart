import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/constants/size_config.dart';
import 'package:skinai/views/doctors_screen.dart';
import 'package:skinai/views/product_screen.dart';
import '../appservices/skin_analyzer_service.dart';

class ChatWithImageScreen extends StatefulWidget {
  final String userImage;

  const ChatWithImageScreen({super.key, required this.userImage});

  @override
  State<ChatWithImageScreen> createState() => _ChatWithImageScreenState();
}

class _ChatWithImageScreenState extends State<ChatWithImageScreen> {
  final SkinAnalyzerService _aiService = SkinAnalyzerService();

  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'You');
  final ChatUser _aiUser = ChatUser(id: '2', firstName: 'Derm AI');

  List<ChatMessage> _messages = [];
  List<ChatUser> _typingUsers = [];
  bool _imageLoading = true;
  bool _showSuggestions = false;
  bool _imageAlreadyAnalyzed = false;


  Future<void> _handleSend(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _typingUsers.add(_aiUser);
      _showSuggestions = false;
    });

    try {
      Map<String, dynamic> result;

      if (!_imageAlreadyAnalyzed) {
        // First call: send image + message
        result = await _aiService.analyzeImageWithMessage(
          widget.userImage,
          message.text,
        );
        _imageAlreadyAnalyzed = true; // Flag ON after first call
      } else {
        // Next calls: only send message
        result = await _aiService.analyzeMessageOnly(message.text);
      }

      if (result['success'] == true) {
        final String reply = result['data']['analysis'] ?? "No analysis found.";

        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _aiUser,
              createdAt: DateTime.now(),
              text: reply,
            ),
          );
          _showSuggestions = true;
        });
      } else {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _aiUser,
              createdAt: DateTime.now(),
              text: "Error: ${result['error']}",
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _aiUser,
            createdAt: DateTime.now(),
            text: "Exception: ${e.toString()}",
          ),
        );
      });
    } finally {
      setState(() {
        _typingUsers.remove(_aiUser);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Face Analyzer"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: SizeConfig.screenHeight * 0.30,
                    decoration: BoxDecoration(
                      border: Border.all(color: accentColor, width: 3),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        widget.userImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: SizeConfig.screenHeight * 0.30,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            if (_imageLoading) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() => _imageLoading = false);
                                }
                              });
                            }
                            return child;
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(color: accentColor),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  if (_imageLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(180),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Text(
                      "Captured Result",
                      style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.2,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withAlpha(100),
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
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
                    containerColor: Colors.black87,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ),
            if (_showSuggestions)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: successColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductListScreen(),));
                      },
                      child: Text(
                        "Suggest Products",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: SizeConfig.textMultiplier * 1.5,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: successColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllDoctorsScreen()),
                        );
                      },
                      child: Text(
                        "Suggest Doctors",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: SizeConfig.textMultiplier * 1.5,
                        ),
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
}

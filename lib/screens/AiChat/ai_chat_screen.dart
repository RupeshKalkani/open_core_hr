import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_core_hr/main.dart';

/// Example primary color
Color appColorPrimary = appStore.appColorPrimary;

/// Main chat screen
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _textController = TextEditingController();

  /// We'll use this to auto-scroll to the bottom
  final ScrollController _scrollController = ScrollController();

  /// Our chat messages
  final List<_Message> _messages = [
    _Message(
        sender: MessageSender.ai, text: "Hello! How can I help you today? 👋"),
  ];

  /// Suggested queries or actions in natural language
  final List<String> _quickOptions = [
    "Apply sick leave for next 2 days",
    "Check my expense status",
    "Cancel my last leave request",
    "Check my leave balance",
    "What's the weather forecast?",
  ];

  @override
  void initState() {
    super.initState();
    // Listen for changes so we can auto-scroll whenever the list updates
    _scrollController.addListener(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll to bottom after new messages appear
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Handle the user's typed message -> add to chat -> show "thinking" -> typed response
  void _handleSend() {
    final userText = _textController.text.trim();
    if (userText.isEmpty) return;
    _textController.clear();

    setState(() {
      _messages.add(_Message(sender: MessageSender.user, text: userText));
    });
    _scrollToBottom();

    // Show a "thinking" bubble for 2 seconds, then typed response
    _showThinkingBubble(
      thinkingText: "Processing your request: $userText...\nPlease wait...",
      finalResponse: "Here's the AI response for: $userText",
    );
  }

  /// When user taps a quick option chip
  void _handleChipTap(String label) {
    setState(() {
      _messages.add(_Message(sender: MessageSender.user, text: label));
    });
    _scrollToBottom();

    _showThinkingBubble(
      thinkingText: "You selected: $label\nLet me handle that...",
      finalResponse: "This is the AI's response for: $label",
    );
  }

  /// Show a "thinking" bubble for [seconds], then remove it and show a typed AI response
  void _showThinkingBubble({
    required String thinkingText,
    required String finalResponse,
    int seconds = 2,
  }) {
    final thinkingMsg = _Message(
        sender: MessageSender.ai, text: thinkingText, isThinking: true);
    setState(() {
      _messages.add(thinkingMsg);
    });
    _scrollToBottom();

    Timer(Duration(seconds: seconds), () {
      setState(() {
        _messages.remove(thinkingMsg);
      });
      _simulateAiTyping(finalResponse);
    });
  }

  /// Simulate ChatGPT-like "typing" effect for the final AI response
  void _simulateAiTyping(String fullText) {
    final newMessage = _Message(sender: MessageSender.ai, text: "");
    setState(() {
      _messages.add(newMessage);
    });
    _scrollToBottom();

    int currentIndex = 0;
    String typed = "";

    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (currentIndex < fullText.length) {
        typed += fullText[currentIndex];
        setState(() {
          // Update the last AI message
          _messages[_messages.length - 1] =
              _Message(sender: MessageSender.ai, text: typed);
        });
        _scrollToBottom();
        currentIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  /// Placeholder: show a dialog with pulsing mic for future voice integration
  void _showVoiceDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _VoiceInputDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header: AI avatar + "How can I help..."
            // Header row with Back Button, AI avatar + text
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // BACK BUTTON
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  // AI Logo
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: appColorPrimary,
                    child: const Icon(Icons.android,
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  const Expanded(
                    child: Text(
                      "How can I help you today?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Expanded chat area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg.sender == MessageSender.user;
                  return _ChatBubble(message: msg, isUser: isUser);
                },
              ),
            ),

            // Quick suggestion chips
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _quickOptions.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(option),
                          side: const BorderSide(color: Colors.transparent),
                          labelStyle: const TextStyle(color: Colors.white),
                          backgroundColor: appColorPrimary,
                          onPressed: () => _handleChipTap(option),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Bottom row: voice, text field, send
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // Voice button
                  IconButton(
                    onPressed: _showVoiceDialog,
                    icon: const Icon(Icons.mic, color: Colors.grey),
                  ),

                  // Text field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Type your request...",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send button
                  InkWell(
                    onTap: _handleSend,
                    child: CircleAvatar(
                      backgroundColor: appColorPrimary,
                      child: const Icon(Icons.send, color: Colors.white),
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

/// A single chat bubble widget
class _ChatBubble extends StatelessWidget {
  final _Message message;
  final bool isUser;

  const _ChatBubble({Key? key, required this.message, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bubbleColor = message.isThinking
        ? Colors.yellow[100]
        : (isUser ? Colors.blue[100] : Colors.white);

    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
      bottomRight: isUser ? Radius.zero : const Radius.circular(12),
    );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: radius,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 2, offset: Offset(1, 1)),
            ],
          ),
          child: Text(
            message.text,
            style: TextStyle(
              fontStyle:
                  message.isThinking ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }
}

/// Simple data model for a message
class _Message {
  final MessageSender sender;
  final String text;
  final bool isThinking;

  const _Message({
    required this.sender,
    required this.text,
    this.isThinking = false,
  });
}

enum MessageSender { user, ai }

/// Simple "listening" dialog for voice input
class _VoiceInputDialog extends StatefulWidget {
  const _VoiceInputDialog();

  @override
  State<_VoiceInputDialog> createState() => _VoiceInputDialogState();
}

class _VoiceInputDialogState extends State<_VoiceInputDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _micController;
  late Animation<double> _micScale;

  @override
  void initState() {
    super.initState();
    _micController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _micScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _micController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _micController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Listening...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ScaleTransition(
              scale: _micScale,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent[100],
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(24),
                child: const Icon(
                  Icons.mic,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}

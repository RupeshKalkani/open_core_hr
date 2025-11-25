import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/chat_response.dart';
import 'package:video_player/video_player.dart';

import '../../../main.dart';

class VideoFullScreen extends StatefulWidget {
  final String videoUrl;
  final ChatMessage chatMessage;
  final VoidCallback shareAction;
  final VoidCallback forwardAction;

  const VideoFullScreen({
    Key? key,
    required this.videoUrl,
    required this.chatMessage,
    required this.shareAction,
    required this.forwardAction,
  }) : super(key: key);

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(color: Colors.white),
          ),

          // Close Button (Top-Left)
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatMessage.userName ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      widget.chatMessage.createdAtHuman,
                      style: secondaryTextStyle(color: white),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Share Button (Top-Right)
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: widget.shareAction,
              child: Row(
                children: [
                  Text(language.lblShare,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Icon(Icons.share, color: Colors.white, size: 28),
                ],
              ),
            ),
          ),

          // Forward Button (Bottom-Right)
          Positioned(
            bottom: 40,
            right: 16,
            child: GestureDetector(
              onTap: widget.forwardAction,
              child: Row(
                children: [
                  Text(language.lblForward,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const Icon(Iconsax.arrow_right_3, color: Colors.white),
                ],
              ),
            ),
          ),

          // Play/Pause Toggle (Center)
          GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                  _isPlaying = false;
                } else {
                  _controller.play();
                  _isPlaying = true;
                }
              });
            },
            child: Center(
              child: AnimatedOpacity(
                opacity: _isPlaying ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 64,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

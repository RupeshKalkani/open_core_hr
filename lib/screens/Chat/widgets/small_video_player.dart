import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:video_player/video_player.dart';

import '../../../main.dart';

class VideoPlayerSmallWidget extends StatefulWidget {
  final String url;

  const VideoPlayerSmallWidget({super.key, required this.url});

  @override
  State<VideoPlayerSmallWidget> createState() => _VideoPlayerSmallWidgetState();
}

class _VideoPlayerSmallWidgetState extends State<VideoPlayerSmallWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool isLoading = true;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.url));

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        showControls: true,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void togglePlayPause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
    setState(() {
      isPlaying = _videoPlayerController.value.isPlaying;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Preview
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: isLoading
                    ? loadingWidgetMaker()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Chewie(
                          controller: _chewieController!,
                        ),
                      ),
              ),
              if (!isPlaying && !isLoading)
                IconButton(
                  icon: Icon(Icons.play_circle_fill,
                      size: 50, color: Colors.white.withOpacity(0.8)),
                  onPressed: togglePlayPause,
                ),
            ],
          ),
          // Video Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: appStore.appColorPrimary,
                  ),
                  onPressed: togglePlayPause,
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    _videoPlayerController,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: appStore.appColorPrimary,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.black26,
                    ),
                  ),
                ),
                Text(
                  _formatDuration(_videoPlayerController.value.position),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

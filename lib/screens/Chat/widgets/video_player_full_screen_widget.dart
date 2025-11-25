import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.transparent);
    return isLoading
        ? loadingWidgetMaker().center()
        : Chewie(
            controller: chewieController,
          );
  }
}

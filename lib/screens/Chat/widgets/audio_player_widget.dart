import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({super.key, required this.url});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool isPlaying = false;
  final PlayerController _waveformController = PlayerController();

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final localPath = await _downloadAudio(widget.url);

      await _waveformController.preparePlayer(
        path: localPath,
        shouldExtractWaveform: true,
      );

      _waveformController.onCompletion.listen((_) {
        setState(() {
          isPlaying = false;
        });
        _waveformController.seekTo(0);
      });
    } catch (e) {
      debugPrint('Error initializing player: $e');
    }
  }

  Future<String> _downloadAudio(String url) async {
    final dio = Dio();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${url.split('/').last}';

    if (!File(filePath).existsSync()) {
      await dio.download(url, filePath);
    }

    return filePath;
  }

  @override
  void dispose() {
    _waveformController.stopPlayer();
    _waveformController.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    if (isPlaying) {
      _waveformController.pausePlayer();
    } else {
      log('Max Duration >> ${_waveformController.maxDuration.toString()}');
      _waveformController.seekTo(0);
      _waveformController.startPlayer();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: appStore.isDarkModeOn
            ? appStore.scaffoldBackground
            : Colors.white,
      ),
      child: Row(
        children: [
          // Play/Pause Button
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            color: appStore.appColorPrimary,
            onPressed: togglePlayPause,
          ),

          // Waveform Visualization
          Expanded(
            child: AudioFileWaveforms(
              size: Size(double.infinity, 50),
              playerController: _waveformController,
              enableSeekGesture: true,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: PlayerWaveStyle(
                waveThickness: 2.0,
                fixedWaveColor: Colors.grey,
                liveWaveColor: appStore.appColorPrimary,
                seekLineColor: Colors.red,
              ),
            ),
          ),

          // Duration Text
          StreamBuilder<int>(
            stream: _waveformController.onCurrentDurationChanged,
            builder: (context, snapshot) {
              final currentPosition = snapshot.data ?? 0;
              final remainingDuration = isPlaying
                  ? (_waveformController.maxDuration - currentPosition).clamp(
                      0,
                      _waveformController.maxDuration,
                    )
                  : _waveformController
                        .maxDuration; // Show total duration initially

              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  _formatDuration(remainingDuration),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(int duration) {
    final minutes = (duration ~/ 60000).clamp(0, 59); // Minutes from ms
    final seconds = ((duration % 60000) ~/ 1000).clamp(
      0,
      59,
    ); // Remaining seconds
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

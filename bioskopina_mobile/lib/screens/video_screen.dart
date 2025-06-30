import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/colors.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;
  final ValueNotifier<int> playbackPosition;
  final ValueNotifier<bool> isPlaying;
  final Function(int position, bool isPlaying) updatePlaybackStatus;

  const VideoScreen({
    super.key,
    required this.videoId,
    required this.playbackPosition,
    required this.isPlaying,
    required this.updatePlaybackStatus,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.isPlaying.value,
        startAt: widget.playbackPosition.value,
        mute: false,
        disableDragSeek: false,
      ),
    )..addListener(_updatePlaybackStatus);
  }

  void _updatePlaybackStatus() {
    widget.playbackPosition.value = _controller.value.position.inSeconds;
    widget.isPlaying.value = _controller.value.isPlaying;

    widget.updatePlaybackStatus(
      widget.playbackPosition.value,
      widget.isPlaying.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _exitFullScreen();
        return true;
      },
      child: Scaffold(
        body: Center(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
              ),
              RemainingDuration(),
              GestureDetector(
                onTap: _exitFullScreen,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.fullscreen_exit_rounded,
                      color: Palette.white, size: 36),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exitFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final int position = _controller.value.position.inSeconds;
    final bool isPlaying = _controller.value.isPlaying;

    Navigator.of(context).pop([position, isPlaying]);
    _controller.pause();
  }

  @override
  void dispose() {
    _controller.removeListener(_updatePlaybackStatus);
    _controller.dispose();
    super.dispose();
  }
}

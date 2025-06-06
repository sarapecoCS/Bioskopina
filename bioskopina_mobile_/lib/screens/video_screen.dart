import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class VideoScreen extends StatefulWidget {
  final String videoId;
  ValueNotifier<int> playbackPosition;
  late ValueNotifier<bool> isPlaying;
  final Function(int position, bool isPlaying) updatePlaybackStatus;

  VideoScreen({
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
  late YoutubePlayerController controller;

  @override
  void initState() {
    controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.isPlaying.value,
        startAt: widget.playbackPosition.value,
      ),
    );

    controller.addListener(_updatePlaybackPosition);

    super.initState();
  }

  void _updatePlaybackPosition() {
    widget.playbackPosition.value = controller.value.position.inSeconds;
    widget.isPlaying.value = controller.value.isPlaying;

    widget.updatePlaybackStatus(
      widget.playbackPosition.value,
      widget.isPlaying.value,
    );
  }

  void updateVideoProgress() {
    widget.playbackPosition.value = controller.value.position.inSeconds;
    widget.isPlaying.value = controller.value.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // If it returns false, user can't go back using device navigation
        _leaveFullScreen();
        return true;
      },
      child: Scaffold(
        body: Center(
          child: YoutubePlayer(
            controller: controller,
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
                colors: ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
              ),
              RemainingDuration(),
              GestureDetector(
                  onTap: () {
                    _leaveFullScreen();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Icon(Icons.fullscreen_exit_rounded,
                        color: Palette.white, size: 36),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _leaveFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    int position = controller.value.position.inSeconds;
    bool isPlaying = controller.value.isPlaying;

    Navigator.of(context).pop([
      position,
      isPlaying,
    ]);

    controller.pause();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

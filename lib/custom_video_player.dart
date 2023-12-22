import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  const CustomVideoPlayer(this.video, {super.key});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  double value = 0;
  @override
  void initState() {
    super.initState();
    initializeController();
  }

  void initializeController() async {
    final videoController = VideoPlayerController.file(File(widget.video.path));
    await videoController.initialize();
    // videoController.addListener(videoControllerListener);
    setState(() {
      this.videoController = videoController;
    });
  }
  // void videoControllerListener(){
  // setState((){});
  // }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: videoController!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(videoController!),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Slider(
                  value: value,
                  onChanged: (double val) {
                    videoController!.seekTo(Duration(seconds: val.toInt()));
                    setState(() {
                      value = val;
                    });
                  },
                  min: 0,
                  max: videoController!.value.duration.inSeconds.toDouble())),
          const Align(),
          const Align()
        ],
      ),
    );
  }
}

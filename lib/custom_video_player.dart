import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onNewVideoPressed;
  const CustomVideoPlayer(
      {required this.video, required this.onNewVideoPressed, super.key});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  double value = 0;
  bool showControls = false;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  void initializeController() async {
    final videoController = VideoPlayerController.file(File(widget.video.path));
    await videoController.initialize();
    videoController.addListener(renew);
    setState(() {
      this.videoController = videoController;
    });
  }

  void renew() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  void dispose() {
    videoController?.removeListener(renew);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(videoController!),
            if (showControls) Container(color: Colors.black.withOpacity(0.5)),
            // 아이콘 버튼이 보일 때는, 화면을 약간 어둡게 만든다.
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
            if (showControls)
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 30,
                    color: Colors.white,
                    icon: const Icon(Icons.photo_library),
                    onPressed: widget.onNewVideoPressed,
                  )),
            if (showControls)
              Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: onReversePressed,
                      ),
                      IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: const Icon(Icons.play_arrow),
                        onPressed: onPlayPressed,
                      ),
                      IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: onForwardPressed,
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;
    Duration position = const Duration(); // 0초로 실행위치 초기화

    if (currentPosition.inSeconds > 3) {
      // 3초 이상되었을 경우, 누르면 3초 빼기
      // position은   몇초로 초!단위이다. 이것을 int와 비교하기 위해서는 .inSeconds로 해야 int가 된다.
      position = currentPosition - const Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = videoController!.value.duration; //동영상 길이
    final currentPosition = videoController!.value.position;
    Duration position = maxPosition; // 동영상 길이로 실행위치 초기화

    if ((maxPosition - const Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 3);
    }
    videoController!.seekTo(position);

    // if ((maxPosition - currentPosition).inSeconds > 3) {
    //   position = currentPosition + const Duration(seconds: 3);
    // }
    // videoController!.seekTo(position); 이게 왜 안되는 지 모르겠다...
  }

  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}

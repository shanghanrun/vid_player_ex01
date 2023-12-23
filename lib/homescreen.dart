import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player_ex01/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Logo(onTap: getNewVideo),
          const SizedBox(height: 30),
          const AppName(),
        ],
      ),
    );
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
          video: video!, onNewVideoPressed: getNewVideo), //동영상 재생기위젯
    );
  }

  BoxDecoration getBoxDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xff2a3a7c), Color(0xff00011b)],
    ));
  }

  void getNewVideo() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }
}

class Logo extends StatelessWidget {
  final VoidCallback onTap;
  const Logo({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Image.asset('images/logo.png'));
  }
}

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w300,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('VIDEO ', style: textStyle),
        Text('PLAYER',
            style: textStyle.copyWith(
              fontWeight: FontWeight.w700,
            )),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/src/stores/player_store.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  final int indexVideo;
  const PlayerWidget({
    Key? key,
    required this.indexVideo,
  }) : super(key: key);

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    final playerStore = context.read<PlayerStore>();
    final String videoPath = playerStore.getVideo(widget.indexVideo);
    final File video = File(videoPath);
    controller = VideoPlayerController.file(video)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((_) => controller.play());
    controller.addListener(() {
      if (controller.value.position == controller.value.duration) {
        playerStore.nextVideo();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => controller.value.isInitialized
      ? Container(alignment: Alignment.topCenter, child: buildVideoPlayer())
      : const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      );
}

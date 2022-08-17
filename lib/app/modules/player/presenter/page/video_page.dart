import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/presenter/stores/player_store.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final ContentsEntity contentsEntity;
  const VideoPage({
    Key? key,
    required this.contentsEntity,
  }) : super(key: key);

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    final playerStore = context.read<PlayerStore>();
    playerStore.upDateContents();
    final File video = File(widget.contentsEntity.contents);
    controller = VideoPlayerController.file(video)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((_) => controller.play());
    controller.addListener(() {
      if (controller.value.position == controller.value.duration) {
        playerStore.nextContents();
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
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: controller.value.isInitialized
          ? Container(alignment: Alignment.topCenter, child: buildVideoPlayer())
          : const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      );
}

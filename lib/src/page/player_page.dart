import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/src/stores/core_store.dart';
import 'package:saudetv/src/stores/player_store.dart';
import 'package:saudetv/src/widget/bottom_bar.dart';
import 'package:saudetv/src/widget/player_widget.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    final coreStore = context.read<CoreStore>();
    Timer.periodic(Duration(minutes: coreStore.timeCourse), (timer) {
      coreStore.videoUpdate();
    });
    coreStore.indexVideo.addListener(() {
      coreStore.deleteVideosLate();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playerStore = context.read<PlayerStore>();
    final coreStore = context.read<CoreStore>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: Column(children: [
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: coreStore.indexVideo,
            builder: (BuildContext context, int value, Widget? child) {
              return coreStore.videosList.isEmpty || playerStore.isLoading
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : PlayerWidget(
                      indexVideo: value,
                    );
            },
          ),
        ),
        coreStore.bottonBar
            ? SizedBox(
                height: height * 0.1240740741,
                width: width,
                child: BottonBar(
                  getSystemTime: playerStore.getSystemTime,
                  getSystemDay: playerStore.getSystemDay,
                  getSystemWeek: playerStore.getSystemWeek,
                  weatherMin: coreStore.weatherModel.value.tempMin,
                  weatherMax: coreStore.weatherModel.value.tempMax,
                  weatherIcon: coreStore.weatherModel.value.icon,
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/core/presenter/stores/page_store.dart';
import 'package:saudetv/app/modules/player/presenter/stores/player_store.dart';

import '../../../../core/domain/adapter/login_source.dart';

class PlayerPage extends StatefulWidget {
  final LoginSource loginSource;
  const PlayerPage({
    Key? key,
    required this.loginSource,
  }) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late Timer _timer;

  @override
  void initState() {
    final playerStore = context.read<PlayerStore>();
    final pageStore = context.read<PageStore>();
    playerStore.setLoginSource(widget.loginSource);
    playerStore.initialize(widget.loginSource);
    _timer = Timer.periodic(
        Duration(
            minutes: playerStore
                .loginSource.terminalEntity.updateTimeCourseMin), (timer) {
      playerStore.upDateContents();
    });
    playerStore.contentsPage.addListener(() {
      playerStore.delContents();
    });
    pageStore.isConnect.addListener(() {
      if (pageStore.isConnect.value && playerStore.lateUpDate) {
        playerStore.upDateContents();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerStore = context.read<PlayerStore>();
    return ValueListenableBuilder(
        valueListenable: playerStore.contentsPage,
        builder: (BuildContext context, Widget value, Widget? child) {
          return value;
        });
  }
}

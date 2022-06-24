import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/presenter/stores/player_store.dart';

class RssPage extends StatefulWidget {
  final ContentsEntity contentsEntity;
  const RssPage({
    Key? key,
    required this.contentsEntity,
  }) : super(key: key);

  @override
  State<RssPage> createState() => _RssPageState();
}

class _RssPageState extends State<RssPage> {
  late Timer _timer;

  @override
  void initState() {
    final playerStore = context.read<PlayerStore>();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _timer.cancel();
      playerStore.nextContents();
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final playerStore = context.read<PlayerStore>();
    return SizedBox(
      height:
          playerStore.hasBar.value ? (height - (height * 0.11111111)) : height,
      width: width,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

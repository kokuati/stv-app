import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/presenter/stores/player_store.dart';

class OthersPage extends StatefulWidget {
  final ContentsEntity contentsEntity;
  const OthersPage({
    Key? key,
    required this.contentsEntity,
  }) : super(key: key);

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  late Timer _timer;

  @override
  void initState() {
    final playerStore = context.read<PlayerStore>();
    playerStore.addDeleteContentsList(widget.contentsEntity.id);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
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
    return Container(
      width: width,
      height: height,
      color: Colors.black,
    );
  }
}

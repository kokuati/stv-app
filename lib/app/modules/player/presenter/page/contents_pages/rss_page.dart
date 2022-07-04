import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/entities/news_entity.dart';
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
    return SizedBox(
      height: height,
      width: width,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  NewsEntity getNews(dynamic contents) {
    if (contents is List<NewsEntity>) {
      final randomIndex = Random().nextInt(contents.length - 1);
      return contents[randomIndex];
    } else {
      return NewsEntity(source: '', title: '', image: '');
    }
  }
}

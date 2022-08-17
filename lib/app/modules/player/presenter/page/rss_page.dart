import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/entities/news_entity.dart';
import 'package:saudetv/app/modules/player/presenter/stores/player_store.dart';

import 'widget/background_news.dart';

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
  late NewsEntity _newsEntity;
  late int _time;
  bool _first = true;
  final NewsEntity emptyNews = NewsEntity(
    source: '',
    title: '',
    image: '',
    sourceImage: '',
  );

  @override
  void initState() {
    final playerStore = context.read<PlayerStore>();
    playerStore.upDateContents();
    _time = 10;
    _newsEntity = getNews(widget.contentsEntity.contents);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timeProcess(_time);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> timeProcess(int time) async {
    final playerStore = context.read<PlayerStore>();
    if (_newsEntity == emptyNews) {
      playerStore.nextContents();
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _first = false;
      });
      await Future.delayed(Duration(seconds: time));
      setState(() {
        _first = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      playerStore.nextContents();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      child: AnimatedCrossFade(
        duration: const Duration(seconds: 1),
        firstChild: Container(
          height: height,
          width: width,
          color: Colors.black,
        ),
        secondChild: news(context, height, width),
        crossFadeState:
            _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
    );
  }

  Widget news(BuildContext context, double height, double width) {
    return SizedBox(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _newsEntity.image.isNotEmpty
                ? SizedBox(
                    width: width,
                    height: height,
                    child: Image.network(
                      _newsEntity.image,
                      fit: BoxFit.fill,
                    ),
                  )
                : BackgroundNews(sourceImage: _newsEntity.sourceImage),
            SizedBox(
              height: height * 0.18,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.001,
                  ),
                  Container(
                    height: height * 0.18,
                    width: width * 0.03,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE84C4C),
                      borderRadius: BorderRadius.circular(width * 0.005),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.001,
                  ),
                  Container(
                    height: height * 0.18,
                    width: width * 0.967,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(200, 255, 255, 255),
                      borderRadius: BorderRadius.circular(width * 0.005),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width * 0.03,
                        ),
                        SizedBox(
                          height: height * 0.17,
                          width: width * 0.77,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _newsEntity.source,
                                style: TextStyle(
                                  inherit: false,
                                  fontSize: height * 0.04,
                                  fontFamily: 'Segoe',
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF1C1C1C),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.003,
                              ),
                              Text(
                                _newsEntity.title,
                                softWrap: true,
                                style: TextStyle(
                                  inherit: false,
                                  fontSize: height * 0.04,
                                  fontFamily: 'Segoe',
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1C1C1C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        SizedBox(
                          height: height * 0.14,
                          width: width * 0.15,
                          child: _newsEntity.image.isNotEmpty &&
                                  _newsEntity.sourceImage.isNotEmpty
                              ? Image.network(
                                  _newsEntity.sourceImage,
                                  fit: BoxFit.contain,
                                )
                              : const SizedBox(),
                        ),
                        SizedBox(
                          width: width * 0.005,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.001,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  NewsEntity getNews(dynamic contents) {
    final List newListe = contents["rss"];
    if (newListe.isEmpty) {
      return emptyNews;
    } else {
      int randomIndex = 0;
      if (newListe.length > 1) {
        randomIndex = Random().nextInt(newListe.length);
      }
      final List media = contents["rss"][randomIndex]["media:content"];
      String midiaLink = '';
      if (media.isNotEmpty) {
        final urlImage = media[0]['\$']['url'];
        if (isImage(urlImage)) {
          midiaLink = urlImage;
        }
      }
      return NewsEntity(
        source: contents["name"],
        title: contents["rss"][randomIndex]["title"][0],
        image: midiaLink,
        sourceImage: contents["logo"],
      );
    }
  }

  bool isImage(String urlImage) {
    const List<String> imageType = [
      'JPEG',
      'PNG',
      'GIF',
      'WebP',
      'BMP',
      'WBMP'
    ];
    final String type = urlImage.substring(urlImage.lastIndexOf('.') + 1);
    return imageType.contains(type.toUpperCase());
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/core/presenter/stores/page_store.dart';

class Pages extends StatefulWidget {
  const Pages({
    Key? key,
  }) : super(key: key);

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  @override
  void initState() {
    final pageStore = context.read<PageStore>();
    pageStore.isConnect.addListener(() {
      Timer.periodic(const Duration(seconds: 30), (timer) {
        if (pageStore.isConnect.value) {
          timer.cancel();
        } else {
          pageStore.checkInternet();
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageStore = context.read<PageStore>();
    return ValueListenableBuilder(
      valueListenable: pageStore.page,
      builder: (BuildContext context, Widget value, Widget? child) {
        return value;
      },
    );
  }
}

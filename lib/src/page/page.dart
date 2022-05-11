import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/src/stores/core_store.dart';

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
    final coreStore = context.read<CoreStore>();

    coreStore.isConnect.addListener(() {
      Timer.periodic(const Duration(seconds: 30), (timer) {
        if (coreStore.isConnect.value) {
          timer.cancel();
        } else {
          coreStore.checkInternet();
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coreStore = context.read<CoreStore>();
    return ValueListenableBuilder(
      valueListenable: coreStore.page,
      builder: (BuildContext context, Widget value, Widget? child) {
        return value;
      },
    );
  }
}

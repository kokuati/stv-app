import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/src/stores/core_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    final coreStore = context.read<CoreStore>();
    coreStore.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'images/saudetv.png',
          width: width * 0.5,
        ),
      ),
    );
  }
}

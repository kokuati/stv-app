import 'package:flutter/material.dart';
import 'package:saudetv/app/core/domain/usecases/internet_is_connected.dart';
import 'package:saudetv/app/core/presenter/pages/splash_page.dart';

class PageStore {
  final IInternetIsConnected isConnected;

  PageStore({required this.isConnected});

  ValueNotifier<Widget> page = ValueNotifier(const SplashPage());
  ValueNotifier<bool> isConnect = ValueNotifier(true);

  Future<void> checkInternet() async {
    final result = await isConnected.call();
    isConnect.value = result.fold((l) => false, (r) => r);
  }
}

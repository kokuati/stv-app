import 'package:flutter/material.dart';

import 'package:saudetv/app/core/domain/usecases/get_date_utc.dart';
import 'package:saudetv/app/core/domain/usecases/internet_is_connected.dart';
import 'package:saudetv/app/core/presenter/pages/splash_page.dart';

class PageStore {
  final IInternetIsConnected isConnected;
  final IGetDateUTC getDateUTC;

  PageStore({
    required this.isConnected,
    required this.getDateUTC,
  });

  ValueNotifier<Widget> page = ValueNotifier(const SplashPage());
  ValueNotifier<DateTime> dateSys = ValueNotifier(DateTime.now().toUtc());
  bool _isConnect = true;

  DateTime get dateUTC => dateSys.value;
  bool get isConnect => _isConnect;

  Future<void> setDateUCT() async {
    if (_isConnect) {
      final date = await getDateUTC();
      date.fold((l) => null, (r) {
        dateSys.value = r;
      });
    }
  }

  Future<void> checkInternet() async {
    final result = await isConnected.call();
    _isConnect = result.fold((l) => false, (r) => r);
  }

  Future<void> upDataTime() async {
    dateSys.value = dateSys.value.add(const Duration(minutes: 1));
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

abstract class CheckInternetService {
  Future<bool> checkInternet();

  ValueNotifier<bool> tokeIsVald = ValueNotifier(false);
}

class CheckInternetServiceConnectivityPlus extends CheckInternetService {
  @override
  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.wifi;
  }
}

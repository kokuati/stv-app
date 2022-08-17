import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:saudetv/app/services/check_internet/check_internet_interface.dart';

class ConnectivityPlusService extends CheckInternetInterface {
  @override
  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.wifi;
  }
}

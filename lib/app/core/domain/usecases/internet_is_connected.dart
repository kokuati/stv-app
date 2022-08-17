import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/services/check_internet/check_internet_interface.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IInternetIsConnected {
  Future<Either<Errors, bool>> call();
}

class InternetIsConnected extends IInternetIsConnected {
  final CheckInternetInterface chackInternetInterface;
  InternetIsConnected({
    required this.chackInternetInterface,
  });

  @override
  Future<Either<Errors, bool>> call() async {
    try {
      return right(await chackInternetInterface.checkInternet());
    } catch (e) {
      return left(Empty());
    }
  }
}

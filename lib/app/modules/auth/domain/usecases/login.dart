import 'package:saudetv/app/core/domain/usecases/get_terminal.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/domain/usecases/get_user.dart';
import 'package:saudetv/app/services/check_internet/check_internet_interface.dart';
import 'package:saudetv/app/types/either.dart';

import '../../../../core/domain/adapter/login_source.dart';

abstract class ILogin {
  Future<Either<Empty, LoginSource>> call(
      String email, String password, String terminal);
}

class Login extends ILogin {
  final CheckInternetInterface checkInternet;
  final IGetUser getUser;
  final IGetTerminal getTerminal;
  Login({
    required this.checkInternet,
    required this.getUser,
    required this.getTerminal,
  });

  @override
  Future<Either<Empty, LoginSource>> call(
      String email, String password, String terminal) async {
    final internetResult = await checkInternet.checkInternet();
    if (internetResult) {
      final resultUser = await getUser.call(email, password, terminal);
      return resultUser
          .fold((userError) => left(Empty(message: userError.message)),
              (userEntity) async {
        final resultTerminal =
            await getTerminal.call(terminal, userEntity.token);
        return resultTerminal.fold(
            (terminalError) => left(Empty(message: terminalError.message)),
            (terminalEntity) {
          return right(LoginSource(userEntity, terminalEntity));
        });
      });
    } else {
      return left(Empty(message: 'Sem Internt'));
    }
  }
}

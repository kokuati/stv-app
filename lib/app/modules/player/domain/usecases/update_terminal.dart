import 'package:saudetv/app/core/domain/adapter/login_source.dart';
import 'package:saudetv/app/core/domain/usecases/get_terminal.dart';
import 'package:saudetv/app/core/domain/usecases/get_user.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IUpdateTerminal {
  Future<Either<Errors, LoginSource>> call(LoginSource loginSource);
}

class UpdateTerminal extends IUpdateTerminal {
  final IGetUser getUser;
  final IGetTerminal getTerminal;
  UpdateTerminal({
    required this.getUser,
    required this.getTerminal,
  });

  @override
  Future<Either<Errors, LoginSource>> call(LoginSource loginSource) async {
    final terminalResult = await getTerminal(
        loginSource.userEntity.terminal, loginSource.userEntity.token);
    return terminalResult.fold((l) async {
      final userResult = await getUser(loginSource.userEntity.user,
          loginSource.userEntity.password, loginSource.userEntity.terminal);
      return userResult.fold((l) => left(l), (userEntity) async {
        final newTerminalResult = await getTerminal(
            loginSource.userEntity.terminal, loginSource.userEntity.token);
        return newTerminalResult.fold((l) => left(l), (terminalEntity) {
          return right(LoginSource(userEntity, terminalEntity));
        });
      });
    },
        (terminalEntity) =>
            right(LoginSource(loginSource.userEntity, terminalEntity)));
  }
}

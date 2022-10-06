import 'package:saudetv/app/core/domain/entities/user_entity.dart';
import 'package:saudetv/app/core/domain/usecases/save_user.dart';
import '../../errors/errors.dart';
import '../../../types/either.dart';
import '../repositories/user_repository_i.dart';

abstract class IGetUser {
  Future<Either<UserError, UserEntity>> call(
      String email, String password, String terminal);
}

class GetUser implements IGetUser {
  final IUserRepository repository;
  final ISaveUser saveUser;

  GetUser({
    required this.repository,
    required this.saveUser,
  });

  @override
  Future<Either<UserError, UserEntity>> call(
      String email, String password, String terminal) async {
    final result = await repository.getUser(email, password, terminal);
    return result.fold((error) {
      if (error.statusCode == 400 || error.statusCode == 404) {
        return left(UserError(message: 'Usuário e/ou senha inválidos'));
      } else {
        return left(UserError(
            message:
                'Ocorreu um erro. tente novamente mais tarde - ${error.statusCode}'));
      }
    }, (mode) async {
      if (mode.terminalList.isEmpty) {
        return left(
            UserError(message: 'Usuário não possui terminal cadastrado'));
      } else {
        if (mode.terminalIsValid()) {
          final UserEntity entity = UserEntity(
            user: mode.user,
            password: mode.password,
            terminalList: mode.terminalList,
            terminal: mode.terminal,
            token: mode.token,
          );
          await saveUser(entity);
          return right(entity);
        } else {
          return left(UserError(message: 'Terminal inválidos'));
        }
      }
    });
  }
}

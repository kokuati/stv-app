import '../../../types/either.dart';
import '../../errors/errors.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository_i.dart';

abstract class ISaveUser {
  Future<Either<Errors, bool>> call(UserEntity entity);
}

class SaveUser implements ISaveUser {
  final IUserRepository repository;

  SaveUser({required this.repository});

  @override
  Future<Either<UserError, bool>> call(UserEntity entity) async {
    final result = await repository.saveUser(entity);
    return result.fold((error) {
      return left(UserError(message: 'Não foi possivel salvar'));
    }, (entity) {
      return right(entity);
    });
  }
}

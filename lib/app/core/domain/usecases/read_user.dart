import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

import '../entities/user_entity.dart';
import '../repositories/user_repository_i.dart';

abstract class IReadUser {
  Future<Either<Errors, UserEntity>> call();
}

class ReadUser implements IReadUser {
  final IUserRepository repository;

  ReadUser({required this.repository});

  @override
  Future<Either<UserError, UserEntity>> call() async {
    final result = await repository.readUser();
    return result.fold((error) {
      return left(UserError(message: 'Não possui usuario cadastrado'));
    }, (entity) {
      return right(entity);
    });
  }
}

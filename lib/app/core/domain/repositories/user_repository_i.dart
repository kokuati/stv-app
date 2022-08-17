import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/infra/models/user_model.dart';

import '../../../types/either.dart';
import '../entities/user_entity.dart';

abstract class IUserRepository {
  Future<Either<Errors, bool>> saveUser(UserEntity entity);
  Future<Either<Errors, UserEntity>> readUser();
  Future<Either<HttpError, UserModel>> getUser(
      String email, String password, String terminal);
}

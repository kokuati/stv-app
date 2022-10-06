import 'package:saudetv/app/core/domain/entities/user_entity.dart';
import 'package:saudetv/app/core/domain/repositories/user_repository_i.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/infra/datasources/user_local_datasource_i.dart';
import 'package:saudetv/app/core/infra/datasources/user_remote_datasource_i.dart';
import 'package:saudetv/app/core/infra/models/user_model.dart';
import 'package:saudetv/app/types/either.dart';

class UserRepository extends IUserRepository {
  final IUserLocalDataSource localDataSource;
  final IUserRemoteDataSource remoteDataSource;

  UserRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Errors, UserEntity>> readUser() async {
    try {
      final result = await localDataSource.readUser();
      return right(result);
    } catch (e) {
      return left(Empty());
    }
  }

  @override
  Future<Either<Errors, bool>> saveUser(UserEntity entity) async {
    final model = UserModel(
      user: entity.user,
      password: entity.password,
      terminalList: entity.terminalList,
      terminal: entity.terminal,
      token: entity.token,
    );
    try {
      final result = await localDataSource.saveUser(model);
      return right(result);
    } catch (e) {
      return left(Empty());
    }
  }

  @override
  Future<Either<HttpError, UserModel>> getUser(
      String email, String password, String terminal) async {
    try {
      return right(await remoteDataSource.getUser(email, password, terminal));
    } catch (e) {
      if (e is int) {
        return left(HttpError(statusCode: e));
      } else {
        return left(HttpError(statusCode: 0));
      }
    }
  }
}

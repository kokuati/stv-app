import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/domain/entities/contents_entity.dart';
import 'package:saudetv/app/modules/player/domain/repositories/contents_repository_i.dart';
import 'package:saudetv/app/modules/player/infra/datasources/contents_local_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/datasources/contents_remote_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';
import 'package:saudetv/app/types/either.dart';

class ContentsRepository extends IContentsRepository {
  final IContentsLocalDataSource localDataSource;
  final IContentsRemoteDataSource remoteDataSource;
  ContentsRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Errors, bool>> deleteContents(String contentsID) async {
    try {
      return right(await localDataSource.deleteContents(contentsID));
    } catch (e) {
      return left(Empty());
    }
  }

  @override
  Future<Either<HttpError, ContentsModel>> getContents(
      String contentsID, String token) async {
    try {
      return right(await remoteDataSource.getContents(contentsID, token));
    } catch (e) {
      if (e is int) {
        return left(HttpError(statusCode: e));
      } else {
        return left(HttpError(statusCode: 0));
      }
    }
  }

  @override
  Future<Either<Errors, ContentsEntity>> readContents(String contentsID) async {
    try {
      return right(await localDataSource.readContents(contentsID));
    } catch (e) {
      return left(Empty());
    }
  }

  @override
  Future<Either<Errors, bool>> saveContents(ContentsEntity entity) async {
    final model = ContentsModel(
        id: entity.id,
        type: entity.type,
        contents: entity.contents,
        updateData: entity.updateData);
    try {
      return right(await localDataSource.saveContents(model));
    } catch (e) {
      return left(Empty());
    }
  }
}

import 'package:saudetv/app/core/domain/repositories/core_repository_i.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/infra/datasources/core_local_datasource_i.dart';
import 'package:saudetv/app/types/either.dart';

class CoreRepository extends ICoreRepository {
  final ICoreLocalDataSource coreLocalDataSource;

  CoreRepository({
    required this.coreLocalDataSource,
  });

  @override
  Future<Either<Errors, bool>> deleteAll() async {
    try {
      final result = await coreLocalDataSource.deleteAll();
      return right(result);
    } catch (e) {
      return left(Empty(message: e.toString()));
    }
  }
}

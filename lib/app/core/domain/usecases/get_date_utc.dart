import 'package:saudetv/app/core/domain/repositories/date_utc_repository_i.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IGetDateUTC {
  Future<Either<Empty, DateTime>> call();
}

class GetDateUTC extends IGetDateUTC {
  final IDateUTCRepository repository;
  GetDateUTC({
    required this.repository,
  });

  @override
  Future<Either<Empty, DateTime>> call() async {
    final result = await repository.getDateUTC();
    return result.fold(
        (error) => left(Empty(
            message: 'Falha na conexão: Status Code => ${error.statusCode}')),
        (date) => right(date));
  }
}

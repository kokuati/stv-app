import 'package:saudetv/app/core/domain/entities/terminal_entity.dart';
import 'package:saudetv/app/core/domain/repositories/terminal_repository_i.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/infra/datasources/terminal_local_datasource_i.dart';
import 'package:saudetv/app/core/infra/datasources/terminal_remote_datasource_i.dart';
import 'package:saudetv/app/core/infra/models/terminal_model.dart';
import 'package:saudetv/app/types/either.dart';

class TerminalRepository extends ITerminalRepository {
  final ITerminalLocalDataSource localDataSource;
  final ITerminalRemoteDataSource remoteDataSource;

  TerminalRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<HttpError, TerminalEntity>> getTerminal(
      String terminalID, String token) async {
    try {
      return right(await remoteDataSource.getTerminal(terminalID, token));
    } catch (e) {
      if (e is int) {
        return left(HttpError(statusCode: e));
      } else {
        return left(HttpError(statusCode: 0));
      }
    }
  }

  @override
  Future<Either<Errors, TerminalEntity>> readTerminal() async {
    try {
      return right(await localDataSource.readTerminal());
    } catch (e) {
      return left(Empty());
    }
  }

  @override
  Future<Either<Errors, bool>> saveTerminal(TerminalEntity entity) async {
    final model = TerminalModel(
        id: entity.id,
        contentsList: entity.contentsList,
        hasBar: entity.hasBar,
        updateStartHour: entity.updateStartHour,
        updateStartMinute: entity.updateStartMinute,
        updateEndHour: entity.updateEndHour,
        updateEndMinute: entity.updateEndMinute,
        updateTimeCourseMin: entity.updateTimeCourseMin,
        lat: entity.lat,
        lon: entity.lon);
    try {
      return right(await localDataSource.saveTerminal(model));
    } catch (e) {
      return left(Empty());
    }
  }
}

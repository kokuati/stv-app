import 'package:saudetv/app/core/domain/entities/terminal_entity.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

abstract class ITerminalRepository {
  Future<Either<Errors, bool>> saveTerminal(TerminalEntity entity);
  Future<Either<Errors, TerminalEntity>> readTerminal();
  Future<Either<HttpError, TerminalEntity>> getTerminal(
      String terminalID, String token);
}

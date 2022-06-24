import 'package:saudetv/app/core/domain/entities/terminal_entity.dart';
import 'package:saudetv/app/core/domain/repositories/terminal_repository_i.dart';
import 'package:saudetv/app/core/domain/usecases/save_terminal.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IGetTerminal {
  Future<Either<TerminalError, TerminalEntity>> call(
      String terminalID, String token);
}

class GetTerminal extends IGetTerminal {
  final ITerminalRepository terminalRepository;
  final ISaveTerminal saveTerminal;

  GetTerminal({
    required this.terminalRepository,
    required this.saveTerminal,
  });

  @override
  Future<Either<TerminalError, TerminalEntity>> call(
      String terminalID, String token) async {
    final result = await terminalRepository.getTerminal(terminalID, token);
    return result.fold((error) {
      if (error.statusCode == 400 || error.statusCode == 404) {
        return left(TerminalError(message: 'Terminal inválidos'));
      } else {
        return left(TerminalError(
            message: 'Ocorreu um erro. tente novamente mais tarde'));
      }
    }, (entity) async {
      await saveTerminal(entity);
      return right(entity);
    });
  }
}

import 'package:saudetv/app/core/domain/entities/terminal_entity.dart';
import 'package:saudetv/app/core/domain/repositories/terminal_repository_i.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

abstract class ISaveTerminal {
  Future<Either<Errors, bool>> call(TerminalEntity entity);
}

class SaveTerminal implements ISaveTerminal {
  final ITerminalRepository repository;

  SaveTerminal({required this.repository});

  @override
  Future<Either<TerminalError, bool>> call(TerminalEntity entity) async {
    final result = await repository.saveTerminal(entity);
    return result.fold((error) {
      return left(TerminalError(message: 'Não foi possivel salvar'));
    }, (entity) => right(entity));
  }
}

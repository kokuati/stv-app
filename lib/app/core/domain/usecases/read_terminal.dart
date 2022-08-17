import 'package:saudetv/app/core/domain/entities/terminal_entity.dart';
import 'package:saudetv/app/core/domain/repositories/terminal_repository_i.dart';
import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/types/either.dart';

abstract class IReadTerminal {
  Future<Either<Errors, TerminalEntity>> call();
}

class ReadTerminal implements IReadTerminal {
  final ITerminalRepository repository;

  ReadTerminal({required this.repository});

  @override
  Future<Either<TerminalError, TerminalEntity>> call() async {
    final result = await repository.readTerminal();
    return result.fold((error) {
      return left(TerminalError(message: 'Não possui usuario cadastrado'));
    }, (entity) {
      return right(entity);
    });
  }
}

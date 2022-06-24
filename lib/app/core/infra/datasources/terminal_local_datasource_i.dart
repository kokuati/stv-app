import 'package:saudetv/app/core/infra/models/terminal_model.dart';

abstract class ITerminalLocalDataSource {
  Future<TerminalModel> readTerminal();
  Future<bool> saveTerminal(TerminalModel model);
}

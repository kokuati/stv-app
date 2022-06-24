import 'package:saudetv/app/core/infra/models/terminal_model.dart';

abstract class ITerminalRemoteDataSource {
  Future<TerminalModel> getTerminal(String terminalID, String token);
}

import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalDatasourece {
  Future<String> getTerminal();
  Future<bool> saveTerminal(String terminal);
}

class LocalDatasourece extends ILocalDatasourece {
  final String terminalKey;

  LocalDatasourece(this.terminalKey);

  @override
  Future<String> getTerminal() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString(terminalKey) ?? '';
  }

  @override
  Future<bool> saveTerminal(String terminal) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString(terminalKey, terminal);
    return true;
  }
}

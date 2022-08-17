import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/infra/datasources/terminal_local_datasource_i.dart';
import 'package:saudetv/app/core/infra/models/terminal_model.dart';
import 'package:saudetv/app/services/local_storage/adapters/shared_params.dart';
import 'package:saudetv/app/services/local_storage/local_storage_interface.dart';

class TerminalLocalDataSource extends ITerminalLocalDataSource {
  final ILocalStorage localStorage;

  TerminalLocalDataSource({required this.localStorage});

  @override
  Future<TerminalModel> readTerminal() async {
    try {
      final String source = await localStorage.getData('keyTerminal');
      return TerminalModel.fromJson(source);
    } catch (e) {
      throw Empty();
    }
  }

  @override
  Future<bool> saveTerminal(TerminalModel model) async {
    final json = model.toJson();
    final params = SharedParams(key: 'keyTerminal', value: json);
    try {
      return await localStorage.setData(params: params);
    } catch (e) {
      throw Empty();
    }
  }
}

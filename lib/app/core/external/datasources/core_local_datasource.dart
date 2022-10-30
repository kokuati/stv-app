import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/infra/datasources/core_local_datasource_i.dart';
import 'package:saudetv/app/services/local_storage/local_storage_interface.dart';

class CoreLocalDataSource extends ICoreLocalDataSource {
  final ILocalStorage localStorage;

  CoreLocalDataSource({required this.localStorage});

  @override
  Future<bool> deleteAll() async {
    try {
      return await localStorage.removeAll();
    } catch (e) {
      throw Empty();
    }
  }
}

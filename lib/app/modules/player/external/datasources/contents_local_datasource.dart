import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/modules/player/infra/datasources/contents_local_datasource_i.dart';
import 'package:saudetv/app/modules/player/infra/models/contents_model.dart';
import 'package:saudetv/app/services/local_storage/adapters/shared_params.dart';
import 'package:saudetv/app/services/local_storage/local_storage_interface.dart';

class ContentsLocalDataSource extends IContentsLocalDataSource {
  final ILocalStorage localStorage;

  ContentsLocalDataSource({required this.localStorage});

  @override
  Future<bool> deleteContents(String contentsID) async {
    try {
      return await localStorage.removeData(contentsID);
    } catch (e) {
      throw Empty();
    }
  }

  @override
  Future<ContentsModel> readContents(String contentsID) async {
    try {
      final String source = await localStorage.getData(contentsID);
      return ContentsModel.fromJson(source);
    } catch (e) {
      throw Empty();
    }
  }

  @override
  Future<bool> saveContents(ContentsModel model) async {
    final json = model.toJson();
    final params = SharedParams(key: model.id, value: json);
    try {
      return await localStorage.setData(params: params);
    } catch (e) {
      throw Empty();
    }
  }
}

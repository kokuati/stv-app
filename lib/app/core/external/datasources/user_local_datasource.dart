import 'package:saudetv/app/core/errors/errors.dart';
import 'package:saudetv/app/core/infra/datasources/user_local_datasource_i.dart';
import 'package:saudetv/app/core/infra/models/user_model.dart';
import 'package:saudetv/app/services/local_storage/adapters/shared_params.dart';
import 'package:saudetv/app/services/local_storage/local_storage_interface.dart';

class UserLocalDataSource extends IUserLocalDataSource {
  final ILocalStorage localStorage;

  UserLocalDataSource({required this.localStorage});

  @override
  Future<UserModel> readUser() async {
    try {
      final String source = await localStorage.getData('keyUser');
      return UserModel.fromJson(source);
    } catch (e) {
      throw Empty();
    }
  }

  @override
  Future<bool> saveUser(UserModel model) async {
    final json = model.toJson();
    final params = SharedParams(key: 'keyUser', value: json);
    try {
      return await localStorage.setData(params: params);
    } catch (e) {
      throw Empty();
    }
  }
}

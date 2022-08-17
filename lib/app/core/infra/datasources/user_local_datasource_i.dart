import 'package:saudetv/app/core/infra/models/user_model.dart';

abstract class IUserLocalDataSource {
  Future<UserModel> readUser();
  Future<bool> saveUser(UserModel model);
}

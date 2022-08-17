import 'package:saudetv/app/core/infra/models/user_model.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> getUser(String email, String password, String terminal);
}

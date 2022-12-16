import 'package:dio/dio.dart';
import 'package:saudetv/app/core/infra/datasources/user_remote_datasource_i.dart';
import 'package:saudetv/app/core/infra/models/user_model.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';

class UserRemoteDataSource extends IUserRemoteDataSource {
  final String baseURL;
  final ClientHttpInterface clientHttp;
  UserRemoteDataSource({
    required this.baseURL,
    required this.clientHttp,
  });

  @override
  Future<UserModel> getUser(
      String email, String password, String terminal) async {
    clientHttp.setBaseUrl(baseURL);
    try {
      final response = await clientHttp.post('/auth',
          data: {"email": email, "password": password, "terminal": terminal});
      final Map data = response.data["data"];
      final List<String> terminalList = [];
      for (var item in data["customer"]["terminals"]) {
        if (item.toString().isNotEmpty) {
          terminalList.add(item.toString());
        }
      }
      final UserModel model = UserModel(
        user: email,
        password: password,
        terminalList: terminalList,
        terminal: terminal,
        token: data["auth"]["clientToken"],
      );
      return model;
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}

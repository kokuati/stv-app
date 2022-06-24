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
    clientHttp.setConnectTimeout(50000);
    clientHttp.setReceiveTimeout(50000);

    try {
      final response = await clientHttp
          .post('/auth', data: {"email": email, "password": password});
      final Map data = response.data["data"];
      final List<String> terminalList = [];
      for (var item in data["customer"]["terminals"]) {
        terminalList.add(item);
      }
      final UserModel model = UserModel(
        user: email,
        password: password,
        terminalList: terminalList,
        terminal: terminal,
        token: data["auth"]["token"],
        logo: data["customer"]["logo"],
      );
      return model;
    } on DioError catch (e) {
      throw e.response!.statusCode!;
    } catch (e) {
      throw 0;
    }
  }
}

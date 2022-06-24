import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saudetv/app/services/client_http/client_http_interface.dart';
import 'package:saudetv/app/services/client_http/dio_client_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioMock extends Mock implements DioForNative {}

class SharedMock extends Mock implements SharedPreferences {}

class DioClientHttpMock extends Mock implements DioClientHttp {}

class BaseResponseMock extends Mock implements BaseResponse {}

class ResponseMock extends Mock implements Response {}

class DioInterceptorMock extends Mock implements DioInterceptor {}

class DioErrorMock extends Mock implements DioError {}

class RequestOptionsMock extends Mock implements RequestOptions {}

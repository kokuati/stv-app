abstract class ClientHttpInterface {
  Future<BaseResponse> get(String path);
  Future<BaseResponse> download(String path, String savePath);
  Future<BaseResponse> post(String path, {Map<String, dynamic>? data});
  Future<BaseResponse> put(String path, {Map<String, dynamic>? data});
  Future<BaseResponse> upload(String path, {List<int>? data});
  Future<BaseResponse> delete(String path);
  void setBaseUrl(String url);
  void setConnectTimeout(int time);
  void setReceiveTimeout(int time);
  void setHeaders(Map<String, String> header);
  void addInterceptor(BaseInterceptor interceptor);
  void removeInterceptor(BaseInterceptor interceptor);
}

abstract class BaseInterceptor<TRequest, TResponse, TError> {
  Future<TRequest> onRequest(TRequest request);
  Future<TResponse> onResponse(TResponse response);
  Future<TError> onError(TError error);
}

class BaseResponse {
  final int statusCode;
  final dynamic data;
  final BaseRequest request;

  const BaseResponse(this.data, this.request, [this.statusCode = 200]);
}

class BaseRequest {
  final String url;
  final dynamic data;
  final Map<String, String> headers;
  final String method;

  BaseRequest({
    required this.url,
    this.data,
    this.headers = const {},
    required this.method,
  });
}

class BaseError implements Exception {
  final Exception? exception;
  final String message;
  final StackTrace? stackTrace;
  final BaseRequest? request;

  const BaseError(this.message,
      [this.request, this.stackTrace, this.exception]);

  @override
  String toString() {
    return '''$runtimeType: $message. ${stackTrace == null ? '' : '\n$stackTrace'}''';
  }
}

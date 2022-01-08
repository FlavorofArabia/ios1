import 'package:dio/dio.dart';
import '../../config/logger.dart';

String dioErrorHandle(DioError error) {
  UtilLogger.log("ERROR", error);
  print('error.type');
  print(error.type);
  switch (error.type) {
    case DioErrorType.response:
      print(error.response);
      if (error.response!.data != null) {
        if (error.response!.data['error'] != null &&
            error.response!.data['error'].length > 0) {
          return error.response!.data['error'][0].toString();
        }
      }
      return error.response!.data ??
          'Unknown error ${error.response!.statusCode}';

    case DioErrorType.sendTimeout:
    case DioErrorType.connectTimeout:
    case DioErrorType.receiveTimeout:
      return "request time out";

    case DioErrorType.other:
      print('error.error');
      print(error.error);

      return '${error.error}';

    default:
      return "connection to server failed ${error.response!.statusCode}";
  }
}

class HTTPManager {
  BaseOptions baseOptions = BaseOptions(
    // baseUrl: Globals.host,
    connectTimeout: 15000,
    receiveTimeout: 15000,
    headers: {
      'X-Oc-Merchant-Id': 'qycHglC3tfBqhajWS2LzZfDFwq4LMFTq',
      // 'X-Oc-Session': 'b6a97ed71dc8b31f6ad1bccadb',
    },
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );

  // Get method
  Future<dynamic> get({
    String? url,
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    UtilLogger.log("Header", baseOptions.headers);
    UtilLogger.log("GET URL", url);
    UtilLogger.log("PARAMS", params);
    Dio dio = new Dio(baseOptions);
    try {
      final response = await dio.get(
        url!,
        queryParameters: params,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      return {"message": dioErrorHandle(error)};
    }
  }

  // Post method
  Future<dynamic> post({
    String? url,
    dynamic data,
    Options? options,
  }) async {
    UtilLogger.log("HEADER", baseOptions.headers);
    UtilLogger.log("POST URL", url);
    UtilLogger.log("DATA", data);
    Dio dio = new Dio(baseOptions);
    try {
      final response = await dio.post(
        url!,
        data: data,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      return {"message": dioErrorHandle(error)};
    }
  }

  // Put method
  Future<dynamic> put({
    String? url,
    data,
    Options? options,
  }) async {
    UtilLogger.log("HEADER", baseOptions.headers);
    UtilLogger.log("Put URL", url);
    UtilLogger.log("DATA", data);
    Dio dio = new Dio(baseOptions);
    try {
      final response = await dio.put(
        url!,
        data: data,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      return {"message": dioErrorHandle(error)};
    }
  }

  // Delete method
  Future<dynamic> delete({
    String? url,
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    UtilLogger.log("HEADER", baseOptions.headers);
    UtilLogger.log("Delete URL", url);
    Dio dio = new Dio(baseOptions);
    try {
      final response = await dio.delete(
        url!,
        data: data,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      return {"message": dioErrorHandle(error)};
    }
  }

  factory HTTPManager() {
    return HTTPManager._internal();
  }

  HTTPManager._internal();
}

HTTPManager httpManager = HTTPManager();

import 'package:dio/dio.dart';
import 'package:flutter_task_app/utils/project_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final listOfPaths = ProjectConstant.routes;

    if (listOfPaths.contains(options.path.toString())) {
      return handler.next(options);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.getString('token');
    var token = prefs.getString('token') ?? '';
    options.headers.addAll({'Authorization': 'Bearer $token'});
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}

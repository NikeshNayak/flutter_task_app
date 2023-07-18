import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_app/utils/auth_interceptor.dart';

Dio get dio => DioClient.instance.dio;

class DioClient {
  static final instance = DioClient._();

  DioClient._() {
    dio.interceptors
      ..add(
        InterceptorsWrapper(
          onResponse: (e, handler) {
            if (kDebugMode) {
              print(
                '${e.requestOptions.method} ${e.statusCode} ${e.requestOptions.uri}',
              );
            }
            handler.next(e);
          },
        ),
      )
      ..add(AuthInterceptor());
  }

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://yourdomainorip.com/api/v1',
    ),
  );
}

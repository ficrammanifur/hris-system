import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:mobile_flutter/core/constants/api_constants.dart';
import 'package:mobile_flutter/data/datasources/local/secure_storage.dart';

class DioClient {
  late final Dio dio;
  
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Add interceptors
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          // Handle 401 Unauthorized
          if (e.response?.statusCode == 401) {
            await SecureStorage.deleteToken();
            // Navigate to login screen
          }
          return handler.next(e);
        },
      ),
    );
  }
  
  // Helper methods untuk testing
  void updateToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  void removeToken() {
    dio.options.headers.remove('Authorization');
  }
}
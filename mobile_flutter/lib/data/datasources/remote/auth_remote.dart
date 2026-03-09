import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mobile_flutter/core/constants/api_constants.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/data/models/user_model.dart';
import 'package:mobile_flutter/data/models/api_response.dart';
import 'package:mobile_flutter/data/datasources/remote/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<Map<String, dynamic>>> login(String email, String password);
  Future<ApiResponse<void>> logout();
  Future<ApiResponse<User>> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  
  AuthRemoteDataSourceImpl({required this.dioClient});
  
  @override
  Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
  
  @override
  Future<ApiResponse<void>> logout() async {
    try {
      final response = await dioClient.dio.post(ApiConstants.logout);
      return ApiResponse.fromJson(response.data, (data) => null);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
  
  @override
  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await dioClient.dio.get(ApiConstants.me);
      return ApiResponse.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
  
  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw NetworkException('No internet connection');
    }
    
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException('Invalid credentials');
    }
    
    if (e.response?.statusCode == 422) {
      throw ValidationException(e.response?.data['errors'] ?? {});
    }
    
    throw ServerException(
      message: e.response?.data['message'] ?? 'Something went wrong',
      statusCode: e.response?.statusCode,
    );
  }
}
import 'package:dio/dio.dart';
import 'package:mobile_flutter/core/constants/api_constants.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/data/models/leave_model.dart';
import 'package:mobile_flutter/data/models/api_response.dart';
import 'package:mobile_flutter/data/datasources/remote/dio_client.dart';

abstract class LeaveRemoteDataSource {
  Future<ApiResponse<List<Leave>>> getLeaves({
    String? status,
    int? userId,
  });
  
  Future<ApiResponse<Leave>> submitLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    required String reason,
  });
  
  Future<ApiResponse<LeaveBalance>> getLeaveBalance(int userId);
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final DioClient dioClient;
  
  LeaveRemoteDataSourceImpl({required this.dioClient});
  
  @override
  Future<ApiResponse<List<Leave>>> getLeaves({
    String? status,
    int? userId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (userId != null) queryParams['user_id'] = userId;
      
      final response = await dioClient.dio.get(
        ApiConstants.leaves,
        queryParameters: queryParams,
      );
      
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map((l) => Leave.fromJson(l))
            .toList(),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
  
  @override
  Future<ApiResponse<Leave>> submitLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    required String reason,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.leaves,
        data: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
          'type': type,
          'reason': reason,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (data) => Leave.fromJson(data),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
  
  @override
  Future<ApiResponse<LeaveBalance>> getLeaveBalance(int userId) async {
    try {
      final response = await dioClient.dio.get(
        '${ApiConstants.leaveBalance}/$userId',
      );
      
      return ApiResponse.fromJson(
        response.data,
        (data) => LeaveBalance.fromJson(data),
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
      throw UnauthorizedException('Session expired');
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
import 'package:dio/dio.dart';
import 'package:mobile_flutter/core/constants/api_constants.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/data/models/attendance_model.dart';
import 'package:mobile_flutter/data/models/api_response.dart';
import 'package:mobile_flutter/data/datasources/remote/dio_client.dart';

abstract class AttendanceRemoteDataSource {
  Future<ApiResponse<Attendance>> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  });
  
  Future<ApiResponse<Attendance>> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  });
  
  Future<ApiResponse<List<Attendance>>> getAttendances({
    int? userId,
    DateTime? date,
    int? month,
    int? year,
  });
  
  Future<ApiResponse<AttendanceSummary>> getSummary({
    required int userId,
    required int month,
    required int year,
  });
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final DioClient dioClient;
  
  AttendanceRemoteDataSourceImpl({required this.dioClient});
  
  @override
  Future<ApiResponse<Attendance>> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.checkIn,
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'notes': notes,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (data) => Attendance.fromJson(data),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
  
  @override
  Future<ApiResponse<Attendance>> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.checkOut,
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'notes': notes,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (data) => Attendance.fromJson(data),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
  
  @override
  Future<ApiResponse<List<Attendance>>> getAttendances({
    int? userId,
    DateTime? date,
    int? month,
    int? year,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['user_id'] = userId;
      if (date != null) queryParams['date'] = date.toIso8601String().split('T')[0];
      if (month != null) queryParams['month'] = month;
      if (year != null) queryParams['year'] = year;
      
      final response = await dioClient.dio.get(
        ApiConstants.attendance,
        queryParameters: queryParams,
      );
      
      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map((a) => Attendance.fromJson(a))
            .toList(),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
  
  @override
  Future<ApiResponse<AttendanceSummary>> getSummary({
    required int userId,
    required int month,
    required int year,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '${ApiConstants.attendanceSummary}/$userId',
        queryParameters: {
          'month': month,
          'year': year,
        },
      );
      
      return ApiResponse.fromJson(
        response.data,
        (data) => AttendanceSummary.fromJson(data),
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
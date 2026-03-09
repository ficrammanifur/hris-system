import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/data/datasources/remote/attendance_remote.dart';
import 'package:mobile_flutter/data/models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<Attendance> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  });
  
  Future<Attendance> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  });
  
  Future<List<Attendance>> getAttendances({
    int? userId,
    DateTime? date,
    int? month,
    int? year,
  });
  
  Future<AttendanceSummary> getSummary({
    required int userId,
    required int month,
    required int year,
  });
}

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;
  
  AttendanceRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Attendance> checkIn({
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final response = await remoteDataSource.checkIn(
        latitude: latitude,
        longitude: longitude,
        notes: notes,
      );
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        throw ServerFailure(message: response.message ?? 'Check-in failed');
      }
    } on UnauthorizedException {
      throw UnauthorizedFailure(message: 'Session expired');
    } on NetworkException {
      throw NetworkFailure(message: 'No internet connection');
    } on ValidationException catch (e) {
      throw ValidationFailure(
        message: 'Validation failed',
        errors: e.errors,
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
  
  @override
  Future<Attendance> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    try {
      final response = await remoteDataSource.checkOut(
        latitude: latitude,
        longitude: longitude,
        notes: notes,
      );
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        throw ServerFailure(message: response.message ?? 'Check-out failed');
      }
    } on UnauthorizedException {
      throw UnauthorizedFailure(message: 'Session expired');
    } on NetworkException {
      throw NetworkFailure(message: 'No internet connection');
    } on ValidationException catch (e) {
      throw ValidationFailure(
        message: 'Validation failed',
        errors: e.errors,
      );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
  
  @override
  Future<List<Attendance>> getAttendances({
    int? userId,
    DateTime? date,
    int? month,
    int? year,
  }) async {
    try {
      final response = await remoteDataSource.getAttendances(
        userId: userId,
        date: date,
        month: month,
        year: year,
      );
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        throw ServerFailure(message: response.message ?? 'Failed to get attendances');
      }
    } on UnauthorizedException {
      throw UnauthorizedFailure(message: 'Session expired');
    } on NetworkException {
      throw NetworkFailure(message: 'No internet connection');
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
  
  @override
  Future<AttendanceSummary> getSummary({
    required int userId,
    required int month,
    required int year,
  }) async {
    try {
      final response = await remoteDataSource.getSummary(
        userId: userId,
        month: month,
        year: year,
      );
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        throw ServerFailure(message: response.message ?? 'Failed to get summary');
      }
    } on UnauthorizedException {
      throw UnauthorizedFailure(message: 'Session expired');
    } on NetworkException {
      throw NetworkFailure(message: 'No internet connection');
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
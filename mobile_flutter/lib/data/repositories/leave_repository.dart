import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/data/datasources/remote/leave_remote.dart';
import 'package:mobile_flutter/data/models/leave_model.dart';

abstract class LeaveRepository {
  Future<List<Leave>> getLeaves({
    String? status,
    int? userId,
  });
  
  Future<Leave> submitLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    required String reason,
  });
  
  Future<LeaveBalance> getLeaveBalance(int userId);
}

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;
  
  LeaveRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<Leave>> getLeaves({
    String? status,
    int? userId,
  }) async {
    try {
      final response = await remoteDataSource.getLeaves(
        status: status,
        userId: userId,
      );
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        throw ServerFailure(message: response.message ?? 'Failed to get leaves');
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
  Future<Leave> submitLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    required String reason,
  }) async {
    try {
      final response = await remoteDataSource.submitLeave(
        startDate: startDate,
        endDate: endDate,
        type: type,
        reason: reason,
      );
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        throw ServerFailure(message: response.message ?? 'Failed to submit leave');
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
  Future<LeaveBalance> getLeaveBalance(int userId) async {
    try {
      final response = await remoteDataSource.getLeaveBalance(userId);
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        throw ServerFailure(message: response.message ?? 'Failed to get balance');
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
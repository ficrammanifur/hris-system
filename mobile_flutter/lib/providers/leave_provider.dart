import 'package:flutter/material.dart';
import 'package:mobile_flutter/data/repositories/leave_repository.dart';
import 'package:mobile_flutter/data/datasources/remote/leave_remote.dart';
import 'package:mobile_flutter/data/datasources/remote/dio_client.dart';
import 'package:mobile_flutter/data/models/leave_model.dart';
import 'package:mobile_flutter/core/errors/failures.dart';

class LeaveProvider extends ChangeNotifier {
  late final LeaveRepository _leaveRepository;
  
  List<Leave> _leaves = [];
  LeaveBalance? _balance;
  
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  
  LeaveProvider() {
    final dioClient = DioClient();
    final remoteDataSource = LeaveRemoteDataSourceImpl(dioClient: dioClient);
    _leaveRepository = LeaveRepositoryImpl(remoteDataSource: remoteDataSource);
  }
  
  // Getters
  List<Leave> get leaves => _leaves;
  LeaveBalance? get balance => _balance;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  
  // Get leaves
  Future<void> getLeaves({
    String? status,
    int? userId,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      _leaves = await _leaveRepository.getLeaves(
        status: status,
        userId: userId,
      );
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // Submit leave
  Future<bool> submitLeave({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    required String reason,
  }) async {
    _isSubmitting = true;
    _clearError();
    notifyListeners();

    try {
      final leave = await _leaveRepository.submitLeave(
        startDate: startDate,
        endDate: endDate,
        type: type,
        reason: reason,
      );
      
      _leaves.insert(0, leave);
      
      // Refresh balance
      await getLeaveBalance(userId);
      
      return true;
    } on Failure catch (f) {
      _errorMessage = f.message;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
  
  // Get leave balance
  Future<void> getLeaveBalance(int userId) async {
    try {
      _balance = await _leaveRepository.getLeaveBalance(userId);
      notifyListeners();
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
  
  // Filter leaves by status
  List<Leave> getPendingLeaves() {
    return _leaves.where((l) => l.isPending).toList();
  }
  
  List<Leave> getApprovedLeaves() {
    return _leaves.where((l) => l.isApproved).toList();
  }
  
  List<Leave> getRejectedLeaves() {
    return _leaves.where((l) => l.isRejected).toList();
  }
  
  // Clear
  void clear() {
    _leaves = [];
    _balance = null;
    _errorMessage = null;
    notifyListeners();
  }
  
  // Private helpers
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
}
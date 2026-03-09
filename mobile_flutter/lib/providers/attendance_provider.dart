import 'package:flutter/material.dart';
import 'package:mobile_flutter/data/repositories/attendance_repository.dart';
import 'package:mobile_flutter/data/datasources/remote/attendance_remote.dart';
import 'package:mobile_flutter/data/datasources/remote/dio_client.dart';
import 'package:mobile_flutter/data/models/attendance_model.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceProvider extends ChangeNotifier {
  late final AttendanceRepository _attendanceRepository;
  
  List<Attendance> _attendances = [];
  AttendanceSummary? _summary;
  Attendance? _todayAttendance;
  
  bool _isLoading = false;
  bool _isCheckingIn = false;
  bool _isCheckingOut = false;
  String? _errorMessage;
  
  AttendanceProvider() {
    final dioClient = DioClient();
    final remoteDataSource = AttendanceRemoteDataSourceImpl(dioClient: dioClient);
    _attendanceRepository = AttendanceRepositoryImpl(remoteDataSource: remoteDataSource);
  }
  
  // Getters
  List<Attendance> get attendances => _attendances;
  AttendanceSummary? get summary => _summary;
  Attendance? get todayAttendance => _todayAttendance;
  bool get isLoading => _isLoading;
  bool get isCheckingIn => _isCheckingIn;
  bool get isCheckingOut => _isCheckingOut;
  String? get errorMessage => _errorMessage;
  bool get canCheckIn => _todayAttendance == null;
  bool get canCheckOut => _todayAttendance != null && _todayAttendance!.checkOutTime == null;
  
      // Check-in
    Future<bool> checkIn(
      int userId, {
      required double latitude,
      required double longitude,
      String? notes,
    }) async {
    
    try {
      // Get current position
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Location services are disabled';
        return false;
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied';
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Location permissions are permanently denied';
        return false;
      }
      
      final position = await Geolocator.getCurrentPosition();
      
      final attendance = await _attendanceRepository.checkIn(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      
      _todayAttendance = attendance;
      _attendances.insert(0, attendance);
      
      return true;
    } on Failure catch (f) {
      _errorMessage = f.message;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCheckingIn = false;
      notifyListeners();
    }
  }
  
  // Check-out
  Future<bool> checkOut(int userId) async {
    _isCheckingOut = true;
    _clearError();
    notifyListeners();
    
    try {
      final position = await Geolocator.getCurrentPosition();
      
      final attendance = await _attendanceRepository.checkOut(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      
      _todayAttendance = attendance;
      
      // Update in list
      final index = _attendances.indexWhere((a) => a.id == attendance.id);
      if (index != -1) {
        _attendances[index] = attendance;
      }
      
      return true;
    } on Failure catch (f) {
      _errorMessage = f.message;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCheckingOut = false;
      notifyListeners();
    }
  }
  
  // Get attendances
  Future<void> getAttendances({
    int? userId,
    DateTime? date,
    int? month,
    int? year,
  }) async {
    // Jangan set loading di sini, biarkan loading dari state awal
    _clearError();
    
    try {
      final result = await _attendanceRepository.getAttendances(
        userId: userId,
        date: date,
        month: month,
        year: year,
      );
      
      // Hanya update data, jangan set loading
      _attendances = result;
      
      // Find today's attendance
      final today = DateTime.now();
      _todayAttendance = _attendances.firstWhere(
        (a) => a.date.year == today.year && 
              a.date.month == today.month && 
              a.date.day == today.day,
        orElse: () => null as Attendance,
      );
      
      // Notify listeners setelah data berubah
      notifyListeners();
    } on Failure catch (f) {
      _errorMessage = f.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  // Get summary
  Future<void> getSummary({
    required int userId,
    required int month,
    required int year,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      _summary = await _attendanceRepository.getSummary(
        userId: userId,
        month: month,
        year: year,
      );
    } on Failure catch (f) {
      _errorMessage = f.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // Clear
  void clear() {
    _attendances = [];
    _summary = null;
    _todayAttendance = null;
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
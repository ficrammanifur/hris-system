class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  // Untuk Android Emulator
  // static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Auth Endpoints
  static const String login = '/login';
  static const String logout = '/logout';
  static const String me = '/me';
  
  // Employee Endpoints
  static const String employees = '/employees';
  
  // Attendance Endpoints
  static const String checkIn = '/attendance/check-in';
  static const String checkOut = '/attendance/check-out';
  static const String attendance = '/attendance';
  static const String attendanceSummary = '/attendance/summary';
  
  // Leave Endpoints
  static const String leaves = '/leaves';
  static const String leaveApprove = '/approve';
  static const String leaveReject = '/reject';
  static const String leaveBalance = '/leaves/balance';
  
  // Department Endpoints
  static const String departments = '/departments';
}
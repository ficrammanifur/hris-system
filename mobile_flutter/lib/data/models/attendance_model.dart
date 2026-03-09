import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final int id;
  final int userId;
  final DateTime date;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final String status;
  final String? notes;
  final Duration? duration;
  final bool isLate;
  
  const Attendance({
    required this.id,
    required this.userId,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
    required this.status,
    this.notes,
    this.duration,
    this.isLate = false,
  });
  
  factory Attendance.fromJson(Map<String, dynamic> json) {
    final checkIn = DateTime.parse(json['check_in_time'] as String);
    final checkOut = json['check_out_time'] != null 
        ? DateTime.parse(json['check_out_time'] as String) 
        : null;
    
    Duration? duration;
    if (checkOut != null) {
      duration = checkOut.difference(checkIn);
    }
    
    return Attendance(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      date: DateTime.parse(json['date'] as String),
      checkInTime: checkIn,
      checkOutTime: checkOut,
      checkInLatitude: (json['check_in_latitude'] as num?)?.toDouble(),
      checkInLongitude: (json['check_in_longitude'] as num?)?.toDouble(),
      checkOutLatitude: (json['check_out_latitude'] as num?)?.toDouble(),
      checkOutLongitude: (json['check_out_longitude'] as num?)?.toDouble(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      duration: duration,
      isLate: json['is_late'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'check_in_time': checkInTime.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'check_in_latitude': checkInLatitude,
      'check_in_longitude': checkInLongitude,
      'check_out_latitude': checkOutLatitude,
      'check_out_longitude': checkOutLongitude,
      'status': status,
      'notes': notes,
    };
  }
  
  @override
  List<Object?> get props => [id, userId, date, status];
}

class AttendanceSummary extends Equatable {
  final int totalDays;
  final int lateDays;
  final double totalHours;
  final double averageHoursPerDay;
  final List<Attendance> attendances;
  
  const AttendanceSummary({
    required this.totalDays,
    required this.lateDays,
    required this.totalHours,
    required this.averageHoursPerDay,
    required this.attendances,
  });
  
  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      totalDays: json['total_days'] as int,
      lateDays: json['late_days'] as int,
      totalHours: (json['total_hours'] as num).toDouble(),
      averageHoursPerDay: (json['average_hours_per_day'] as num).toDouble(),
      attendances: (json['attendances'] as List)
          .map((a) => Attendance.fromJson(a))
          .toList(),
    );
  }
  
  @override
  List<Object?> get props => [totalDays, lateDays, totalHours];
}
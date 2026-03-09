import 'package:equatable/equatable.dart';

class Leave extends Equatable {
  final int id;
  final int userId;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String reason;
  final String status;
  final int? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final int days;
  
  const Leave({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.days,
  });
  
  factory Leave.fromJson(Map<String, dynamic> json) {
    final start = DateTime.parse(json['start_date'] as String);
    final end = DateTime.parse(json['end_date'] as String);
    final days = end.difference(start).inDays + 1;
    
    return Leave(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      startDate: start,
      endDate: end,
      type: json['type'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
      approvedBy: json['approved_by'] as int?,
      approvedAt: json['approved_at'] != null 
          ? DateTime.parse(json['approved_at'] as String) 
          : null,
      rejectionReason: json['rejection_reason'] as String?,
      days: days,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'type': type,
      'reason': reason,
    };
  }
  
  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }
  
  @override
  List<Object?> get props => [id, userId, startDate, endDate, status];
}

class LeaveBalance extends Equatable {
  final int total;
  final int taken;
  final int pending;
  final int remaining;
  
  const LeaveBalance({
    required this.total,
    required this.taken,
    required this.pending,
    required this.remaining,
  });
  
  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      total: json['total'] as int,
      taken: json['taken'] as int,
      pending: json['pending'] as int,
      remaining: json['remaining'] as int,
    );
  }
  
  @override
  List<Object?> get props => [total, taken, pending, remaining];
}
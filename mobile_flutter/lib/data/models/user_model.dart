import 'package:equatable/equatable.dart';

class Department extends Equatable {
  final int id;
  final String name;
  final String code;
  final String? description;
  
  const Department({
    required this.id,
    required this.name,
    required this.code,
    this.description,
  });
  
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
    };
  }
  
  @override
  List<Object?> get props => [id, name, code, description];
}

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String employeeId;
  final int? departmentId;
  final Department? department;
  final String position;
  final DateTime joinDate;
  final String? phone;
  final String? address;
  final String status;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeId,
    this.departmentId,
    this.department,
    required this.position,
    required this.joinDate,
    this.phone,
    this.address,
    required this.status,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      employeeId: json['employee_id'] as String,
      departmentId: json['department_id'] as int?,
      department: json['department'] != null 
          ? Department.fromJson(json['department']) 
          : null,
      position: json['position'] as String,
      joinDate: DateTime.parse(json['join_date'] as String),
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      status: json['status'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'employee_id': employeeId,
      'department_id': departmentId,
      'department': department?.toJson(),
      'position': position,
      'join_date': joinDate.toIso8601String(),
      'phone': phone,
      'address': address,
      'status': status,
    };
  }
  
  bool get isActive => status == 'active';
  
  @override
  List<Object?> get props => [id, name, email, employeeId];
}
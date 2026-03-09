import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final String status;
  final String? message;
  final T? data;
  final Map<String, dynamic>? meta;
  
  const ApiResponse({
    required this.status,
    this.message,
    this.data,
    this.meta,
  });
  
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      status: json['status'] as String,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
  
  bool get isSuccess => status == 'success';
  
  @override
  List<Object?> get props => [status, message, data, meta];
}

class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  
  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
  
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse(
      data: (json['data'] as List).map((e) => fromJsonT(e)).toList(),
      currentPage: json['meta']['current_page'] as int,
      lastPage: json['meta']['last_page'] as int,
      perPage: json['meta']['per_page'] as int,
      total: json['meta']['total'] as int,
    );
  }
  
  @override
  List<Object?> get props => [data, currentPage, lastPage, perPage, total];
}
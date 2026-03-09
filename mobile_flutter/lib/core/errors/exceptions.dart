class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  ServerException({required this.message, this.statusCode});
  
  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException([this.message = 'No internet connection']);
  
  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  
  CacheException([this.message = 'Cache error']);
  
  @override
  String toString() => 'CacheException: $message';
}

class UnauthorizedException implements Exception {
  final String message;
  
  UnauthorizedException([this.message = 'Unauthorized']);
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ValidationException implements Exception {
  final Map<String, dynamic> errors;
  
  ValidationException(this.errors);
  
  @override
  String toString() => 'ValidationException: $errors';
}
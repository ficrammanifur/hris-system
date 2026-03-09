abstract class Failure {
  final String message;
  
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({required String message, this.statusCode}) 
      : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic> errors;
  
  const ValidationFailure({required String message, required this.errors}) 
      : super(message: message);
}

class LocationFailure extends Failure {
  const LocationFailure({required String message}) : super(message: message);
}
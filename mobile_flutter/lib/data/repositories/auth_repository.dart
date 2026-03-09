import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/data/datasources/local/secure_storage.dart';
import 'package:mobile_flutter/data/datasources/remote/auth_remote.dart';
import 'package:mobile_flutter/data/models/user_model.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User> getProfile();
  Future<bool> isLoggedIn();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  AuthRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      
      if (response.isSuccess && response.data != null) {
        final user = User.fromJson(response.data!['user']);
        final token = response.data!['token'] as String;
        
        await SecureStorage.saveToken(token);
        await SecureStorage.saveUser(user);
        
        return user;
      } else {
        throw ServerFailure(message: response.message ?? 'Login failed');
      }
    } on UnauthorizedException {
      throw UnauthorizedFailure(message: 'Invalid email or password');
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
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
      await SecureStorage.clearAll();
    } on NetworkException {
      // Even if network fails, clear local storage
      await SecureStorage.clearAll();
      throw NetworkFailure(message: 'No internet connection');
    } catch (e) {
      // Still clear local storage
      await SecureStorage.clearAll();
      throw ServerFailure(message: e.toString());
    }
  }
  
  @override
  Future<User> getProfile() async {
    try {
      final response = await remoteDataSource.getProfile();
      
      if (response.isSuccess && response.data != null) {
        await SecureStorage.saveUser(response.data!);
        return response.data!;
      } else {
        throw ServerFailure(message: response.message ?? 'Failed to get profile');
      }
    } on UnauthorizedException {
      await SecureStorage.clearAll();
      throw UnauthorizedFailure(message: 'Session expired');
    } on NetworkException {
      // Try to get from local storage
      final localUser = await SecureStorage.getUser();
      if (localUser != null) {
        return localUser;
      }
      throw NetworkFailure(message: 'No internet connection');
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await SecureStorage.isLoggedIn();
  }
}
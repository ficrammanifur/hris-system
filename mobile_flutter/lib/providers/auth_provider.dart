import 'package:flutter/material.dart';
import 'package:mobile_flutter/data/repositories/auth_repository.dart';
import 'package:mobile_flutter/data/datasources/remote/auth_remote.dart';
import 'package:mobile_flutter/data/datasources/remote/dio_client.dart';
import 'package:mobile_flutter/data/models/user_model.dart';
import 'package:mobile_flutter/core/errors/failures.dart';

class AuthProvider extends ChangeNotifier {
  late final AuthRepository _authRepository;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  AuthProvider() {
    final dioClient = DioClient();
    final remoteDataSource = AuthRemoteDataSourceImpl(dioClient: dioClient);
    _authRepository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
    
    // Check if user is already logged in
    checkLoginStatus();
  }
  
  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  
  // Check login status
  Future<void> checkLoginStatus() async {
    _setLoading(true);
    _clearError();
    
    final isLoggedIn = await _authRepository.isLoggedIn();
    
    if (isLoggedIn) {
      try {
        _user = await _authRepository.getProfile();
      } catch (e) {
        _user = null;
      }
    }
    
    _setLoading(false);
  }
  
  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      _user = await _authRepository.login(email, password);
      _setLoading(false);
      return true;
    } on Failure catch (f) {
      _errorMessage = f.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }
  
  // Logout
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _authRepository.logout();
      _user = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // Refresh profile
  Future<void> refreshProfile() async {
    if (_user == null) return;
    
    try {
      _user = await _authRepository.getProfile();
    } catch (e) {
      _errorMessage = e.toString();
    }
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
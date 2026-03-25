import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    _token = await _storage.read(key: AppConstants.tokenKey);
    final userData = await _storage.read(key: AppConstants.userKey);
    if (userData != null) {
      _user = User.fromJson(jsonDecode(userData));
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authService.login(LoginRequest(
        identifier: identifier,
        password: password,
      ));

      if (response.result?.authenticated == true) {
        _token = response.result?.token;
        _user = response.result?.user;
        
        await _storage.write(key: AppConstants.tokenKey, value: _token);
        if (_user != null) {
          await _storage.write(key: AppConstants.userKey, value: jsonEncode(_user!.toJson()));
        }
        _setLoading(false);
        return true;
      } else {
        _setError(response.message ?? 'Authentication failed');
      }
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
    return false;
  }

  Future<bool> register(RegisterRequest request) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authService.register(request);
      _setLoading(false);
      return response.code == null; // Success if no error code or based on message
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
    return false;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authService.verifyRegister(
        VerifyOtpRequest(email: email, otpCode: otp),
      );

      if (response.result?.authenticated == true) {
        _token = response.result?.token;
        _user = response.result?.user;
        
        await _storage.write(key: AppConstants.tokenKey, value: _token);
        if (_user != null) {
          await _storage.write(key: AppConstants.userKey, value: jsonEncode(_user!.toJson()));
        }
        _setLoading(false);
        return true;
      } else {
        _setError(response.message ?? 'OTP verification failed');
      }
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
    return false;
  }

  Future<String?> forgotPasswordInit(String identifier) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authService.forgotPasswordInit(ForgotPasswordInitRequest(identifier: identifier));
      _setLoading(false);
      return response.result; // Returns masked email
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
    return null;
  }

  Future<String?> verifyForgotPasswordOtp(String identifier, String otp) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _authService.verifyForgotPasswordOtp(
        VerifyForgotPasswordOtpRequest(identifier: identifier, otpCode: otp),
      );
      _setLoading(false);
      return response.result?.resetToken;
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
    return null;
  }

  Future<bool> resetPassword(String identifier, String resetToken, String newPassword) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.resetPassword(ResetPasswordRequest(
        identifier: identifier,
        otpCode: resetToken,
        newPassword: newPassword,
      ));
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.deleteAll();
    notifyListeners();
  }
}

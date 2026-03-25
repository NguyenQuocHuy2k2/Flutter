import 'package:dio/dio.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../models/auth_models.dart';

class AuthService {
  final ApiService _apiService = apiService;

  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    final response = await _apiService.post(
      AppConstants.loginEndpoint,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => AuthResponse.fromJson(json),
    );
  }

  Future<ApiResponse<void>> register(RegisterRequest request) async {
    final response = await _apiService.post(
      AppConstants.registerEndpoint,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(response.data, (json) => null);
  }

  Future<ApiResponse<AuthResponse>> verifyRegister(VerifyOtpRequest request) async {
    final response = await _apiService.post(
      AppConstants.verifyRegisterEndpoint,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => AuthResponse.fromJson(json),
    );
  }

  Future<ApiResponse<String>> forgotPasswordInit(ForgotPasswordInitRequest request) async {
    final response = await _apiService.post(
      AppConstants.forgotPassInitEndpoint,
      data: request.toJson(),
    );
    // Based on backend, it returns String maskedEmail
    return ApiResponse.fromJson(
      response.data,
      (json) => json as String,
    );
  }

  Future<ApiResponse<ResetTokenResponse>> verifyForgotPasswordOtp(VerifyForgotPasswordOtpRequest request) async {
    final response = await _apiService.post(
      AppConstants.forgotPassVerifyEndpoint,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => ResetTokenResponse.fromJson(json),
    );
  }

  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    final response = await _apiService.post(
      AppConstants.forgotPassResetEndpoint,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(response.data, (json) => null);
  }
}

final authService = AuthService();

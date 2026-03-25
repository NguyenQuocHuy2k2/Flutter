import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Zola Auth';
  
  // API Base URL - Update this based on your testing environment
  // Use 10.0.2.2 for Android Emulator
  // Use localhost for iOS Simulator / Web
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String verifyRegisterEndpoint = '/auth/register/verify';
  static const String forgotPassInitEndpoint = '/auth/forgot-password/init';
  static const String forgotPassVerifyEndpoint = '/auth/forgot-password/verify';
  static const String forgotPassResetEndpoint = '/auth/forgot-password/reset';
  
  // Storage keys
  static const String tokenKey = 'jwt_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Design tokens
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFFF50057);
  static const Color backgroundColor = Color(0xFFF8F9FE);
  static const Color textColor = Color(0xFF2D3436);
  static const Color glassColor = Colors.white70;
}

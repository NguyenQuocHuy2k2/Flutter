import 'dart:convert';

class ApiResponse<T> {
  final int? code;
  final String? message;
  final T? result;

  ApiResponse({this.code, this.message, this.result});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      code: json['code'],
      message: json['message'],
      result: json['result'] != null ? fromJsonT(json['result']) : null,
    );
  }
}

class AuthResponse {
  final String? token;
  final bool? authenticated;
  final User? user;

  AuthResponse({this.token, this.authenticated, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      authenticated: json['authenticated'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  final String? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;

  User({this.id, this.username, this.email, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

class LoginRequest {
  final String? identifier;
  final String? password;

  LoginRequest({this.identifier, this.password});

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'password': password,
  };
}

class RegisterRequest {
  final String? username;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? phone;

  RegisterRequest({
    this.username,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
  };
}

class VerifyOtpRequest {
  final String? email;
  final String? otpCode;

  VerifyOtpRequest({this.email, this.otpCode});

  Map<String, dynamic> toJson() => {
    'email': email,
    'otpCode': otpCode,
  };
}

class ForgotPasswordInitRequest {
  final String? identifier;

  ForgotPasswordInitRequest({this.identifier});

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
  };
}

class VerifyForgotPasswordOtpRequest {
  final String? identifier;
  final String? otpCode;

  VerifyForgotPasswordOtpRequest({this.identifier, this.otpCode});

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'otpCode': otpCode,
  };
}

class ResetPasswordRequest {
  final String? identifier;
  final String? otpCode; // Reset token from verify endpoint
  final String? newPassword;

  ResetPasswordRequest({this.identifier, this.otpCode, this.newPassword});

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'otpCode': otpCode,
    'newPassword': newPassword,
  };
}

class ResetTokenResponse {
  final String? resetToken;

  ResetTokenResponse({this.resetToken});

  factory ResetTokenResponse.fromJson(Map<String, dynamic> json) {
    return ResetTokenResponse(resetToken: json['resetToken']);
  }
}

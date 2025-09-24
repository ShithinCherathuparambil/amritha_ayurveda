import 'user_details_model.dart';

/// Model for login API response
class LoginResponseModel {
  const LoginResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.isSuperuser,
    required this.userDetails,
  });

  final bool status;
  final String message;
  final String token;
  final bool isSuperuser;
  final UserDetailsModel userDetails;

  /// Create LoginResponseModel from JSON
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      isSuperuser: json['is_superuser'] ?? false,
      userDetails: UserDetailsModel.fromJson(json['user_details'] ?? {}),
    );
  }

  /// Convert LoginResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'is_superuser': isSuperuser,
      'user_details': userDetails.toJson(),
    };
  }

  /// Create a copy with updated fields
  LoginResponseModel copyWith({
    bool? status,
    String? message,
    String? token,
    bool? isSuperuser,
    UserDetailsModel? userDetails,
  }) {
    return LoginResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      token: token ?? this.token,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      userDetails: userDetails ?? this.userDetails,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginResponseModel &&
        other.status == status &&
        other.message == message &&
        other.token == token &&
        other.isSuperuser == isSuperuser &&
        other.userDetails == userDetails;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      message,
      token,
      isSuperuser,
      userDetails,
    );
  }

  @override
  String toString() {
    return 'LoginResponseModel(status: $status, message: $message, token: $token, isSuperuser: $isSuperuser, userDetails: $userDetails)';
  }
}

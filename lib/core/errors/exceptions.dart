import 'package:flutter/foundation.dart';

/// Base class for all exceptions
@immutable
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
  });

  final String message;
  final String? code;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppException &&
        other.message == message &&
        other.code == code;
  }

  @override
  int get hashCode => Object.hash(message, code);

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'AuthException(message: $message, code: $code)';
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'NetworkException(message: $message, code: $code)';
}

/// Server related exceptions
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'ServerException(message: $message, code: $code)';
}

/// Cache related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'CacheException(message: $message, code: $code)';
}

/// Validation related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'ValidationException(message: $message, code: $code)';
}

/// Permission related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'PermissionException(message: $message, code: $code)';
}

import 'package:flutter/foundation.dart';

/// Base class for all failures
@immutable
abstract class Failure {
  const Failure({
    required this.message,
    this.code,
  });

  final String message;
  final String? code;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.message == message &&
        other.code == code;
  }

  @override
  int get hashCode => Object.hash(message, code);

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'AuthFailure(message: $message, code: $code)';
}

/// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'NetworkFailure(message: $message, code: $code)';
}

/// Server related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'ServerFailure(message: $message, code: $code)';
}

/// Cache related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'CacheFailure(message: $message, code: $code)';
}

/// Validation related failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'ValidationFailure(message: $message, code: $code)';
}

/// Permission related failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'PermissionFailure(message: $message, code: $code)';
}

/// Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'UnknownFailure(message: $message, code: $code)';
}

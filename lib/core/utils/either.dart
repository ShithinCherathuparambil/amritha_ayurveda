/// A type that represents either a success value of type [R] or a failure value of type [L]
abstract class Either<L, R> {
  const Either();

  /// Returns true if this is a [Left] instance
  bool get isLeft => this is Left<L, R>;

  /// Returns true if this is a [Right] instance
  bool get isRight => this is Right<L, R>;

  /// Transforms the right value using the provided function
  Either<L, T> map<T>(T Function(R) f) {
    if (isRight) {
      return Right(f((this as Right<L, R>).value));
    }
    return Left((this as Left<L, R>).value);
  }

  /// Transforms the left value using the provided function
  Either<T, R> mapLeft<T>(T Function(L) f) {
    if (isLeft) {
      return Left(f((this as Left<L, R>).value));
    }
    return Right((this as Right<L, R>).value);
  }

  /// Applies a function that returns an Either to the right value
  Either<L, T> flatMap<T>(Either<L, T> Function(R) f) {
    if (isRight) {
      return f((this as Right<L, R>).value);
    }
    return Left((this as Left<L, R>).value);
  }

  /// Executes one of the provided functions based on the Either type
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (isLeft) {
      return onLeft((this as Left<L, R>).value);
    }
    return onRight((this as Right<L, R>).value);
  }

  /// Gets the right value or throws an exception if this is a Left
  R get rightValue {
    if (isRight) {
      return (this as Right<L, R>).value;
    }
    throw Exception('Called rightValue on a Left instance');
  }

  /// Gets the left value or throws an exception if this is a Right
  L get leftValue {
    if (isLeft) {
      return (this as Left<L, R>).value;
    }
    throw Exception('Called leftValue on a Right instance');
  }

  /// Gets the right value or returns the provided default value
  R getOrElse(R defaultValue) {
    if (isRight) {
      return (this as Right<L, R>).value;
    }
    return defaultValue;
  }
}

/// Represents a failure value
class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Left<L, R> && other.value == value);
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

/// Represents a success value
class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Right<L, R> && other.value == value);
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}

/// Helper functions for creating Either instances
extension EitherExtensions<T> on T {
  /// Wraps this value in a Right
  Right<L, T> right<L>() => Right<L, T>(this);

  /// Wraps this value in a Left
  Left<T, R> left<R>() => Left<T, R>(this);
}

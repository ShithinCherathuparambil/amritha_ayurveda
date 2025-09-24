import '../entities/user.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });

  /// Sign out the current user
  Future<Either<Failure, void>> signOut();

  /// Get the current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  /// Verify email with token
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  });

  /// Resend email verification
  Future<Either<Failure, void>> resendEmailVerification();

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? profileImageUrl,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount({
    required String password,
  });

  /// Refresh authentication token
  Future<Either<Failure, void>> refreshToken();

  /// Get current authentication token
  Future<String?> getAuthToken();

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
}

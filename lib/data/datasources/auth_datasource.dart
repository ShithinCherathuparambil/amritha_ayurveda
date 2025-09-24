import '../models/user_model.dart';

/// Abstract interface for authentication data sources
abstract class AuthDataSource {
  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Get the current authenticated user
  Future<UserModel?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email});

  /// Verify email with token
  Future<void> verifyEmail({required String token});

  /// Resend email verification
  Future<void> resendEmailVerification();

  /// Update user profile
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? profileImageUrl,
  });

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete user account
  Future<void> deleteAccount({required String password});

  /// Get current authentication token
  Future<String?> getAuthToken();

  /// Stream of authentication state changes
  Stream<UserModel?> get authStateChanges;

  /// Dispose resources
  void dispose();
}

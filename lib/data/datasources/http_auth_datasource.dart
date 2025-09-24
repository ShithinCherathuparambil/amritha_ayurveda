import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../models/login_response_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';
import 'auth_datasource.dart';

/// HTTP authentication data source implementation
class HttpAuthDataSource implements AuthDataSource {
  static final HttpAuthDataSource _instance = HttpAuthDataSource._internal();
  factory HttpAuthDataSource() => _instance;
  HttpAuthDataSource._internal() {
    _initialize();
  }

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _loginResponseKey = 'login_response';

  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final StreamController<UserModel?> _authStateController =
      StreamController<UserModel?>.broadcast();

  UserModel? _currentUser;
  String? _currentToken;

  /// Initialize the datasource
  void _initialize() {
    // Initialize Dio with default configuration
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting login with URL: ${AppConstants.baseUrl}/Login');
      print('Login data: username=$email');

      final response = await _dio.post(
        '${AppConstants.baseUrl}/Login',
        data: {'username': email, 'password': password},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'Accept': 'application/json'},
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(response.data);

        if (!loginResponse.status) {
          throw AuthException(
            message: loginResponse.message,
            code: 'login-failed',
          );
        }

        // Store token securely
        print('🔑 ACCESS TOKEN: ${loginResponse.token}');
        await _secureStorage.write(key: _tokenKey, value: loginResponse.token);
        _currentToken = loginResponse.token;

        // Store complete login response
        await _secureStorage.write(
          key: _loginResponseKey,
          value: jsonEncode(loginResponse.toJson()),
        );

        // Create user model from response
        final userModel = UserModel.fromEntity(
          loginResponse.userDetails.toEntity(),
        );

        // Store user data
        await _secureStorage.write(
          key: _userKey,
          value: jsonEncode(userModel.toJson()),
        );
        _currentUser = userModel;
        _authStateController.add(_currentUser);

        return userModel;
      } else {
        throw AuthException(
          message: 'Login failed with status: ${response.statusCode}',
          code: 'login-failed',
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.type}, ${e.message}');
      print('Response: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw const AuthException(
          message: 'Invalid credentials',
          code: 'invalid-credentials',
        );
      } else {
        throw AuthException(
          message: 'Network error: ${e.message ?? 'Unknown network error'}',
          code: 'network-error',
        );
      }
    } catch (e, stackTrace) {
      print('Unexpected error: $e');
      print('Stack trace: $stackTrace');

      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Unexpected error: ${e.toString()}',
        code: 'unexpected-error',
      );
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      // For now, throw not implemented since we only have login endpoint
      throw const AuthException(
        message: 'Sign up not implemented yet',
        code: 'not-implemented',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Sign up failed: $e',
        code: 'sign-up-failed',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Clear stored data
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _userKey);

      _currentUser = null;
      _currentToken = null;
      _authStateController.add(null);
    } catch (e) {
      throw AuthException(
        message: 'Sign out failed: $e',
        code: 'sign-out-failed',
      );
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (_currentUser != null) {
        return _currentUser;
      }

      // Try to load user from secure storage
      final userData = await _secureStorage.read(key: _userKey);
      if (userData != null) {
        final userJson = jsonDecode(userData);
        _currentUser = UserModel.fromJson(userJson);
        return _currentUser;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      throw const AuthException(
        message: 'Password reset not implemented yet',
        code: 'not-implemented',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Password reset failed: $e',
        code: 'password-reset-failed',
      );
    }
  }

  @override
  Future<void> verifyEmail({required String token}) async {
    try {
      throw const AuthException(
        message: 'Email verification not implemented yet',
        code: 'not-implemented',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Email verification failed: $e',
        code: 'verification-failed',
      );
    }
  }

  @override
  Future<void> resendEmailVerification() async {
    try {
      throw const AuthException(
        message: 'Resend verification not implemented yet',
        code: 'not-implemented',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Resend verification failed: $e',
        code: 'resend-verification-failed',
      );
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? profileImageUrl,
  }) async {
    try {
      throw const AuthException(
        message: 'Profile update not implemented yet',
        code: 'not-implemented',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Update profile failed: $e',
        code: 'update-profile-failed',
      );
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      throw const AuthException(
        message: 'Change password not implemented yet',
        code: 'not-implemented',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Change password failed: $e',
        code: 'change-password-failed',
      );
    }
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    try {
      throw const AuthException(
        message: 'Delete account not implemented yet',
        code: 'not-implemented',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Delete account failed: $e',
        code: 'delete-account-failed',
      );
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      if (_currentToken != null) {
        print('🔑 CURRENT TOKEN (from memory): $_currentToken');
        return _currentToken;
      }

      // Try to load token from secure storage
      _currentToken = await _secureStorage.read(key: _tokenKey);
      if (_currentToken != null) {
        print('🔑 RETRIEVED TOKEN (from storage): $_currentToken');
      } else {
        print('🔑 NO TOKEN FOUND');
      }
      return _currentToken;
    } catch (e) {
      print('🔑 ERROR RETRIEVING TOKEN: $e');
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  void dispose() {
    _authStateController.close();
    _dio.close();
  }

  /// Initialize the datasource by loading stored data
  Future<void> initialize() async {
    try {
      await getCurrentUser();
      final token = await getAuthToken();
      if (token != null && _currentUser != null) {
        _authStateController.add(_currentUser);
      }
    } catch (e) {
      // Ignore initialization errors
    }
  }
}

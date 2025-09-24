import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication state enumeration
enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository {
    _init();
  }

  final AuthRepository _authRepository;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated =>
      _state == AuthState.authenticated && _user != null;

  /// Initialize the provider
  Future<void> _init() async {
    _setLoading(true);
    try {
      final isAuth = await _authRepository.isAuthenticated();
      if (isAuth) {
        final result = await _authRepository.getCurrentUser();
        result.fold((failure) => _setError(failure.message), (user) {
          if (user != null) {
            _setAuthenticated(user);
          } else {
            _setUnauthenticated();
          }
        });
      } else {
        _setUnauthenticated();
      }
    } catch (e) {
      _setError('Failed to initialize authentication: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => _setError(failure.message),
      (user) => _setAuthenticated(user),
    );

    _setLoading(false);
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );

    result.fold(
      (failure) => _setError(failure.message),
      (user) => _setAuthenticated(user),
    );

    _setLoading(false);
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.signOut();

    result.fold(
      (failure) => _setError(failure.message),
      (_) => _setUnauthenticated(),
    );

    _setLoading(false);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setAuthenticated(User user) {
    _state = AuthState.authenticated;
    _user = user;
    _errorMessage = null;
    notifyListeners();
  }

  void _setUnauthenticated() {
    _state = AuthState.unauthenticated;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _state = AuthState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }
}

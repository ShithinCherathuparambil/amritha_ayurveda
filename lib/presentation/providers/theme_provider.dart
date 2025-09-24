import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/theme/app_theme.dart';

/// Provider for managing theme state
class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Get the current theme data based on theme mode and system brightness
  ThemeData getThemeData(Brightness systemBrightness) {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        return systemBrightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();
    await _saveThemeMode();
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, you would load this from SharedPreferences or similar
      // For now, we'll use system theme as default
      _themeMode = ThemeMode.system;
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
      _themeMode = ThemeMode.system;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save theme mode to storage
  Future<void> _saveThemeMode() async {
    try {
      // In a real app, you would save this to SharedPreferences or similar
      // For now, we'll just print the theme mode
      debugPrint('Theme mode saved: $_themeMode');
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Get theme mode display name
  String get themeModeDisplayName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get theme mode icon
  IconData get themeModeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}

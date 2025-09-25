import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'Amritha Ayurveda';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  // Screen Size
  static const double designWidth = 390;
  static const double designHeight = 844;
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 100;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // API Configuration
  static Future<Map<String, String>> getAuthorizationHeader() async {
    return {
      // 'Authorization': 'Bearer ${Token.accessToken}',
      'Timezone': await getTimezone(),
    };
  }

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static   String baseUrl = dotenv.env['BASE_URL'] ??'';
  static   String loginURL = '$baseUrl${dotenv.env['LOGIN_ENDPOINT'] ??''}';
  static   String patientListURL = '$baseUrl${dotenv.env['PATIENT_LIST_ENDPOINT'] ??''}';
  static   String patientUpdateURL = '$baseUrl${dotenv.env['PATIENT_UPDATE_ENDPOINT'] ??''}';
  static   String treatmentListURL = '$baseUrl${dotenv.env['TREATMENT_LIST_ENDPOINT'] ??''}';
  static   String branchListURL = '$baseUrl${dotenv.env['BRANCH_LIST_ENDPOINT'] ??''}';
 }

Future<String> getTimezone() async {
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  return currentTimeZone;
}

// import 'package:flutter_dotenv/flutter_dotenv.dart';

// /// URL configuration class that manages all API endpoints
// /// Uses environment variables from .env file for configuration
// class ApiUrls {
//   // Private constructor to prevent instantiation
//   ApiUrls._();

//   /// Base URL for all API calls
//   static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://flutter-amr.noviindus.in';

//   /// Authentication endpoints
//   static String get login => '$baseUrl${dotenv.env['LOGIN_ENDPOINT'] ?? '/api/Login'}';

//   /// Patient management endpoints
//   static String get patientList => '$baseUrl${dotenv.env['PATIENT_LIST_ENDPOINT'] ?? '/api/PatientList'}';
//   static String get patientUpdate => '$baseUrl${dotenv.env['PATIENT_UPDATE_ENDPOINT'] ?? '/api/PatientUpdate'}';

//   /// Treatment management endpoints
//   static String get treatmentList => '$baseUrl${dotenv.env['TREATMENT_LIST_ENDPOINT'] ?? '/api/TreatmentList'}';

//   /// Branch management endpoints
//   static String get branchList => '$baseUrl${dotenv.env['BRANCH_LIST_ENDPOINT'] ?? '/api/BranchList'}';

//   /// App configuration
//   static String get appName => dotenv.env['APP_NAME'] ?? 'Amritha Ayurveda';
//   static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';

//   /// Debug configuration
//   static bool get debugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
//   static bool get enableLogging => dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

//   /// Timeout configuration (in seconds)
//   static int get connectionTimeout => int.tryParse(dotenv.env['CONNECTION_TIMEOUT'] ?? '30') ?? 30;
//   static int get receiveTimeout => int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30') ?? 30;
//   static int get sendTimeout => int.tryParse(dotenv.env['SEND_TIMEOUT'] ?? '30') ?? 30;

//   /// Security configuration
//   static String get jwtSecretKey => dotenv.env['JWT_SECRET_KEY'] ?? '';
//   static String get encryptionKey => dotenv.env['ENCRYPTION_KEY'] ?? '';

//   /// Utility method to get timeout durations
//   static Duration get connectionTimeoutDuration => Duration(seconds: connectionTimeout);
//   static Duration get receiveTimeoutDuration => Duration(seconds: receiveTimeout);
//   static Duration get sendTimeoutDuration => Duration(seconds: sendTimeout);

//   /// Method to validate if all required environment variables are loaded
//   static bool validateEnvironment() {
//     final requiredVars = [
//       'BASE_URL',
//       'LOGIN_ENDPOINT',
//       'PATIENT_LIST_ENDPOINT',
//       'PATIENT_UPDATE_ENDPOINT',
//       'TREATMENT_LIST_ENDPOINT',
//       'BRANCH_LIST_ENDPOINT',
//     ];

//     for (final varName in requiredVars) {
//       if (dotenv.env[varName] == null || dotenv.env[varName]!.isEmpty) {
//         print('Warning: Environment variable $varName is not set or empty');
//         return false;
//       }
//     }
//     return true;
//   }

//   /// Method to print all loaded URLs (for debugging)
//   static void printUrls() {
//     if (debugMode) {
//       print('=== API URLs Configuration ===');
//       print('Base URL: $baseUrl');
//       print('Login: $login');
//       print('Patient List: $patientList');
//       print('Patient Update: $patientUpdate');
//       print('Treatment List: $treatmentList');
//       print('Branch List: $branchList');
//       print('==============================');
//     }
//   }
// }

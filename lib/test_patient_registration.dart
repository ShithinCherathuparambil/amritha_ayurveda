import 'package:dio/dio.dart';
import 'data/datasources/patient_datasource.dart';
import 'data/datasources/http_patient_datasource.dart';
import 'data/datasources/http_auth_datasource.dart';
import 'core/constants/app_constants.dart';

/// Test function to verify PatientUpdate API is working
Future<void> testPatientRegistrationAPI() async {
  print('🧪 Testing PatientUpdate API...');

  try {
    // Create datasources
    final authDataSource = HttpAuthDataSource();
    final patientDataSource = HttpPatientDataSource(
      dio: Dio(),
      authDataSource: authDataSource,
    );

    // Create test registration request
    final testRequest = PatientRegistrationRequest(
      name: 'Test Patient',
      executive: 'Test Executive',
      payment: 'Cash',
      phone: '9876543210',
      address: 'Test Address, Test City',
      totalAmount: 1000.0,
      discountAmount: 100.0,
      advanceAmount: 500.0,
      balanceAmount: 400.0,
      dateNdTime: '25/09/2024-10:30 AM',
      id: '', // Empty for new patient
      male: '79', // Test treatment ID
      female: '90', // Test treatment ID
      branch: 162, // Test branch ID (Nadakkavu)
      treatments: '79,90', // Test treatment IDs
    );

    print('🧪 Test request data:');
    print('   Name: ${testRequest.name}');
    print('   Phone: ${testRequest.phone}');
    print('   Branch: ${testRequest.branch}');
    print('   Treatments: ${testRequest.treatments}');
    print('   Total Amount: ${testRequest.totalAmount}');

    // Call the API
    final result = await patientDataSource.registerPatient(testRequest);

    print('✅ PatientUpdate API test successful!');
    if (result != null) {
      print('   Registered patient ID: ${result.id}');
      print('   Patient name: ${result.name}');
    } else {
      print('   Registration successful (no patient data returned)');
    }
  } catch (e) {
    print('❌ PatientUpdate API test failed: $e');

    // Check if it's a specific API error
    if (e is DioException) {
      print('   Status code: ${e.response?.statusCode}');
      print('   Response data: ${e.response?.data}');
    }
  }
}

/// Test function to verify API endpoints are accessible
Future<void> testAPIEndpoints() async {
  print('🧪 Testing API endpoints accessibility...');

  try {
    final dio = Dio();

    // Test base URL connectivity
    print('🧪 Testing base URL: ${AppConstants.baseUrl}');

    // Test login endpoint (should return 401 without credentials)
    try {
      final loginResponse = await dio.post('${AppConstants.baseUrl}/Login');
      print('✅ Login endpoint accessible');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        print('✅ Login endpoint accessible (401 expected without credentials)');
      } else {
        print('❌ Login endpoint error: $e');
      }
    }

    // Test patient list endpoint (should return 401 without token)
    try {
      final patientResponse = await dio.get(
        '${AppConstants.baseUrl}/PatientList',
      );
      print('✅ PatientList endpoint accessible');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        print('✅ PatientList endpoint accessible (401 expected without token)');
      } else {
        print('❌ PatientList endpoint error: $e');
      }
    }

    // Test treatment list endpoint (should return 401 without token)
    try {
      final treatmentResponse = await dio.get(
        '${AppConstants.baseUrl}/TreatmentList',
      );
      print('✅ TreatmentList endpoint accessible');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        print(
          '✅ TreatmentList endpoint accessible (401 expected without token)',
        );
      } else {
        print('❌ TreatmentList endpoint error: $e');
      }
    }

    // Test branch list endpoint (should return 401 without token)
    try {
      final branchResponse = await dio.get(
        '${AppConstants.baseUrl}/BranchList',
      );
      print('✅ BranchList endpoint accessible');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        print('✅ BranchList endpoint accessible (401 expected without token)');
      } else {
        print('❌ BranchList endpoint error: $e');
      }
    }

    // Test patient update endpoint (should return 401 without token)
    try {
      final updateResponse = await dio.post(
        '${AppConstants.baseUrl}/PatientUpdate',
      );
      print('✅ PatientUpdate endpoint accessible');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        print(
          '✅ PatientUpdate endpoint accessible (401 expected without token)',
        );
      } else {
        print('❌ PatientUpdate endpoint error: $e');
      }
    }
  } catch (e) {
    print('❌ API endpoints test failed: $e');
  }
}

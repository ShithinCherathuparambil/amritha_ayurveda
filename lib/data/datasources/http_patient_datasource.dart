import 'dart:developer';

import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/patient_model.dart';
import 'patient_datasource.dart';
import 'auth_datasource.dart';

class HttpPatientDataSource implements PatientDataSource {
  final Dio _dio;
  final AuthDataSource _authDataSource;

  HttpPatientDataSource({
    required Dio dio,
    required AuthDataSource authDataSource,
  }) : _dio = dio,
       _authDataSource = authDataSource {
    _initialize();
  }

  void _initialize() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  @override
  Future<List<PatientModel>> getPatients() async {
    try {
      print('📋 Fetching patients from API...');

      // Get auth token
      final token = await _authDataSource.getAuthToken();
      if (token == null) {
        throw const ServerException(message: 'No authentication token found');
      }

      print('📋 Using token: $token');

      final response = await _dio.get(
        '${AppConstants.baseUrl}/PatientList',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print('📋 API Response Status: ${response.statusCode}');
      log('📋 API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final patientListResponse = PatientListResponseModel.fromJson(
          response.data,
        );

        if (patientListResponse.status == true) {
          print(
            '📋 Successfully fetched ${patientListResponse.patients?.length ?? 0} patients',
          );
          return patientListResponse.patients ?? [];
        } else {
          throw ServerException(
            message: patientListResponse.message ?? 'Unknown error',
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to fetch patients: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('📋 DioException: ${e.message}');
      print('📋 DioException Response: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw const ServerException(message: 'Authentication failed');
      } else if (e.response?.statusCode == 403) {
        throw const ServerException(message: 'Access forbidden');
      } else if (e.response?.statusCode == 404) {
        throw const ServerException(message: 'Patients endpoint not found');
      } else if (e.response?.statusCode == 500) {
        throw const ServerException(message: 'Server error occurred');
      } else {
        throw ServerException(message: 'Network error: ${e.message}');
      }
    } catch (e) {
      log('📋 Unexpected error: $e');
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<PatientModel?> registerPatient(
    PatientRegistrationRequest request,
  ) async {
    try {
      print('👤 Registering patient...');

      // Get auth token
      final token = await _authDataSource.getAuthToken();
      if (token == null) {
        throw const ServerException(message: 'No authentication token found');
      }

      print('👤 Using token for registration: $token');
      final Map<String, dynamic> data = request.toJson();
      print('📤 Request data: $data');
      print('🔗 API URL: ${AppConstants.baseUrl}/PatientUpdate');
      print('🔑 Token: $token');

      // Convert data to FormData but keep numeric values as numbers
      final formData = FormData();
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      print(
        '📋 FormData fields: ${formData.fields.map((e) => '${e.key}: ${e.value}').join(', ')}',
      );

      final response = await _dio.post(
        '${AppConstants.baseUrl}/PatientUpdate',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type - let Dio handle it for FormData
          },
        ),
      );

      print('👤 Registration API Response Status: ${response.statusCode}');
      print('👤 Registration API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        // Assuming the API returns the created patient data
        // You may need to adjust this based on the actual API response structure
        if (response.data['status'] == true) {
          print('👤 Patient registered successfully');
          // Since the API only returns success status without patient data,
          // we return null and let the refresh handle getting updated data
          return null;
        } else {
          throw ServerException(
            message: response.data['message'] ?? 'Registration failed',
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to register patient: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Registration error: $e');
      if (e is DioException) {
        print('❌ DioException details:');
        print('   Status code: ${e.response?.statusCode}');
        print('   Response data: ${e.response?.data}');
        print('   Request data: ${e.requestOptions.data}');
        print('   Headers: ${e.requestOptions.headers}');

        // Try to extract more meaningful error message from response
        String errorMessage = 'Registration failed';
        if (e.response?.data != null) {
          try {
            final responseData = e.response!.data;
            if (responseData is Map && responseData.containsKey('message')) {
              errorMessage = responseData['message'].toString();
            } else if (responseData is String) {
              errorMessage = responseData;
            }
          } catch (_) {
            // If parsing fails, use default message
          }
        }

        throw ServerException(message: errorMessage);
      }
      throw ServerException(message: 'Registration error: $e');
    }
  }

  void dispose() {
    _dio.close();
  }
}

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
      // } on DioException catch (e) {
      //   print('📋 DioException: ${e.message}');
      //   print('📋 DioException Response: ${e.response?.data}');

      //   if (e.response?.statusCode == 401) {
      //     throw const ServerException(message: 'Authentication failed');
      //   } else if (e.response?.statusCode == 403) {
      //     throw const ServerException(message: 'Access forbidden');
      //   } else if (e.response?.statusCode == 404) {
      //     throw const ServerException(message: 'Patients endpoint not found');
      //   } else if (e.response?.statusCode == 500) {
      //     throw const ServerException(message: 'Server error occurred');
      //   } else {
      //     throw ServerException(message: 'Network error: ${e.message}');
      //   }
    } catch (e) {
      log('📋 Unexpected error: $e');
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  void dispose() {
    _dio.close();
  }
}

import 'dart:developer';
import 'package:dio/dio.dart';
import '../../config/url.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/treatment_model.dart';
import '../models/patient_model.dart';
import 'treatment_datasource.dart';
import 'auth_datasource.dart';

class HttpTreatmentDataSource implements TreatmentDataSource {
  final Dio _dio;
  final AuthDataSource _authDataSource;

  HttpTreatmentDataSource({
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
  Future<List<TreatmentModel>> getTreatments() async {
    try {
      print('🏥 Fetching treatments from API...');

      // Get auth token
      final token = await _authDataSource.getAuthToken();
      if (token == null) {
        throw const ServerException(message: 'No authentication token found');
      }

      print('🏥 Using token for treatments: $token');

      final response = await _dio.get(
        AppConstants.treatmentListURL,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print('🏥 Treatments API Response Status: ${response.statusCode}');
      log('🏥 Treatments API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final treatmentListResponse = TreatmentListResponseModel.fromJson(
          response.data,
        );

        if (treatmentListResponse.status == true) {
          print(
            '🏥 Successfully fetched ${treatmentListResponse.treatments?.length ?? 0} treatments',
          );
          return treatmentListResponse.treatments ?? [];
        } else {
          throw ServerException(
            message: treatmentListResponse.message ?? 'Unknown error',
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to fetch treatments: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('🏥 Unexpected error: $e');
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<BranchModel>> getBranches() async {
    try {
      print('🏢 Fetching branches from API...');

      // Get auth token
      final token = await _authDataSource.getAuthToken();
      if (token == null) {
        throw const ServerException(message: 'No authentication token found');
      }

      print('🏢 Using token for branches: $token');

      final response = await _dio.get(
        AppConstants.branchListURL,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print('🏢 Branches API Response Status: ${response.statusCode}');
      log('🏢 Branches API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final branchListResponse = BranchListResponseModel.fromJson(
          response.data,
        );

        if (branchListResponse.status == true) {
          print(
            '🏢 Successfully fetched ${branchListResponse.branches?.length ?? 0} branches',
          );
          return branchListResponse.branches ?? [];
        } else {
          throw ServerException(
            message: branchListResponse.message ?? 'Unknown error',
          );
        }
      } else {
        throw ServerException(
          message: 'Failed to fetch branches: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('🏢 Unexpected error: $e');
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  void dispose() {
    _dio.close();
  }
}

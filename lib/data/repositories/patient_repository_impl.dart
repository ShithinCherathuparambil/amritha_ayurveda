import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_datasource.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientDataSource _patientDataSource;

  const PatientRepositoryImpl({required PatientDataSource patientDataSource})
    : _patientDataSource = patientDataSource;

  @override
  Future<Either<Failure, List<Patient>>> getPatients() async {
    try {
      final patients = await _patientDataSource.getPatients();
      return Right(patients.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Patient>> registerPatient(
    PatientRegistrationRequest request,
  ) async {
    try {
      final patient = await _patientDataSource.registerPatient(request);
      return Right(patient.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}

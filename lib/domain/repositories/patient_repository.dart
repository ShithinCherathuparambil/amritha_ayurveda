import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/patient.dart';
import '../../data/datasources/patient_datasource.dart';

abstract class PatientRepository {
  Future<Either<Failure, List<Patient>>> getPatients();
  Future<Either<Failure, Patient?>> registerPatient(
    PatientRegistrationRequest request,
  );
}

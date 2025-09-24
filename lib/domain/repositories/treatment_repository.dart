import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/treatment.dart';
import '../entities/patient.dart'; // For Branch entity

abstract class TreatmentRepository {
  Future<Either<Failure, List<Treatment>>> getTreatments();
  Future<Either<Failure, List<Branch>>> getBranches();
}

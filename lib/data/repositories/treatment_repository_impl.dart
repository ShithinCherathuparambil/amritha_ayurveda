import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/treatment.dart';
import '../../domain/entities/patient.dart'; // For Branch entity
import '../../domain/repositories/treatment_repository.dart';
import '../datasources/treatment_datasource.dart';

class TreatmentRepositoryImpl implements TreatmentRepository {
  final TreatmentDataSource _treatmentDataSource;

  const TreatmentRepositoryImpl({required TreatmentDataSource treatmentDataSource})
    : _treatmentDataSource = treatmentDataSource;

  @override
  Future<Either<Failure, List<Treatment>>> getTreatments() async {
    try {
      final treatments = await _treatmentDataSource.getTreatments();
      return Right(treatments.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Branch>>> getBranches() async {
    try {
      final branches = await _treatmentDataSource.getBranches();
      return Right(branches.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}

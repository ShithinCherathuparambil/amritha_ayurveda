import '../models/treatment_model.dart';
import '../models/patient_model.dart';

abstract class TreatmentDataSource {
  Future<List<TreatmentModel>> getTreatments();
  Future<List<BranchModel>> getBranches();
}

import '../models/patient_model.dart';

abstract class PatientDataSource {
  Future<List<PatientModel>> getPatients();
}

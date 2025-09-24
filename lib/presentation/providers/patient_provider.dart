import 'package:flutter/foundation.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';

class PatientProvider extends ChangeNotifier {
  final PatientRepository _patientRepository;

  PatientProvider({
    required PatientRepository patientRepository,
  }) : _patientRepository = patientRepository;

  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasPatients => _patients.isNotEmpty;

  Future<void> fetchPatients() async {
    _setLoading(true);
    _clearError();

    final result = await _patientRepository.getPatients();

    result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
      },
      (patients) {
        _patients = patients;
        _setLoading(false);
        notifyListeners();
      },
    );
  }

  Future<void> refreshPatients() async {
    await fetchPatients();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearPatients() {
    _patients = [];
    _clearError();
    notifyListeners();
  }
}

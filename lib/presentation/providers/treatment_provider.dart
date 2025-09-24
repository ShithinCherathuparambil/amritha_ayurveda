import 'package:flutter/foundation.dart';
import '../../domain/entities/treatment.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/treatment_repository.dart';

/// Provider for managing treatment state
class TreatmentProvider extends ChangeNotifier {
  final TreatmentRepository _treatmentRepository;

  TreatmentProvider({required TreatmentRepository treatmentRepository})
    : _treatmentRepository = treatmentRepository;

  List<Treatment> _treatments = [];
  List<Branch> _branches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Treatment> get treatments => _treatments;
  List<Branch> get branches => _branches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasTreatments => _treatments.isNotEmpty;
  bool get hasBranches => _branches.isNotEmpty;

  Future<void> fetchTreatments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _treatmentRepository.getTreatments();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (treatments) {
        _treatments = treatments;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> fetchBranches() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _treatmentRepository.getBranches();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (branches) {
        _branches = branches;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> fetchAll() async {
    await Future.wait([fetchTreatments(), fetchBranches()]);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/patient_provider.dart';
import '../presentation/providers/treatment_provider.dart';
import '../data/datasources/http_auth_datasource.dart';
import '../data/datasources/http_patient_datasource.dart';
import '../data/datasources/http_treatment_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/patient_repository_impl.dart';
import '../data/repositories/treatment_repository_impl.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AuthProvider>(
    create: (_) => AuthProvider(
      authRepository: AuthRepositoryImpl(dataSource: HttpAuthDataSource()),
    ),
  ),
  ChangeNotifierProvider<TreatmentProvider>(
    create: (context) {
      final authDataSource = HttpAuthDataSource();
      final treatmentDataSource = HttpTreatmentDataSource(
        dio: Dio(),
        authDataSource: authDataSource,
      );
      final treatmentRepository = TreatmentRepositoryImpl(
        treatmentDataSource: treatmentDataSource,
      );
      return TreatmentProvider(treatmentRepository: treatmentRepository);
    },
  ),
  ChangeNotifierProvider<PatientProvider>(
    create: (context) {
      final authDataSource = HttpAuthDataSource();
      final patientDataSource = HttpPatientDataSource(
        dio: Dio(),
        authDataSource: authDataSource,
      );
      final patientRepository = PatientRepositoryImpl(
        patientDataSource: patientDataSource,
      );
      return PatientProvider(patientRepository: patientRepository);
    },
  ),
];

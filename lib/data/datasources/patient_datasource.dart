import '../models/patient_model.dart';

class PatientRegistrationRequest {
  final String name;
  final String executive;
  final String payment;
  final String phone;
  final String address;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final String dateNdTime;
  final String id; // Empty string for new patients
  final String male; // Comma-separated treatment IDs
  final String female; // Comma-separated treatment IDs
  final int branch;
  final String treatments; // Comma-separated treatment IDs

  const PatientRegistrationRequest({
    required this.name,
    required this.executive,
    required this.payment,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateNdTime,
    required this.id,
    required this.male,
    required this.female,
    required this.branch,
    required this.treatments,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'excecutive': executive, // Note: API uses 'excecutive' (typo in API)
      'payment': payment,
      'phone': phone,
      'address': address,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'advance_amount': advanceAmount,
      'balance_amount': balanceAmount,
      'date_nd_time': dateNdTime,
      'id': id,
      'male': male,
      'female': female,
      'branch': branch,
      'treatments': treatments,
    };
  }
}

abstract class PatientDataSource {
  Future<List<PatientModel>> getPatients();
  Future<PatientModel> registerPatient(PatientRegistrationRequest request);
}

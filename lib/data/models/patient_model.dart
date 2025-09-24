import '../../domain/entities/patient.dart';

class PatientModel {
  final int id;
  final List<PatientDetailsModel> patientdetailsSet;
  final BranchModel branch;
  final String user;
  final String payment;
  final String name;
  final String phone;
  final String address;
  final double? price;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final DateTime dateNdTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PatientModel({
    required this.id,
    required this.patientdetailsSet,
    required this.branch,
    required this.user,
    required this.payment,
    required this.name,
    required this.phone,
    required this.address,
    this.price,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateNdTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    try {
      return PatientModel(
        id: json['id'] as int? ?? 0,
        patientdetailsSet:
            (json['patientdetails_set'] as List<dynamic>?)
                ?.map(
                  (e) =>
                      PatientDetailsModel.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [],
        branch: json['branch'] != null
            ? BranchModel.fromJson(json['branch'] as Map<String, dynamic>)
            : const BranchModel(
                id: 0,
                name: '',
                patientsCount: 0,
                location: '',
                phone: '',
                mail: '',
                address: '',
                gst: '',
                isActive: true,
              ),
        user: json['user']?.toString() ?? '',
        payment: json['payment']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        price: json['price'] != null ? (json['price'] as num).toDouble() : null,
        totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
        discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
        advanceAmount: (json['advance_amount'] as num?)?.toDouble() ?? 0.0,
        balanceAmount: (json['balance_amount'] as num?)?.toDouble() ?? 0.0,
        dateNdTime: _parseDateTime(json['date_nd_time']),
        isActive: json['is_active'] as bool? ?? true,
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
    } catch (e) {
      print('Error parsing PatientModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        print('Error parsing date: $dateValue, error: $e');
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientdetails_set': patientdetailsSet?.map((e) => e.toJson()).toList(),
      'branch': branch?.toJson(),
      'user': user,
      'payment': payment,
      'name': name,
      'phone': phone,
      'address': address,
      'price': price,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'advance_amount': advanceAmount,
      'balance_amount': balanceAmount,
      'date_nd_time': dateNdTime?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Patient toEntity() {
    return Patient(
      id: id,
      patientDetails: patientdetailsSet.map((e) => e.toEntity()).toList(),
      branch: branch.toEntity(),
      user: user,
      payment: payment,
      name: name,
      phone: phone,
      address: address,
      price: price,
      totalAmount: totalAmount,
      discountAmount: discountAmount,
      advanceAmount: advanceAmount,
      balanceAmount: balanceAmount,
      dateNdTime: dateNdTime,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class PatientDetailsModel {
  final int id;
  final String male;
  final String female;
  final int patient;
  final int treatment;
  final String treatmentName;

  const PatientDetailsModel({
    required this.id,
    required this.male,
    required this.female,
    required this.patient,
    required this.treatment,
    required this.treatmentName,
  });

  factory PatientDetailsModel.fromJson(Map<String, dynamic> json) {
    try {
      return PatientDetailsModel(
        id: json['id'] as int? ?? 0,
        male: json['male']?.toString() ?? '',
        female: json['female']?.toString() ?? '',
        patient: json['patient'] as int? ?? 0,
        treatment: json['treatment'] as int? ?? 0,
        treatmentName: json['treatment_name']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing PatientDetailsModel: $e');
      return PatientDetailsModel(
        id: 0,
        male: '',
        female: '',
        patient: 0,
        treatment: 0,
        treatmentName: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'male': male,
      'female': female,
      'patient': patient,
      'treatment': treatment,
      'treatment_name': treatmentName,
    };
  }

  PatientDetails toEntity() {
    return PatientDetails(
      id: id,
      male: male,
      female: female,
      patient: patient,
      treatment: treatment,
      treatmentName: treatmentName,
    );
  }
}

class BranchModel {
  final int id;
  final String name;
  final int patientsCount;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;

  const BranchModel({
    required this.id,
    required this.name,
    required this.patientsCount,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    try {
      return BranchModel(
        id: json['id'] as int? ?? 0,
        name: json['name']?.toString() ?? '',
        patientsCount: json['patients_count'] as int? ?? 0,
        location: json['location']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        mail: json['mail']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        gst: json['gst']?.toString() ?? '',
        isActive: json['is_active'] as bool? ?? true,
      );
    } catch (e) {
      print('Error parsing BranchModel: $e');
      return BranchModel(
        id: 0,
        name: '',
        patientsCount: 0,
        location: '',
        phone: '',
        mail: '',
        address: '',
        gst: '',
        isActive: true,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'patients_count': patientsCount,
      'location': location,
      'phone': phone,
      'mail': mail,
      'address': address,
      'gst': gst,
      'is_active': isActive,
    };
  }

  Branch toEntity() {
    return Branch(
      id: id,
      name: name,
      patientsCount: patientsCount,
      location: location,
      phone: phone,
      mail: mail,
      address: address,
      gst: gst,
      isActive: isActive,
    );
  }
}

class PatientListResponseModel {
  bool? status;
  String? message;
  List<PatientModel>? patients;

  PatientListResponseModel({this.status, this.message, this.patients});

  factory PatientListResponseModel.fromJson(Map<String, dynamic> json) {
    return PatientListResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      patients: (json['patient'] as List<dynamic>?)
          ?.map((e) => PatientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'patient': patients?.map((e) => e.toJson()).toList(),
    };
  }
}

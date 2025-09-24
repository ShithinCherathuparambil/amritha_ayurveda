import '../../domain/entities/treatment.dart';
import 'patient_model.dart';

class TreatmentModel {
  final int id;
  final List<BranchModel> branches;
  final String name;
  final String duration;
  final String price; // API returns price as string
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TreatmentModel({
    required this.id,
    required this.branches,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    try {
      return TreatmentModel(
        id: json['id'] as int? ?? 0,
        branches:
            (json['branches'] as List<dynamic>?)
                ?.map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        name: json['name']?.toString() ?? '',
        duration: json['duration']?.toString() ?? '',
        price: json['price']?.toString() ?? '0',
        isActive: json['is_active'] as bool? ?? true,
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
    } catch (e) {
      print('Error parsing TreatmentModel: $e');
      return TreatmentModel(
        id: 0,
        branches: [],
        name: '',
        duration: '',
        price: '0',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
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
      'name': name,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Treatment toEntity() {
    return Treatment(
      id: id,
      branches: branches.map((branch) => branch.toEntity()).toList(),
      name: name,
      duration: duration,
      price: price,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class TreatmentListResponseModel {
  bool? status;
  String? message;
  List<TreatmentModel>? treatments;

  TreatmentListResponseModel({this.status, this.message, this.treatments});

  factory TreatmentListResponseModel.fromJson(Map<String, dynamic> json) {
    return TreatmentListResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      treatments: (json['treatments'] as List<dynamic>?)
          ?.map((e) => TreatmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'treatments': treatments?.map((e) => e.toJson()).toList(),
    };
  }
}

class BranchListResponseModel {
  bool? status;
  String? message;
  List<BranchModel>? branches;

  BranchListResponseModel({this.status, this.message, this.branches});

  factory BranchListResponseModel.fromJson(Map<String, dynamic> json) {
    return BranchListResponseModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'branches': branches?.map((e) => e.toJson()).toList(),
    };
  }
}

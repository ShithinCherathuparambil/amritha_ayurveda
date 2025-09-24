import 'patient.dart';

class Treatment {
  final int id;
  final List<Branch> branches;
  final String name;
  final String duration;
  final String price; // Keep as string to match API
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Treatment({
    required this.id,
    required this.branches,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper method to get price as double
  double get priceAsDouble {
    return double.tryParse(price) ?? 0.0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Treatment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Treatment(id: $id, name: $name, duration: $duration, price: $price)';
  }
}

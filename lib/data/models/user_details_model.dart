import '../../domain/entities/user.dart';

/// Model for user details from login API response
class UserDetailsModel {
  const UserDetailsModel({
    required this.id,
    this.lastLogin,
    required this.name,
    required this.phone,
    required this.address,
    required this.mail,
    required this.username,
    required this.password,
    required this.passwordText,
    required this.admin,
    required this.isAdmin,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.branch,
  });

  final int id;
  final DateTime? lastLogin;
  final String name;
  final String phone;
  final String address;
  final String mail;
  final String username;
  final String password;
  final String passwordText;
  final int admin;
  final bool isAdmin;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic branch; // Can be null or other type

  /// Create UserDetailsModel from JSON
  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'] ?? 0,
      lastLogin: json['last_login'] != null 
          ? DateTime.tryParse(json['last_login'].toString())
          : null,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      mail: json['mail'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      passwordText: json['password_text'] ?? '',
      admin: json['admin'] ?? 0,
      isAdmin: json['is_admin'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      branch: json['branch'],
    );
  }

  /// Convert UserDetailsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_login': lastLogin?.toIso8601String(),
      'name': name,
      'phone': phone,
      'address': address,
      'mail': mail,
      'username': username,
      'password': password,
      'password_text': passwordText,
      'admin': admin,
      'is_admin': isAdmin,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'branch': branch,
    };
  }

  /// Convert to domain User entity
  User toEntity() {
    // Split name into first and last name
    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    return User(
      id: id.toString(),
      email: mail,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phone.isNotEmpty ? phone : null,
      isEmailVerified: true, // Assume verified if login successful
      isPhoneVerified: phone.isNotEmpty,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy with updated fields
  UserDetailsModel copyWith({
    int? id,
    DateTime? lastLogin,
    String? name,
    String? phone,
    String? address,
    String? mail,
    String? username,
    String? password,
    String? passwordText,
    int? admin,
    bool? isAdmin,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic branch,
  }) {
    return UserDetailsModel(
      id: id ?? this.id,
      lastLogin: lastLogin ?? this.lastLogin,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      mail: mail ?? this.mail,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordText: passwordText ?? this.passwordText,
      admin: admin ?? this.admin,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      branch: branch ?? this.branch,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDetailsModel &&
        other.id == id &&
        other.lastLogin == lastLogin &&
        other.name == name &&
        other.phone == phone &&
        other.address == address &&
        other.mail == mail &&
        other.username == username &&
        other.password == password &&
        other.passwordText == passwordText &&
        other.admin == admin &&
        other.isAdmin == isAdmin &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.branch == branch;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      lastLogin,
      name,
      phone,
      address,
      mail,
      username,
      password,
      passwordText,
      admin,
      isAdmin,
      isActive,
      createdAt,
      updatedAt,
      branch,
    );
  }

  @override
  String toString() {
    return 'UserDetailsModel(id: $id, lastLogin: $lastLogin, name: $name, phone: $phone, address: $address, mail: $mail, username: $username, admin: $admin, isAdmin: $isAdmin, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, branch: $branch)';
  }
}

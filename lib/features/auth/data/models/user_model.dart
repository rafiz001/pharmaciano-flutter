import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
  
  // Factory constructor from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    };
  }
  
  // Convert to Entity (domain layer)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      role: role,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          role == other.role;
  
  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ name.hashCode ^ role.hashCode;
  
  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, name: $name, role: $role}';
  }
}

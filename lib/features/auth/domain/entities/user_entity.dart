class UserEntity {
  final String id;
  final String email;
  final String name;
  final String role;
  
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          role == other.role;
  
  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ name.hashCode ^ role.hashCode;
}

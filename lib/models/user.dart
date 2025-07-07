class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? address;
  final String? phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.address,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'address': address,
      'phone': phone,
    };
  }
}

enum UserRole { user, admin }
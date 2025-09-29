class User {
  final String email;
  final String password;
  final String? nombreCompleto;
  final DateTime? fechaNacimiento;
  final String role;

  User({
    required this.email,
    required this.password,
    this.nombreCompleto,
    this.fechaNacimiento,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      nombreCompleto: json['nombreCompleto'],
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'])
          : null,
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (nombreCompleto != null) 'nombreCompleto': nombreCompleto,
      if (fechaNacimiento != null)
        'fechaNacimiento': fechaNacimiento!.toIso8601String(),
      'role': role,
    };
  }
}

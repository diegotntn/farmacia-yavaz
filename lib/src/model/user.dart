/// Modelo de datos `User`
///
/// Representa un usuario general (cliente, vendedor, admin) en la app.
/// Se espera que el backend envíe y reciba estos campos vía JSON.
///
/// Campos esperados en JSON:
///   - id (int)
///   - email (string)
///   - password (string) ← opcional al recibir
///   - name (string)
///   - fechaNacimiento (string ISO8601, opcional)
///   - role (string) → client | vendor | admin

class User {
  final int id;
  final String email;
  final String? password; // Se envía solo en registro/login
  final String name;
  final DateTime? fechaNacimiento;
  final String role;

  User({
    required this.id,
    required this.email,
    this.password,
    required this.name,
    this.fechaNacimiento,
    required this.role,
  });

  /// Convierte un JSON recibido desde la API a una instancia de `User`.
  ///
  /// Usa `tryParse` para manejar fechas mal formateadas o nulas.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      password: json.containsKey('password') ? json['password'] : null,
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.tryParse(json['fechaNacimiento'])
          : null,
      role: json['role'] ?? 'client',
    );
  }

  /// Convierte la instancia de `User` en un `Map<String, dynamic>` para enviar a la API.
  ///
  /// Solo incluye `password` si está presente (útil para login/registro).
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    };

    if (password != null) data['password'] = password;
    if (fechaNacimiento != null) {
      data['fechaNacimiento'] = fechaNacimiento!.toIso8601String();
    }

    return data;
  }
}

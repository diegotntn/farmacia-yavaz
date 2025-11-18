import 'user.dart';

/// Modelo `Client`
///
/// Representa a un usuario con rol `client`, extendiendo de `User`.
/// Agrega información adicional como:
///   - Teléfono (`phoneNumber`)
///   - Dirección (`address`)
///
/// Este modelo se espera que se use en pantallas de perfil, registro,
/// pedidos o historial de compras.

class Client extends User {
  final String? phoneNumber;
  final String? address;

  Client({
    required int id,
    required String email,
    String? password,
    required String name,
    DateTime? fechaNacimiento,
    this.phoneNumber,
    this.address,
  }) : super(
          id: id,
          email: email,
          password: password,
          name: name,
          fechaNacimiento: fechaNacimiento,
          role: 'client', // Forzamos que siempre sea client
        );

  /// Crea un `Client` desde un JSON recibido de la API.
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      password: json['password'], // opcional
      name: json['name'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.tryParse(json['fechaNacimiento'])
          : null,
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }

  /// Convierte el modelo `Client` a JSON para enviarlo a la API.
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
    });
    return data;
  }
}

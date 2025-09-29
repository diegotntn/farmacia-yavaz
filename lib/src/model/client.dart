import 'user.dart';

class Client extends User {
  final String? phoneNumber;
  final String? address;

  Client({
    required String email,
    required String password,
    String? nombreCompleto,
    DateTime? fechaNacimiento,
    this.phoneNumber,
    this.address,
  }) : super(
          email: email,
          password: password,
          nombreCompleto: nombreCompleto,
          fechaNacimiento: fechaNacimiento,
          role: 'client',
        );

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      nombreCompleto: json['nombreCompleto'],
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'])
          : null,
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }

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

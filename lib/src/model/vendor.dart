import 'user.dart';

class Vendor extends User {
  final String? storeName;
  final String? storeAddress;

  Vendor({
    required String email,
    required String password,
    String? nombreCompleto,
    DateTime? fechaNacimiento,
    this.storeName,
    this.storeAddress,
  }) : super(
          email: email,
          password: password,
          nombreCompleto: nombreCompleto,
          fechaNacimiento: fechaNacimiento,
          role: 'vendor',
        );

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      nombreCompleto: json['nombreCompleto'],
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'])
          : null,
      storeName: json['storeName'],
      storeAddress: json['storeAddress'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      if (storeName != null) 'storeName': storeName,
      if (storeAddress != null) 'storeAddress': storeAddress,
    });
    return data;
  }
}

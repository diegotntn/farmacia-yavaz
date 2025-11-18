import 'user.dart';

/// -------------------------------------------------------------------------
/// 🧾 Clase: Vendor
///
/// Representa a un **vendedor** dentro del sistema de la farmacia online.
///
/// Hereda de la clase base `User`, por lo tanto comparte todos sus campos:
///   - id              → Identificador único del usuario en la BD (int)
///   - email           → Correo electrónico (string)
///   - password        → Contraseña (string, opcional en respuestas)
///   - name            → Nombre completo del usuario o propietario
///   - fechaNacimiento → Fecha opcional de nacimiento (DateTime)
///   - role            → Rol del usuario (en este caso siempre "vendor")
///
/// Además, esta clase añade información específica del vendedor:
///   - storeName       → Nombre de la tienda o farmacia asociada
///   - storeAddress    → Dirección física del establecimiento
///
/// Esta estructura es ideal si el backend tiene una tabla `users`
/// y una tabla hija `vendors` relacionada por el `user_id`.
/// -------------------------------------------------------------------------
class Vendor extends User {
  // -----------------------------------------------------------------------
  // 🔹 CAMPOS ESPECÍFICOS DEL VENDEDOR
  // -----------------------------------------------------------------------

  /// Nombre del negocio o farmacia del vendedor.
  final String? storeName;

  /// Dirección física de la tienda (puede ser opcional).
  final String? storeAddress;

  // -----------------------------------------------------------------------
  // 🔹 CONSTRUCTOR
  // -----------------------------------------------------------------------

  /// Constructor principal de la clase `Vendor`.
  ///
  /// Requiere los campos básicos heredados de `User`:
  ///   - `id`, `email`, `name`, y opcionalmente `password` y `fechaNacimiento`.
  ///
  /// Además, puede incluir `storeName` y `storeAddress` si están disponibles.
  ///
  /// El campo `role` siempre se asigna automáticamente como `'vendor'`
  /// para garantizar coherencia con el backend.
  Vendor({
    required int id,
    required String email,
    String? password,
    required String name,
    DateTime? fechaNacimiento,
    this.storeName,
    this.storeAddress,
  }) : super(
          id: id,
          email: email,
          password: password,
          name: name,
          fechaNacimiento: fechaNacimiento,
          role: 'vendor', // Forzamos el rol, no se puede cambiar desde fuera
        );

  // -----------------------------------------------------------------------
  // 🔹 FACTORY CONSTRUCTOR: fromJson()
  // -----------------------------------------------------------------------

  /// Crea una instancia de `Vendor` a partir de un objeto JSON
  /// recibido desde la API o base de datos.
  ///
  /// Este método es muy útil cuando haces una petición HTTP (GET o POST)
  /// y el backend devuelve un vendedor en formato JSON.
  ///
  /// Ejemplo de JSON esperado:
  /// ```json
  /// {
  ///   "id": 34,
  ///   "email": "vendedor@farmacia.com",
  ///   "name": "Farmacia Morelos",
  ///   "fechaNacimiento": "1980-02-01T00:00:00Z",
  ///   "role": "vendor",
  ///   "storeName": "Farmacia Morelos",
  ///   "storeAddress": "Av. Reforma 1201, Tlaxcala"
  /// }
  /// ```
  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] ?? 0, // Valor por defecto si no se encuentra el ID
      email: json['email'] ?? '', // Evita errores si el campo viene nulo
      password: json['password'], // Puede ser null (seguridad del backend)
      name: json['name'] ?? '', // Nombre o razón social
      // Se usa tryParse para evitar errores si la fecha no tiene el formato ISO8601
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.tryParse(json['fechaNacimiento'])
          : null,
      // Campos exclusivos del vendedor
      storeName: json['storeName'],
      storeAddress: json['storeAddress'],
    );
  }

  // -----------------------------------------------------------------------
  // 🔹 MÉTODO: toJson()
  // -----------------------------------------------------------------------

  /// Convierte la instancia actual de `Vendor` en un mapa JSON.
  ///
  /// Esto es útil para enviar datos al servidor mediante un POST o PUT,
  /// por ejemplo, al **registrar un vendedor nuevo** o **editar su perfil**.
  ///
  /// Incluye todos los campos heredados de `User` más los específicos
  /// del vendedor (`storeName` y `storeAddress`).
  @override
  Map<String, dynamic> toJson() {
    // Llamamos al método padre (`User.toJson()`) para heredar los campos base
    final data = super.toJson();

    // Agregamos los campos propios de Vendor al JSON resultante
    data.addAll({
      if (storeName != null) 'storeName': storeName,
      if (storeAddress != null) 'storeAddress': storeAddress,
    });

    return data;
  }
}

import 'package:e_commerce_flutter/src/service/api_service.dart';
import 'package:http/http.dart' as http;

/// ------------------------------------------------------------
/// 🔐 Clase AuthService
///
/// Servicio encargado de manejar la autenticación del usuario:
///   - Inicio de sesión
///   - Registro de nuevos usuarios
///   - Cierre de sesión
///
/// Este servicio utiliza `ApiService` para hacer peticiones HTTP
/// al backend definido en la variable de entorno `API_BASE_URL`.
/// ------------------------------------------------------------
class AuthService {
  // -----------------------------------------------------------------------
  // 🔹 MÉTODO: login()
  // -----------------------------------------------------------------------

  /// Realiza el login del usuario con email y contraseña.
  ///
  /// Retorna el cuerpo de la respuesta como `Map<String, dynamic>`,
  /// que debe contener al menos el token y los datos del usuario.
  ///
  /// Ejemplo de respuesta esperada:
  /// ```json
  /// {
  ///   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6...",
  ///   "user": {
  ///     "id": 1,
  ///     "email": "usuario@correo.com",
  ///     "name": "Juan Pérez",
  ///     "role": "client"
  ///   }
  /// }
  /// ```
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await ApiService.post(
        'auth/login',
        {
          'email': email,
          'password': password,
        },
        auth: false); // No requiere token

    if (response.statusCode == 200) {
      return ApiService.decode(response);
    } else {
      throw Exception('Error de login: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 MÉTODO: register()
  // -----------------------------------------------------------------------

  /// Registra un nuevo usuario.
  ///
  /// El parámetro `data` debe contener:
  ///   - email
  ///   - password
  ///   - name (u otros campos adicionales según backend)
  ///
  /// El backend debe retornar un 201 si fue creado correctamente.
  static Future<void> register(Map<String, dynamic> data) async {
    final response = await ApiService.post('auth/register', data, auth: false);

    if (response.statusCode != 201) {
      throw Exception('Error de registro: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 MÉTODO: logout()
  // -----------------------------------------------------------------------

  /// Cierra sesión del usuario.
  ///
  /// Este endpoint debe invalidar el token del backend (si aplica).
  /// Requiere autenticación.
  static Future<void> logout() async {
    final response = await ApiService.post('auth/logout', {}, auth: true);

    if (response.statusCode != 200) {
      throw Exception('Error al cerrar sesión');
    }
  }
}

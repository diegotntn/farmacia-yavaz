import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ------------------------------------------------------------
/// 🔐 Clase SessionManager
///
/// Esta clase centraliza toda la gestión de sesión del usuario.
///
/// Permite:
///   - Guardar el token JWT (o similar) recibido al hacer login.
///   - Guardar datos básicos del usuario (nombre, email, rol).
///   - Recuperar esos datos desde cualquier parte del app.
///   - Cerrar sesión limpiando la información almacenada.
///
/// Utiliza dos sistemas de almacenamiento:
///   1️⃣ `FlutterSecureStorage` → para datos sensibles (token).
///   2️⃣ `SharedPreferences` → para datos simples (nombre, rol, etc.).
///
/// Nota:
/// En web, `flutter_secure_storage` puede no funcionar.
/// Por eso, este código usa `try/catch` para hacer fallback automático
/// a `SharedPreferences` en caso de error o incompatibilidad.
/// ------------------------------------------------------------
class SessionManager {
  // ------------------------------------------------------------
  // 🔸 CLAVES INTERNAS
  // ------------------------------------------------------------
  // Estas constantes definen las "llaves" con las que los valores
  // serán guardados en el almacenamiento local.
  // Si cambias una clave, perderás los datos almacenados previamente.
  static const _kToken = 'auth_token'; // Token de autenticación (JWT)
  static const _kRole =
      'user_role'; // Rol del usuario (client, vendor, admin, etc.)
  static const _kUserName = 'user_name'; // Nombre del usuario
  static const _kUserEmail = 'user_email'; // Correo electrónico del usuario

  // Instancia única de almacenamiento seguro (cifrado en disco)
  // Internamente, usa Keystore (Android) o Keychain (iOS).
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // ------------------------------------------------------------
  // 🔹 TOKEN
  // ------------------------------------------------------------

  /// Guarda el token en almacenamiento seguro.
  ///
  /// Si `flutter_secure_storage` falla (por ejemplo en web o desktop),
  /// se usa `SharedPreferences` como respaldo (no cifrado).
  static Future<void> saveToken(String token) async {
    try {
      // Intentamos guardar de forma cifrada (segura)
      await _secureStorage.write(key: _kToken, value: token);
    } catch (_) {
      // Si falla (por ejemplo, en web), guardamos en preferencias simples
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kToken, token);
    }
  }

  /// Recupera el token de sesión (JWT).
  ///
  /// Devuelve `null` si el token no existe o no se pudo leer.
  static Future<String?> getToken() async {
    try {
      // Intentamos leer desde almacenamiento seguro
      final token = await _secureStorage.read(key: _kToken);
      if (token != null) return token;
    } catch (_) {
      // Si falla, continuamos leyendo desde SharedPreferences
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  /// Elimina únicamente el token de sesión (sin borrar otros datos).
  static Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: _kToken);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
  }

  // ------------------------------------------------------------
  // 🔹 ROL DEL USUARIO
  // ------------------------------------------------------------

  /// Guarda el rol actual del usuario.
  ///
  /// Ejemplo de roles: `'client'`, `'vendor'`, `'admin'`.
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRole, role);
  }

  /// Obtiene el rol almacenado del usuario.
  ///
  /// Si no existe, devuelve `null`.
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRole);
  }

  // ------------------------------------------------------------
  // 🔹 INFORMACIÓN BÁSICA DEL USUARIO
  // ------------------------------------------------------------

  /// Guarda el nombre y correo del usuario.
  ///
  /// Esto es útil para mostrar en pantallas de perfil o encabezados.
  /// (No incluye información sensible).
  static Future<void> saveUserInfo({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserName, name);
    await prefs.setString(_kUserEmail, email);
  }

  /// Obtiene el nombre del usuario actual.
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserName);
  }

  /// Obtiene el correo electrónico del usuario actual.
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserEmail);
  }

  // ------------------------------------------------------------
  // 🔹 LIMPIEZA DE DATOS / LOGOUT
  // ------------------------------------------------------------

  /// Borra toda la información guardada de la sesión actual.
  ///
  /// Esto incluye:
  ///   - Token JWT
  ///   - Rol
  ///   - Nombre y correo del usuario
  ///
  /// Se recomienda llamar a este método cuando el usuario cierra sesión.
  static Future<void> clearAll() async {
    try {
      // Intentamos eliminar todo desde almacenamiento seguro
      await _secureStorage.deleteAll();
    } catch (_) {}
    // Y también desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ------------------------------------------------------------
  // 🔹 VERIFICACIÓN DE SESIÓN ACTIVA
  // ------------------------------------------------------------

  /// Devuelve `true` si existe un token válido almacenado.
  ///
  /// Se usa normalmente en el arranque de la app para determinar
  /// si el usuario ya inició sesión y debe ir directo al `HomeScreen`.
  static Future<bool> hasActiveSession() async {
    final token = await getToken();
    // Se considera sesión activa si existe un token no vacío
    return token != null && token.isNotEmpty;
  }
}

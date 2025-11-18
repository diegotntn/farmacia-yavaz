import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ===========================================================================
/// 🔐 SessionManager
///
/// Administra toda la información de sesión del usuario:
///   ✔ Token JWT
///   ✔ Rol del usuario
///   ✔ Nombre y correo
///
/// Usa dos tipos de almacenamiento:
///   🔹 FlutterSecureStorage → datos sensibles (token)
///   🔹 SharedPreferences → datos simples (rol, nombre, email)
///
/// En caso de fallo en almacenamiento seguro (web/desktop),
/// usa fallback automático a SharedPreferences.
/// ===========================================================================
class SessionManager {
  // ===========================================================================
  // 🔸 CLAVES INTERNAS
  // ===========================================================================
  static const _kToken = 'auth_token';
  static const _kRole = 'user_role';
  static const _kUserName = 'user_name';
  static const _kUserEmail = 'user_email';

  // Almacenamiento seguro
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // ===========================================================================
  // 🔹 TOKEN
  // ===========================================================================

  static Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _kToken, value: token);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kToken, token);
    }
  }

  static Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: _kToken);
      if (token != null) return token;
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  static Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: _kToken);
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
  }

  // ===========================================================================
  // 🔹 ROL DEL USUARIO
  // ===========================================================================
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRole, role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRole);
  }

  // ===========================================================================
  // 🔹 INFORMACIÓN BÁSICA DEL USUARIO
  // ===========================================================================
  static Future<void> saveUserInfo({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserName, name);
    await prefs.setString(_kUserEmail, email);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserName);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserEmail);
  }

  // ===========================================================================
  // 🔹 LIMPIAR TODO (LOGOUT)
  // ===========================================================================
  static Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ===========================================================================
  // 🔹 VERIFICACIÓN DE SESIÓN
  // ===========================================================================

  /// ✔ Método original
  static Future<bool> hasActiveSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// ✔ Nuevo método solicitado por ti (alias del anterior)
  ///
  /// Esto evita:
  ///   "The method 'isLoggedIn' isn't defined for the type 'SessionManager'"
  static Future<bool> isLoggedIn() async {
    return await hasActiveSession();
  }
}

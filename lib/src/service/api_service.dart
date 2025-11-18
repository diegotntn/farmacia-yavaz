import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_commerce_flutter/core/session_manager.dart';

/// ------------------------------------------------------------
/// 📡 Clase ApiService
///
/// Esta clase proporciona métodos estáticos para realizar peticiones
/// HTTP (GET, POST, PUT, DELETE) hacia la API del backend.
///
/// Lee automáticamente la `API_BASE_URL` desde el archivo `.env`
/// y agrega el token JWT a los encabezados si está disponible.
/// ------------------------------------------------------------
class ApiService {
  // ------------------------------------------------------------
  // 🔹 Base URL definida en el archivo .env
  // ------------------------------------------------------------
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  /// Construye la URL completa con endpoint relativo
  static Uri _buildUrl(String endpoint, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl/$endpoint').replace(queryParameters: query);
  }

  /// Construye encabezados para la petición
  ///
  /// Si `auth` es `true`, intenta agregar el token JWT almacenado.
  static Future<Map<String, String>> _buildHeaders({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};

    if (auth) {
      final token = await SessionManager.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ------------------------------------------------------------
  // 🔹 Método GET
  // ------------------------------------------------------------
  static Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) async {
    final url = _buildUrl(endpoint, query);
    final headers = await _buildHeaders(auth: auth);
    return await http.get(url, headers: headers);
  }

  // ------------------------------------------------------------
  // 🔹 Método POST
  // ------------------------------------------------------------
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final url = _buildUrl(endpoint);
    final headers = await _buildHeaders(auth: auth);
    return await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // ------------------------------------------------------------
  // 🔹 Método PUT
  // ------------------------------------------------------------
  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final url = _buildUrl(endpoint);
    final headers = await _buildHeaders(auth: auth);
    return await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // ------------------------------------------------------------
  // 🔹 Método DELETE
  // ------------------------------------------------------------
  static Future<http.Response> delete(
    String endpoint, {
    bool auth = true,
  }) async {
    final url = _buildUrl(endpoint);
    final headers = await _buildHeaders(auth: auth);
    return await http.delete(url, headers: headers);
  }

  // ------------------------------------------------------------
  // 🔹 Método para decodificar respuesta JSON
  // ------------------------------------------------------------

  /// Decodifica un `http.Response` usando `utf8` para manejar acentos y caracteres especiales.
  ///
  /// Útil para obtener un `Map<String, dynamic>` o `List<dynamic>` directamente.
  static dynamic decode(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

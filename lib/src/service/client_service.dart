import 'package:http/http.dart' as http;
import 'package:e_commerce_flutter/src/service/api_service.dart';

/// ------------------------------------------------------------
/// 👤 ClientService
///
/// Servicio encargado de manejar toda la lógica relacionada con
/// el cliente autenticado (rol `client`) en la farmacia online.
///
/// Endpoints esperados:
///   GET    /clients/:id               → perfil del cliente
///   GET    /clients/:id/orders        → historial de compras
///   GET    /clients/:id/cart          → obtener carrito
///   POST   /clients/:id/cart          → actualizar carrito
///   POST   /clients/:id/checkout      → procesar pedido
/// ------------------------------------------------------------
class ClientService {
  // -----------------------------------------------------------------------
  // 🔹 Obtener perfil del cliente
  // -----------------------------------------------------------------------

  /// Obtiene la información del cliente desde `/clients/:id`.
  ///
  /// Retorna un `Map<String, dynamic>` que representa un `Client`.
  static Future<Map<String, dynamic>> getProfile(int clientId) async {
    final http.Response response = await ApiService.get('clients/$clientId');

    if (response.statusCode == 200) {
      return ApiService.decode(response);
    } else {
      throw Exception('Error al obtener perfil: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Obtener historial de pedidos
  // -----------------------------------------------------------------------

  /// Retorna una lista de pedidos del cliente (`List<dynamic>`),
  /// la cual puedes convertir en `Order` o estructura que uses.
  static Future<List<dynamic>> getOrders(int clientId) async {
    final response = await ApiService.get('clients/$clientId/orders');

    if (response.statusCode == 200) {
      final body = ApiService.decode(response);
      return (body is Map && body['data'] is List)
          ? body['data']
          : (body as List<dynamic>);
    } else {
      throw Exception('Error al obtener pedidos: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Obtener carrito actual del cliente
  // -----------------------------------------------------------------------

  /// Retorna el carrito de compras actual del cliente como lista.
  ///
  /// Ideal para mostrar en `cart_screen.dart`.
  static Future<List<dynamic>> getCart(int clientId) async {
    final response = await ApiService.get('clients/$clientId/cart');

    if (response.statusCode == 200) {
      final body = ApiService.decode(response);
      return (body is Map && body['items'] is List)
          ? body['items']
          : (body as List<dynamic>);
    } else {
      throw Exception('Error al obtener carrito: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Actualizar el carrito del cliente
  // -----------------------------------------------------------------------

  /// Envía un nuevo carrito para guardar/actualizar en la base de datos.
  ///
  /// El parámetro `cartData` debe ser un mapa como:
  /// ```json
  /// {
  ///   "items": [
  ///     { "product_id": 1, "quantity": 2 },
  ///     { "product_id": 3, "quantity": 1 }
  ///   ]
  /// }
  /// ```
  static Future<void> updateCart(
      int clientId, Map<String, dynamic> cartData) async {
    final response = await ApiService.post('clients/$clientId/cart', cartData);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al actualizar carrito: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Confirmar compra (checkout)
  // -----------------------------------------------------------------------

  /// Procesa la compra actual del cliente (`POST /clients/:id/checkout`)
  ///
  /// Puedes incluir dirección, método de pago, etc. en el body.
  static Future<void> checkout(int clientId, Map<String, dynamic> data) async {
    final response = await ApiService.post('clients/$clientId/checkout', data);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al procesar pedido: ${response.statusCode}');
    }
  }
}

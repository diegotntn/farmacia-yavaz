import 'package:http/http.dart' as http;
import 'package:e_commerce_flutter/src/service/api_service.dart';

/// ------------------------------------------------------------
/// 🏪 VendorService
///
/// Servicio que permite al vendedor autenticado:
///   - Ver su perfil
///   - Gestionar sus productos
///   - Consultar sus ventas
///   - Editar productos propios
///
/// Endpoints esperados (pueden variar según backend):
///   GET    /vendors/:id
///   GET    /vendors/:id/products
///   POST   /vendors/:id/products
///   PUT    /vendors/products/:product_id
///   DELETE /vendors/products/:product_id
///   GET    /vendors/:id/stats
/// ------------------------------------------------------------
class VendorService {
  // -----------------------------------------------------------------------
  // 🔹 Obtener perfil del vendedor
  // -----------------------------------------------------------------------

  /// Devuelve el perfil del vendedor desde `/vendors/:id`.
  ///
  /// Retorna un `Map<String, dynamic>` que puedes usar con `Vendor.fromJson`.
  static Future<Map<String, dynamic>> getProfile(int vendorId) async {
    final http.Response response = await ApiService.get('vendors/$vendorId');

    if (response.statusCode == 200) {
      return ApiService.decode(response);
    } else {
      throw Exception(
          'Error al obtener perfil de vendedor: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Obtener productos del vendedor
  // -----------------------------------------------------------------------

  /// Retorna una lista de productos publicados por el vendedor.
  ///
  /// Endpoint: `/vendors/:id/products`
  static Future<List<dynamic>> getMyProducts(int vendorId) async {
    final response = await ApiService.get('vendors/$vendorId/products');

    if (response.statusCode == 200) {
      final body = ApiService.decode(response);
      return (body is Map && body['data'] is List)
          ? body['data']
          : (body as List<dynamic>);
    } else {
      throw Exception(
          'Error al obtener productos del vendedor: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Crear un nuevo producto
  // -----------------------------------------------------------------------

  /// Publica un nuevo producto asociado al vendedor.
  ///
  /// Endpoint: `POST /vendors/:id/products`
  /// El parámetro `data` debe incluir nombre, precio, stock, etc.
  static Future<void> createProduct(
      int vendorId, Map<String, dynamic> data) async {
    final response = await ApiService.post('vendors/$vendorId/products', data);

    if (response.statusCode != 201) {
      throw Exception('Error al crear producto: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Actualizar un producto existente
  // -----------------------------------------------------------------------

  /// Actualiza un producto publicado por el vendedor.
  ///
  /// Endpoint: `PUT /vendors/products/:productId`
  static Future<void> updateProduct(
      int productId, Map<String, dynamic> data) async {
    final response = await ApiService.put('vendors/products/$productId', data);

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Eliminar un producto publicado
  // -----------------------------------------------------------------------

  /// Elimina un producto del catálogo del vendedor.
  ///
  /// Endpoint: `DELETE /vendors/products/:productId`
  static Future<void> deleteProduct(int productId) async {
    final response = await ApiService.delete('vendors/products/$productId');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar producto: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Obtener estadísticas de ventas (opcional)
  // -----------------------------------------------------------------------

  /// Devuelve estadísticas generales del vendedor: total ventas, productos vendidos, etc.
  ///
  /// Endpoint sugerido: `/vendors/:id/stats`
  static Future<Map<String, dynamic>> getStats(int vendorId) async {
    final response = await ApiService.get('vendors/$vendorId/stats');

    if (response.statusCode == 200) {
      return ApiService.decode(response);
    } else {
      throw Exception('Error al obtener estadísticas: ${response.statusCode}');
    }
  }
}

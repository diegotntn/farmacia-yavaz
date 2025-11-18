import 'package:http/http.dart' as http;
import 'package:e_commerce_flutter/src/service/api_service.dart';

/// ------------------------------------------------------------
/// 🛍️ ProductService
///
/// Servicio que se encarga de interactuar con los endpoints de productos.
///
/// Este archivo abstrae todas las llamadas a la API relacionadas con:
///   - Obtener lista de productos
///   - Obtener producto por ID
///   - Crear nuevo producto
///   - Actualizar producto existente
///   - Eliminar producto
///
/// Endpoints esperados:
///   GET    /products
///   GET    /products/:id
///   POST   /products
///   PUT    /products/:id
///   DELETE /products/:id
/// ------------------------------------------------------------
class ProductService {
  // -----------------------------------------------------------------------
  // 🔹 Obtener lista completa de productos
  // -----------------------------------------------------------------------

  /// Devuelve una lista de productos desde el endpoint `/products`.
  ///
  /// Si tu backend usa paginación, puedes pasar el número de página.
  ///
  /// Retorna una `List<dynamic>` que deberás mapear con `Product.fromJson`.
  static Future<List<dynamic>> getAll({int page = 1}) async {
    final http.Response response = await ApiService.get(
      'products',
      query: {'page': '$page'},
    );

    if (response.statusCode == 200) {
      final body = ApiService.decode(response);
      // Si tu backend responde con {"data": [ ... ]}
      return (body is Map && body['data'] is List)
          ? body['data']
          : (body as List<dynamic>);
    } else {
      throw Exception('Error al obtener productos: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Obtener un solo producto por ID
  // -----------------------------------------------------------------------

  /// Devuelve los datos de un solo producto desde `/products/:id`.
  ///
  /// El resultado es un `Map<String, dynamic>` compatible con `Product.fromJson`.
  static Future<Map<String, dynamic>> getById(int id) async {
    final response = await ApiService.get('products/$id');

    if (response.statusCode == 200) {
      return ApiService.decode(response);
    } else {
      throw Exception('Producto no encontrado: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Crear un nuevo producto
  // -----------------------------------------------------------------------

  /// Envía un producto nuevo al backend usando `POST /products`.
  ///
  /// El parámetro `data` debe estar en formato JSON (mapa).
  ///
  /// El backend debe responder con 201 si se creó correctamente.
  static Future<void> create(Map<String, dynamic> data) async {
    final response = await ApiService.post('products', data);

    if (response.statusCode != 201) {
      throw Exception('Error al crear producto: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Actualizar un producto existente
  // -----------------------------------------------------------------------

  /// Actualiza un producto existente vía `PUT /products/:id`.
  ///
  /// `id` → identificador del producto a actualizar
  /// `data` → mapa con los campos a modificar
  static Future<void> update(int id, Map<String, dynamic> data) async {
    final response = await ApiService.put('products/$id', data);

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto: ${response.statusCode}');
    }
  }

  // -----------------------------------------------------------------------
  // 🔹 Eliminar un producto
  // -----------------------------------------------------------------------

  /// Elimina un producto del backend usando `DELETE /products/:id`.
  ///
  /// Retorna un error si la operación falla.
  static Future<void> delete(int id) async {
    final response = await ApiService.delete('products/$id');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar producto: ${response.statusCode}');
    }
  }
}

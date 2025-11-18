import 'package:e_commerce_flutter/core/app_data.dart';
import 'product_size_type.dart';

/// Enum que representa las categorías de productos disponibles.
///
/// ⚠️ Asegúrate de que estos valores coincidan con los enviados por el backend.
/// Puedes extenderlo con categorías reales de farmacia: medicamentos, vitaminas, cuidado personal, etc.
enum ProductType { all, watch, mobile, headphone, tablet, tv }

/// Modelo de producto utilizado en la farmacia (con compatibilidad REST API).
///
/// Incluye campos como nombre, precio, stock, presentación, imágenes y estado de favorito.
class Product {
  // -----------------------------------------------------------------------
  // 🔹 CAMPOS PRINCIPALES DEL PRODUCTO
  // -----------------------------------------------------------------------

  /// ID único del producto (clave primaria)
  final int id;

  /// SKU o código interno del producto
  final String? sku;

  /// Nombre descriptivo del producto (ej. "Paracetamol 500mg")
  String name;

  /// Precio normal (sin descuento)
  double price;

  /// Descuento aplicado (porcentaje, opcional)
  int? off;

  /// Descripción larga (uso, ingredientes, etc.)
  String about;

  /// Si el producto está activo en el catálogo
  bool isAvailable;

  /// Tamaños o presentaciones (ej. 10 tabletas, 250 ml, etc.)
  ProductSizeType? sizes;

  /// Cantidad que el usuario ha añadido al carrito (no es el stock real)
  int _quantity;

  /// Stock real en farmacia (control de inventario)
  int stock;

  /// Lista de URLs de imágenes del producto
  List<String> images;

  /// Si el usuario marcó como favorito este producto
  bool isFavorite;

  /// Calificación promedio del producto (de 0.0 a 5.0)
  double rating;

  /// Tipo o categoría del producto (ver enum)
  ProductType type;

  // -----------------------------------------------------------------------
  // 🔹 GETTER Y SETTER DE CANTIDAD EN CARRITO
  // -----------------------------------------------------------------------

  /// Obtiene la cantidad que el usuario ha añadido al carrito
  int get quantity => _quantity;

  /// Modifica la cantidad en el carrito (nunca menor a 0)
  set quantity(int newQuantity) {
    if (newQuantity >= 0) _quantity = newQuantity;
  }

  // -----------------------------------------------------------------------
  // 🔹 CONSTRUCTOR
  // -----------------------------------------------------------------------

  /// Constructor principal
  Product({
    required this.id,
    this.sku,
    required this.name,
    required this.price,
    this.off,
    this.about = AppData.dummyText,
    this.isAvailable = true,
    this.sizes,
    required int quantity,
    required this.stock,
    required this.images,
    this.isFavorite = false,
    this.rating = 0.0,
    required this.type,
  }) : _quantity = quantity;

  // -----------------------------------------------------------------------
  // 🔹 CONSTRUCTOR DESDE JSON (API → Modelo)
  // -----------------------------------------------------------------------

  /// Crea una instancia de [Product] desde un mapa JSON (ej. respuesta API)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _parseInt(json['id']),
      sku: json['sku'],
      name: json['name'] ?? '',
      price: _parseDouble(json['price']),
      off: _parseInt(json['off']),
      about: json['about'] ?? AppData.dummyText,
      isAvailable: json['isAvailable'] ?? true,
      sizes: json['sizes'] != null
          ? ProductSizeType.fromJson(json['sizes'])
          : null,
      quantity: _parseInt(json['quantity']),
      stock: _parseInt(json['stock']),
      images: List<String>.from(json['images'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
      rating: _parseDouble(json['rating']),
      type: ProductType.values.firstWhere(
        (e) => e.toString() == 'ProductType.${json['type']}',
        orElse: () => ProductType.all,
      ),
    );
  }

  // -----------------------------------------------------------------------
  // 🔹 MÉTODO PARA CONVERTIR A JSON (Modelo → API)
  // -----------------------------------------------------------------------

  /// Convierte el objeto en un mapa JSON (ej. para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (sku != null) 'sku': sku,
      'name': name,
      'price': price,
      'off': off,
      'about': about,
      'isAvailable': isAvailable,
      'sizes': sizes?.toJson(),
      'quantity': _quantity,
      'stock': stock,
      'images': images,
      'isFavorite': isFavorite,
      'rating': rating,
      'type': type.toString().split('.').last,
    };
  }

  // -----------------------------------------------------------------------
  // 🔹 FUNCIONES AUXILIARES DE PARSEO
  // -----------------------------------------------------------------------

  /// Parsea cualquier valor dinámico a entero seguro
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Parsea cualquier valor dinámico a double seguro
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

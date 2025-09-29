import 'package:e_commerce_flutter/core/app_data.dart';
import 'package:e_commerce_flutter/src/model/product_size_type.dart';

/// Enum que representa los diferentes tipos de productos
enum ProductType { all, watch, mobile, headphone, tablet, tv }

/// Clase que representa un producto en la app
class Product {
  /// Identificador único del producto (SKU, promedio 13 dígitos)
  final String sku;

  /// Nombre del producto
  String name;

  /// Precio del producto
  int price;

  /// Descuento aplicado al producto (opcional)
  int? off;

  /// Descripción del producto
  String about;

  /// Indica si el producto está disponible para la venta
  bool isAvailable;

  /// Tamaños o variantes del producto (opcional)
  ProductSizeType? sizes;

  /// Cantidad interna del producto, manejada con getter/setter
  int _quantity;

  /// Lista de URLs de imágenes del producto
  List<String> images;

  /// Indica si el producto está marcado como favorito
  bool isFavorite;

  /// Calificación del producto (rating)
  double rating;

  /// Tipo del producto, según enum ProductType
  ProductType type;

  /// Getter para la cantidad del producto
  int get quantity => _quantity;

  /// Setter para la cantidad, asegura que nunca sea negativa
  set quantity(int newQuantity) {
    if (newQuantity >= 0) _quantity = newQuantity;
  }

  /// Constructor principal de la clase Product
  Product({
    required this.sku,
    this.sizes,
    this.about = AppData.dummyText, // Valor por defecto
    required this.name,
    required this.price,
    this.isAvailable = true, // Valor por defecto
    this.off,
    required int quantity,
    required this.images,
    this.isFavorite = false, // Valor por defecto
    this.rating = 0.0, // Valor por defecto
    required this.type,
  }) : _quantity = quantity;

  // ----------------- Serialización -----------------

  /// Crea una instancia de Product desde un Map (JSON)
  /// Permite reconstruir productos desde backend o almacenamiento local
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      sku: json['sku'] ?? '', // Valor por defecto si no existe
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      off: json['off'],
      about: json['about'] ?? AppData.dummyText,
      isAvailable: json['isAvailable'] ?? true,
      sizes: json['sizes'] != null
          ? ProductSizeType.fromJson(json['sizes'])
          : null, // Deserializa tamaños si existen
      quantity: json['quantity'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      type: ProductType.values.firstWhere(
        (e) => e.toString() == 'ProductType.${json['type']}',
        orElse: () => ProductType.all, // Tipo por defecto si no coincide
      ),
    );
  }

  /// Convierte la instancia de Product a un Map (JSON)
  /// Permite almacenar o enviar el producto a backend
  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'name': name,
      'price': price,
      'off': off,
      'about': about,
      'isAvailable': isAvailable,
      'sizes': sizes?.toJson(), // Serializa tamaños si existen
      'quantity': _quantity,
      'images': images,
      'isFavorite': isFavorite,
      'rating': rating,
      'type': type.toString().split('.').last, // Guarda solo el nombre del enum
    };
  }
}

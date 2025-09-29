import 'package:flutter/material.dart';
import '../model/vendor.dart';
import '../model/product.dart';

/// Controlador que maneja la lógica de un vendedor dentro de la app
/// Incluye: productos, ventas y el vendedor actual.
/// Hereda de ChangeNotifier para notificar cambios a la UI.
class VendorController extends ChangeNotifier {
  /// Vendedor actualmente logueado
  Vendor? _currentVendor;

  /// Getter para obtener el vendedor actual
  Vendor? get currentVendor => _currentVendor;

  /// Establece el vendedor actual y notifica a la UI
  void setVendor(Vendor vendor) {
    _currentVendor = vendor;
    notifyListeners();
  }

  // ------------------ Productos ------------------

  /// Lista interna que representa los productos del vendedor
  final List<Product> _products = [];

  /// Getter que devuelve una copia no modificable de los productos
  List<Product> get products => List.unmodifiable(_products);

  /// Agrega un producto a la lista del vendedor y notifica cambios
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  /// Actualiza un producto existente por SKU
  /// - Busca el producto por sku y lo reemplaza
  void updateProduct(Product updatedProduct) {
    int index = _products.indexWhere((p) => p.sku == updatedProduct.sku);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  /// Elimina un producto por su SKU
  void removeProduct(String productSku) {
    _products.removeWhere((p) => p.sku == productSku);
    notifyListeners();
  }

  // ------------------ Ventas ------------------

  /// Lista de ventas realizadas, cada venta es una lista de productos
  final List<List<Product>> _salesHistory = [];

  /// Getter que devuelve una copia no modificable del historial de ventas
  List<List<Product>> get salesHistory => List.unmodifiable(_salesHistory);

  /// Registra una venta agregando los productos vendidos al historial
  void recordSale(List<Product> soldProducts) {
    if (soldProducts.isEmpty) return; // No registra ventas vacías

    _salesHistory
        .add(List<Product>.from(soldProducts)); // Copia de los productos
    notifyListeners();
  }

  /// Calcula el total de ventas sumando el precio de todos los productos vendidos
  double get totalSales {
    double total = 0.0;
    for (var sale in _salesHistory) {
      total += sale.fold(0.0, (sum, item) => sum + item.price);
    }
    return total;
  }

  /// Obtiene las ventas recientes
  /// [count]: cantidad de ventas a retornar (por defecto 5)
  List<List<Product>> getRecentSales({int count = 5}) {
    // Devuelve los últimos 'count' ventas del historial
    return _salesHistory.reversed.take(count).toList();
  }
}

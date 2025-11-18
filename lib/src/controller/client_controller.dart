import 'package:flutter/material.dart';
import '../model/product.dart';
import '../model/client.dart';

/// ---------------------------------------------------------------------------
/// 🧑‍💼 ClientController
///
/// Controlador que gestiona los datos y acciones del cliente en sesión.
/// Utiliza `ChangeNotifier` para notificar cambios a la UI de forma reactiva.
///
/// Funcionalidades principales:
/// - Autenticación de cliente
/// - Carrito de compras (agregar, quitar, limpiar)
/// - Historial de pedidos (registro, consulta)
/// - Limpieza de datos al cerrar sesión
/// ---------------------------------------------------------------------------
class ClientController extends ChangeNotifier {
  // ===========================================================================
  // 🔐 CLIENTE ACTUAL (Autenticado)
  // ===========================================================================

  /// Cliente autenticado en sesión
  Client? _client;

  /// Getter para acceder al cliente actual
  Client? get client => _client;

  /// Asigna el cliente al iniciar sesión
  void setClient(Client client) {
    _client = client;
    notifyListeners(); // Notifica a la UI que el cliente ha cambiado
  }

  // ===========================================================================
  // 🛒 CARRITO DE COMPRAS
  // ===========================================================================

  /// Lista privada de productos agregados al carrito
  final List<Product> _cart = [];

  /// Devuelve una lista no modificable del carrito actual
  List<Product> get cart => List.unmodifiable(_cart);

  /// Calcula el total del carrito (sumando precio * cantidad por producto)
  double get cartTotal => _cart.fold(
        0.0,
        (total, item) =>
            total + (item.quantity * (item.off?.toDouble() ?? item.price)),
      );

  /// Verifica si un producto ya está en el carrito
  bool isInCart(Product product) => _cart.contains(product);

  /// Agrega un producto al carrito (solo si no supera el stock)
  void addToCart(Product product) {
    if (product.quantity < product.stock) {
      product.quantity++;
      if (!_cart.contains(product)) {
        _cart.add(product);
      }
      notifyListeners();
    } else {
      debugPrint("❌ Stock insuficiente para agregar más de: ${product.name}");
    }
  }

  /// Disminuye la cantidad de un producto o lo elimina si llega a 0
  void decreaseFromCart(Product product) {
    if (product.quantity > 0) {
      product.quantity--;
      if (product.quantity == 0) {
        _cart.remove(product);
      }
      notifyListeners();
    }
  }

  /// Elimina completamente un producto del carrito
  void removeFromCart(Product product) {
    _cart.remove(product);
    product.quantity = 0;
    notifyListeners();
  }

  /// Vacía completamente el carrito
  void clearCart() {
    for (var item in _cart) {
      item.quantity = 0; // Reinicia cantidades
    }
    _cart.clear();
    notifyListeners();
  }

  /// Verifica si el carrito está vacío
  bool get isCartEmpty => _cart.isEmpty;

  // ===========================================================================
  // 📦 HISTORIAL DE PEDIDOS
  // ===========================================================================

  /// Lista de pedidos pasados (cada uno es una lista de productos)
  final List<List<Product>> _orderHistory = [];

  /// Devuelve una lista no modificable del historial de pedidos
  List<List<Product>> get orderHistory => List.unmodifiable(_orderHistory);

  /// Registra un nuevo pedido (si el carrito no está vacío)
  void placeOrder() {
    if (_cart.isEmpty) return;

    // Copia los productos actuales como un nuevo pedido
    _orderHistory.add(
      _cart.map((p) => Product.fromJson(p.toJson())).toList(),
    );

    clearCart(); // Limpia el carrito tras realizar pedido
    notifyListeners(); // Notifica a la UI del cambio en historial
  }

  /// Devuelve los últimos [count] pedidos (por defecto 5)
  List<List<Product>> getRecentOrders({int count = 5}) {
    return _orderHistory.reversed.take(count).toList();
  }

  /// Verifica si el cliente ya ha realizado pedidos
  bool get hasOrders => _orderHistory.isNotEmpty;

  // ===========================================================================
  // 🔄 RESET GENERAL (logout o reinicio de sesión)
  // ===========================================================================

  /// Limpia cliente, carrito y pedidos (ej. al cerrar sesión)
  void clearAll() {
    _client = null;
    _cart.clear();
    _orderHistory.clear();
    notifyListeners();
  }
}

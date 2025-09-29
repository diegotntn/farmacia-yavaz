import 'package:flutter/material.dart';
import '../model/product.dart';
import '../model/client.dart';

/// Controlador que maneja la lógica de un cliente dentro de la app
/// Incluye: carrito de compras, historial de pedidos y el cliente actual.
/// Hereda de ChangeNotifier para notificar cambios a la UI.
class ClientController extends ChangeNotifier {
  /// Cliente actualmente logueado
  Client? _currentClient;

  /// Getter para obtener el cliente actual
  Client? get currentClient => _currentClient;

  // ------------------ Carrito de compras ------------------

  /// Lista interna que representa los productos agregados al carrito
  final List<Product> _cart = [];

  /// Getter que devuelve una copia no modificable del carrito
  List<Product> get cart => List.unmodifiable(_cart);

  /// Calcula el total del carrito sumando el precio de cada producto
  double get cartTotal => _cart.fold(0.0, (sum, item) => sum + item.price);

  // ------------------ Historial de pedidos ------------------

  /// Lista de pedidos realizados, cada pedido es una lista de productos
  final List<List<Product>> _orderHistory = [];

  /// Getter que devuelve una copia no modificable del historial de pedidos
  List<List<Product>> get orderHistory => List.unmodifiable(_orderHistory);

  // ------------------ Cliente actual ------------------

  /// Establece el cliente actual y notifica a la UI
  void setClient(Client client) {
    _currentClient = client;
    notifyListeners();
  }

  // ------------------ Métodos del carrito ------------------

  /// Agrega un producto al carrito y notifica cambios
  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  /// Elimina un producto del carrito y notifica cambios
  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  /// Vacía todo el carrito y notifica cambios
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // ------------------ Métodos de pedidos ------------------

  /// Realiza un pedido con los productos del carrito
  /// - Agrega el carrito al historial de pedidos
  /// - Limpia el carrito
  void placeOrder() {
    if (_cart.isEmpty) return; // No se permite pedido vacío

    _orderHistory.add(List<Product>.from(_cart)); // Copia del carrito
    clearCart(); // Vacía el carrito

    notifyListeners(); // Notifica cambios a la UI
  }

  // ------------------ Funciones adicionales ------------------

  /// Obtiene los pedidos recientes
  /// [count]: cantidad de pedidos a retornar (por defecto 5)
  List<List<Product>> getRecentOrders({int count = 5}) {
    // Devuelve los últimos 'count' pedidos del historial
    return _orderHistory.reversed.take(count).toList();
  }
}

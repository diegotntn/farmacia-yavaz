import 'package:flutter/material.dart';
import '../model/client.dart';
import '../model/vendor.dart';
import '../model/user.dart';
import 'client_controller.dart';
import 'vendor_controller.dart';

/// Controlador de autenticación
/// Maneja login, registro y logout de clientes y vendedores
/// Hereda de ChangeNotifier para notificar cambios a la UI
class AuthController extends ChangeNotifier {
  /// Usuario actualmente logueado (puede ser Client o Vendor)
  User? _currentUser;

  /// Referencias opcionales a controladores de cliente y vendedor
  /// Para actualizar carrito, productos, historial, etc.
  final ClientController? clientController;
  final VendorController? vendorController;

  /// Constructor opcional, permite inyección de dependencias
  AuthController({this.clientController, this.vendorController});

  /// Getter del usuario actual
  User? get currentUser => _currentUser;

  /// Indica si hay un usuario logueado
  bool get isLoggedIn => _currentUser != null;

  // ----------------- LOGIN -----------------

  /// Método para iniciar sesión
  /// [email] y [password]: credenciales
  /// [isVendor]: true si es vendedor, false si es cliente
  Future<bool> login({
    required String email,
    required String password,
    required bool isVendor,
  }) async {
    // Simula una llamada a backend
    await Future.delayed(const Duration(seconds: 1));

    // Dependiendo del rol, se crea un usuario demo
    if (isVendor) {
      _currentUser = Vendor(
        email: email,
        password: password,
        storeName: 'Tienda Demo',
        storeAddress: 'Dirección Demo',
      );
      // Si existe VendorController, podríamos inicializar productos
      vendorController?.setVendor(_currentUser as Vendor);
    } else {
      _currentUser = Client(
        email: email,
        password: password,
        phoneNumber: '1234567890',
        address: 'Dirección Demo',
      );
      // Si existe ClientController, podríamos inicializar carrito o historial
      clientController?.setClient(_currentUser as Client);
    }

    // Notifica a la UI que hubo un cambio
    notifyListeners();
    return true; // login exitoso
  }

  // ----------------- REGISTRO -----------------

  /// Registro de un cliente
  Future<bool> registerClient({
    required String email,
    required String password,
    String? nombreCompleto,
    DateTime? fechaNacimiento,
    String? phoneNumber,
    String? address,
  }) async {
    // Simula request al backend
    await Future.delayed(const Duration(seconds: 1));

    // Crea cliente y lo asigna como usuario actual
    _currentUser = Client(
      email: email,
      password: password,
      nombreCompleto: nombreCompleto,
      fechaNacimiento: fechaNacimiento,
      phoneNumber: phoneNumber,
      address: address,
    );

    // Actualiza ClientController si existe
    clientController?.setClient(_currentUser as Client);

    notifyListeners();
    return true;
  }

  /// Registro de un vendedor
  Future<bool> registerVendor({
    required String email,
    required String password,
    String? nombreCompleto,
    DateTime? fechaNacimiento,
    String? storeName,
    String? storeAddress,
  }) async {
    // Simula request al backend
    await Future.delayed(const Duration(seconds: 1));

    // Crea vendedor y lo asigna como usuario actual
    _currentUser = Vendor(
      email: email,
      password: password,
      nombreCompleto: nombreCompleto,
      fechaNacimiento: fechaNacimiento,
      storeName: storeName,
      storeAddress: storeAddress,
    );

    // Actualiza VendorController si existe
    vendorController?.setVendor(_currentUser as Vendor);

    notifyListeners();
    return true;
  }

  // ----------------- LOGOUT -----------------

  /// Cierra sesión y limpia el usuario actual
  void logout() {
    _currentUser = null;

    // Limpiar datos de controladores opcionales
    clientController?.clearCart();
    vendorController?.products.clear();

    notifyListeners();
  }
}

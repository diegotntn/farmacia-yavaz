import 'package:flutter/material.dart';
import '../model/user.dart';
import '../model/client.dart';
import '../model/vendor.dart';
import 'client_controller.dart';
import 'vendor_controller.dart';

/// -------------------------------------------------------------------------
/// 🔐 AuthController
///
/// Controlador principal para la autenticación de usuarios en la app:
///   - Login simulado para Cliente o Vendedor
///   - Registro simulado
///   - Logout y limpieza de estado
///
/// Usa [ChangeNotifier] para actualizar la UI cuando cambie el usuario.
/// Puede recibir controladores de cliente y vendedor como dependencias.
/// -------------------------------------------------------------------------
class AuthController extends ChangeNotifier {
  // -----------------------------------------------------------------------
  // 🔹 Usuario actualmente autenticado
  // -----------------------------------------------------------------------
  User? _currentUser;

  // -----------------------------------------------------------------------
  // 🔹 Controladores opcionales para cliente y vendedor
  // -----------------------------------------------------------------------
  final ClientController? clientController;
  final VendorController? vendorController;

  // -----------------------------------------------------------------------
  // 🔹 Constructor (permite inyección de dependencias)
  // -----------------------------------------------------------------------
  AuthController({
    this.clientController,
    this.vendorController,
  });

  // -----------------------------------------------------------------------
  // 🔹 Getters públicos
  // -----------------------------------------------------------------------

  /// Devuelve el usuario actual (cliente o vendedor)
  User? get currentUser => _currentUser;

  /// Verifica si hay sesión activa
  bool get isLoggedIn => _currentUser != null;

  // -----------------------------------------------------------------------
  // 🔸 LOGIN SIMULADO
  // -----------------------------------------------------------------------

  /// Simula el inicio de sesión para cliente o vendedor
  Future<bool> login({
    required String email,
    required String password,
    required bool isVendor,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (isVendor) {
      // Crear vendedor simulado
      _currentUser = Vendor(
        id: 1,
        email: email,
        password: password,
        name: 'Vendedor Demo',
        storeName: 'Farmacia Modelo',
        storeAddress: 'Calle Principal 101',
      );
      vendorController?.setVendor(_currentUser as Vendor);
    } else {
      // Crear cliente simulado
      _currentUser = Client(
        id: 1,
        email: email,
        password: password,
        name: 'Cliente Demo',
        phoneNumber: '5559876543',
        address: 'Colonia Centro',
      );
      clientController?.setClient(_currentUser as Client);
    }

    notifyListeners();
    return true;
  }

  // -----------------------------------------------------------------------
  // 🔸 REGISTRO SIMULADO (CLIENTE)
  // -----------------------------------------------------------------------

  /// Registra un nuevo cliente
  Future<bool> registerClient({
    required String email,
    required String password,
    String? name,
    DateTime? fechaNacimiento,
    String? phoneNumber,
    String? address,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = Client(
      id: 2,
      email: email,
      password: password,
      name: name ?? 'Nuevo Cliente',
      fechaNacimiento: fechaNacimiento,
      phoneNumber: phoneNumber,
      address: address,
    );

    clientController?.setClient(_currentUser as Client);
    notifyListeners();
    return true;
  }

  // -----------------------------------------------------------------------
  // 🔸 REGISTRO SIMULADO (VENDEDOR)
  // -----------------------------------------------------------------------

  /// Registra un nuevo vendedor
  Future<bool> registerVendor({
    required String email,
    required String password,
    String? name,
    DateTime? fechaNacimiento,
    String? storeName,
    String? storeAddress,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = Vendor(
      id: 3,
      email: email,
      password: password,
      name: name ?? 'Nuevo Vendedor',
      fechaNacimiento: fechaNacimiento,
      storeName: storeName,
      storeAddress: storeAddress,
    );

    vendorController?.setVendor(_currentUser as Vendor);
    notifyListeners();
    return true;
  }

  // -----------------------------------------------------------------------
  // 🔸 LOGOUT
  // -----------------------------------------------------------------------

  /// Cierra sesión y reinicia los controladores relacionados
  void logout() {
    _currentUser = null;

    // Limpieza de datos
    clientController?.clearCart();
    vendorController?.products.clear();

    notifyListeners();
  }
}

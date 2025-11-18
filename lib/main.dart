// 📄 lib/main.dart

import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:provider/provider.dart';

// ==== CORE ====
import 'package:e_commerce_flutter/core/app_theme.dart';
import 'package:e_commerce_flutter/core/session_manager.dart';

// ==== SCREENS ====
import 'package:e_commerce_flutter/src/view/screen/login_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/home_screen.dart';

// ==== CONTROLLERS ====
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:e_commerce_flutter/src/controller/client_controller.dart';
import 'package:e_commerce_flutter/src/controller/vendor_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Recupera token de sesión (si existe)
  final token = await SessionManager.getToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClientController()),
        ChangeNotifierProvider(create: (_) => VendorController()),
        ChangeNotifierProxyProvider2<ClientController, VendorController,
            AuthController>(
          create: (_) => AuthController(
            clientController: ClientController(),
            vendorController: VendorController(),
          ),
          update: (_, client, vendor, __) => AuthController(
            clientController: client,
            vendorController: vendor,
          ),
        ),
      ],
      child: MyApp(initialToken: token),
    ),
  );
}

/// Widget raíz de la aplicación
class MyApp extends StatelessWidget {
  final String? initialToken;
  const MyApp({super.key, required this.initialToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Estilo visual YaVaz
      theme: AppTheme.lightAppTheme,

      // Soporte para touch y mouse (scroll adaptable)
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),

      // Rutas disponibles
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
      },

      // Ruta inicial según sesión
      initialRoute: initialToken == null ? '/login' : '/home',
    );
  }
}

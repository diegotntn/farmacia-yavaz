// 📄 lib/main.dart

import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:provider/provider.dart';

// ==== CORE ====
import 'package:e_commerce_flutter/core/app_theme.dart';
import 'package:e_commerce_flutter/core/session_manager.dart';

// ==== SCREENS ====
import 'package:e_commerce_flutter/src/view/screen/splash_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/login_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/home_screen.dart';

// ==== CONTROLLERS ====
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:e_commerce_flutter/src/controller/client_controller.dart';
import 'package:e_commerce_flutter/src/controller/vendor_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar almacenamiento y sesión
  await SessionManager.getToken(); // asegura acceso antes de construir el árbol

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClientController()),
        ChangeNotifierProvider(create: (_) => VendorController()),

        // AuthController depende de Client y Vendor
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
      child: const MyApp(),
    ),
  );
}

/// ===========================================================================
/// 🌟 Widget raíz de la aplicación
/// ===========================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🎨 Tema visual YaVaz
      theme: AppTheme.lightAppTheme,

      // Permitir scroll táctil + mouse
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),

      // 🌎 Navegación centralizada
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
      },

      // 🚀 SplashScreen al iniciar SIEMPRE
      home: const SplashScreen(),
    );
  }
}

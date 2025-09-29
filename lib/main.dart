import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:provider/provider.dart';

import 'package:e_commerce_flutter/core/app_theme.dart';
import 'package:e_commerce_flutter/src/view/screen/login_screen.dart';
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:e_commerce_flutter/src/controller/client_controller.dart';
import 'package:e_commerce_flutter/src/controller/vendor_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Controlador de cliente
        ChangeNotifierProvider(create: (_) => ClientController()),

        // Controlador de vendedor
        ChangeNotifierProvider(create: (_) => VendorController()),

        // Controlador de autenticación
        ChangeNotifierProxyProvider2<ClientController, VendorController,
            AuthController>(
          create: (_) => AuthController(
            clientController: ClientController(),
            vendorController: VendorController(),
          ),
          update: (_, client, vendor, auth) => AuthController(
            clientController: client,
            vendorController: vendor,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightAppTheme,

      /// Inicialmente mostramos LoginScreen
      /// Después del login se redirige a HomeScreen
      home: const LoginScreen(),
    );
  }
}

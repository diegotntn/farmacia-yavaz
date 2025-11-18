// 📄 lib/core/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._(); // Constructor privado para evitar instancias

  // Tema claro de la aplicación (YaVaz Style)
  static ThemeData lightAppTheme = ThemeData(
    useMaterial3: true,

    // ======= COLORES PRINCIPALES =======
    scaffoldBackgroundColor: const Color(0xFFFDF5F8), // fondo rosado claro
    primaryColor: const Color(0xFFD9004C), // rosa YaVaz
    splashColor: Colors.pinkAccent.withOpacity(0.1),
    iconTheme: const IconThemeData(color: Color(0xFFA6A3A0)),

    // ======= TEXTO =======
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        // títulos grandes
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        // subtítulos
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        // descripciones destacadas
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        // texto general
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(
        // texto secundario
        fontSize: 15,
        color: Colors.grey,
      ),
      titleLarge: TextStyle(
        // detalles mínimos
        fontSize: 12,
      ),
    ),

    // ======= BOTONES ELEVADOS =======
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD9004C), // rosa YaVaz
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // ======= BOTONES DE TEXTO =======
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF3E1C56), // violeta profundo
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),

    // ======= APPBAR =======
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF3E1C56)), // íconos violetas
      titleTextStyle: TextStyle(
        color: Color(0xFF3E1C56),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ======= BOTTOM NAV BAR =======
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFD9004C), // activo rosa
      unselectedItemColor: Colors.grey, // inactivo gris
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),

    // ======= CAMPOS DE TEXTO =======
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD9004C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF3E1C56), width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.black54),
    ),
  );
}

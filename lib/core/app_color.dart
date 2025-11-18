import 'package:flutter/material.dart' show Color;

class AppColor {
  const AppColor._(); // Constructor privado para evitar instanciación

  // Tonos naranjas principales usados en la interfaz
  static const darkOrange = Color(0xFFEC6813);
  static const lightOrange = Color(0xFFf8b89a);

  // Tonos de grises para fondos o textos secundarios
  static const darkGrey = Color(0xFFA6A3A0);
  static const lightGrey = Color(0xFFE5E6E8);

  // 🔶 Color naranja general (puedes usarlo como color base)
  static const orange = Color(0xFFFF9800);

  // 🎨 Colores variados para usar dinámicamente (por ejemplo en chips, categorías, etc.)
  static const List<Color> randomColors = [
    Color(0xFFFA663C), // rojo anaranjado
    Color(0xFFFFB74D), // naranja claro
    Color(0xFF81C784), // verde menta
    Color(0xFF64B5F6), // azul claro
    Color(0xFFBA68C8), // morado suave
    Color(0xFFFF8A65), // salmón
    Color(0xFF4DD0E1), // cian pastel
  ];
}

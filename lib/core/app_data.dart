import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/model/numerical.dart';
import 'package:e_commerce_flutter/src/model/categorical.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:e_commerce_flutter/src/model/product_category.dart';
import 'package:e_commerce_flutter/src/model/product_size_type.dart';
import 'package:e_commerce_flutter/src/model/recommended_product.dart';
import 'package:e_commerce_flutter/src/model/bottom_nav_bar_item.dart';

/// Configuración global de la app y datos simulados
class AppData {
  const AppData._();

  /// URL base de la API REST
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.tufarmacia.com/api',
  );

  /// Texto de ejemplo
  static const String dummyText =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
      'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.';

  /// --------------------------------------------
  /// 🛒 PRODUCTOS (no se modifican)
  /// --------------------------------------------
  static List<Product> products = [
    Product(
      id: 1,
      sku: '0000000000001',
      name: 'Samsung Galaxy A53 5G',
      price: 460,
      stock: 15,
      isAvailable: true,
      off: 300,
      quantity: 0,
      images: [
        'assets/images/a53_1.png',
        'assets/images/a53_2.png',
        'assets/images/a53_3.png',
      ],
      isFavorite: true,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      id: 2,
      sku: '0000000000002',
      name: 'Samsung Galaxy Tab S7 FE',
      price: 380,
      stock: 10,
      isAvailable: false,
      off: 220,
      quantity: 0,
      images: [
        'assets/images/tab_s7_fe_1.png',
        'assets/images/tab_s7_fe_2.png',
        'assets/images/tab_s7_fe_3.png',
      ],
      isFavorite: false,
      rating: 4,
      type: ProductType.tablet,
    ),
    Product(
      id: 3,
      sku: '0000000000003',
      name: 'Samsung Galaxy Tab S8+',
      price: 650,
      stock: 20,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/tab_s8_1.png',
        'assets/images/tab_s8_2.png',
        'assets/images/tab_s8_3.png',
      ],
      isFavorite: false,
      rating: 3,
      type: ProductType.tablet,
    ),
    Product(
      id: 4,
      sku: '0000000000004',
      name: 'Samsung Galaxy Watch 4',
      price: 229,
      stock: 25,
      isAvailable: true,
      off: 200,
      quantity: 0,
      images: [
        'assets/images/galaxy_watch_4_1.png',
        'assets/images/galaxy_watch_4_2.png',
        'assets/images/galaxy_watch_4_3.png',
      ],
      isFavorite: false,
      rating: 5,
      sizes: ProductSizeType(
        categorical: [
          Categorical(CategoricalType.small, true),
          Categorical(CategoricalType.medium, false),
          Categorical(CategoricalType.large, false),
        ],
      ),
      type: ProductType.watch,
    ),
    Product(
      id: 5,
      sku: '0000000000005',
      name: 'Apple Watch 7',
      price: 330,
      stock: 30,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/apple_watch_series_7_1.png',
        'assets/images/apple_watch_series_7_2.png',
        'assets/images/apple_watch_series_7_3.png',
      ],
      isFavorite: false,
      rating: 4,
      sizes: ProductSizeType(
        numerical: [
          Numerical('41', true),
          Numerical('45', false),
        ],
      ),
      type: ProductType.watch,
    ),
    Product(
      id: 6,
      sku: '0000000000006',
      name: 'Beats Studio 3',
      price: 230,
      stock: 18,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/beats_studio_3-1.png',
        'assets/images/beats_studio_3-2.png',
        'assets/images/beats_studio_3-3.png',
        'assets/images/beats_studio_3-4.png',
      ],
      isFavorite: false,
      rating: 2,
      type: ProductType.headphone,
    ),
    Product(
      id: 7,
      sku: '0000000000007',
      name: 'Samsung Q60 A',
      price: 497,
      stock: 12,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/samsung_q_60_a_1.png',
        'assets/images/samsung_q_60_a_2.png',
      ],
      isFavorite: false,
      rating: 3,
      sizes: ProductSizeType(
        numerical: [
          Numerical('43', true),
          Numerical('50', false),
          Numerical('55', false),
        ],
      ),
      type: ProductType.tv,
    ),
    Product(
      id: 8,
      sku: '0000000000008',
      name: 'Sony X80J',
      price: 498,
      stock: 10,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/sony_x_80_j_1.png',
        'assets/images/sony_x_80_j_2.png',
      ],
      isFavorite: false,
      sizes: ProductSizeType(
        numerical: [
          Numerical('50', true),
          Numerical('65', false),
          Numerical('85', false),
        ],
      ),
      rating: 2,
      type: ProductType.tv,
    ),
  ];

  /// --------------------------------------------
  /// 🏷️ CATEGORÍAS
  /// --------------------------------------------
  static List<ProductCategory> categories = [
    ProductCategory(type: ProductType.all, icon: Icons.all_inclusive),
    ProductCategory(
        type: ProductType.mobile, icon: FontAwesomeIcons.mobileScreenButton),
    ProductCategory(type: ProductType.watch, icon: Icons.watch),
    ProductCategory(type: ProductType.tablet, icon: FontAwesomeIcons.tablet),
    ProductCategory(type: ProductType.headphone, icon: Icons.headphones),
    ProductCategory(type: ProductType.tv, icon: Icons.tv),
  ];

  /// --------------------------------------------
  /// PALETA DE COLORES
  /// --------------------------------------------
  static List<Color> randomColors = [
    const Color(0xFFFCE4EC),
    const Color(0xFFF3E5F5),
    const Color(0xFFEDE7F6),
    const Color(0xFFE3F2FD),
    const Color(0xFFE0F2F1),
    const Color(0xFFF1F8E9),
    const Color(0xFFFFF8E1),
    const Color(0xFFECEFF1),
  ];

  static const Color lightOrangeColor = Color(0xFFEC6813);

  /// --------------------------------------------
  /// BOTTOM NAV BAR
  /// --------------------------------------------
  static List<BottomNavBarItem> bottomNavBarItems = [
    const BottomNavBarItem("Home", Icon(Icons.home)),
    const BottomNavBarItem("Favorite", Icon(Icons.favorite)),
    const BottomNavBarItem("Cart", Icon(Icons.shopping_cart)),
    const BottomNavBarItem("Profile", Icon(Icons.person)),
  ];

  /// --------------------------------------------
  /// ⭐ PROMOCIONES (SOLO 2 BANNERS — tus imágenes)
  /// --------------------------------------------
  static List<RecommendedProduct> recommendedProducts = [
    RecommendedProduct(
      cardBackgroundColor: Color(0xFFE30613), // 🔴 Rojo YaVaz
      imagePath: 'assets/images/promocion1.png',
      buttonBackgroundColor: Colors.white,
      buttonTextColor: Colors.red,
    ),
    RecommendedProduct(
      cardBackgroundColor: Color(0xFF004A98), // 🔵 Azul YaVaz
      imagePath: 'assets/images/promocion2.png',
      buttonBackgroundColor: Colors.white,
      buttonTextColor: Colors.blue,
    ),
  ];
}

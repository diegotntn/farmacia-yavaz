import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_flutter/core/app_color.dart';
import 'package:e_commerce_flutter/core/app_data.dart';

import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/view/widget/list_item_selector.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid_view.dart';

/// Tipos de botones del AppBar
enum AppbarActionType { leading, trailing }

/// Controlador global GetX (productos)
final ProductController controller = Get.put(ProductController());

/// =====================================================================
///                           PROMO CAROUSEL
/// =====================================================================
class _PromoCarousel extends StatefulWidget {
  const _PromoCarousel({super.key});

  @override
  State<_PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<_PromoCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  final List<String> banners = [
    "assets/images/promocion1.png",
    "assets/images/promocion2.png",
  ];

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!mounted) return;
      _currentPage = (_currentPage + 1) % banners.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                banners[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// =====================================================================
///                           PRODUCT LIST SCREEN
/// =====================================================================
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  /// Botones del AppBar
  Widget _appBarBtn(AppbarActionType type) {
    IconData icon =
        type == AppbarActionType.trailing ? Icons.search : Icons.menu;

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColor.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        padding: const EdgeInsets.all(8),
        onPressed: () {},
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }

  /// AppBar superior
  PreferredSize get _appBar {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _appBarBtn(AppbarActionType.leading),
              _appBarBtn(AppbarActionType.trailing),
            ],
          ),
        ),
      ),
    );
  }

  /// Header de categorías
  Widget _categoryHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Categorías", style: Theme.of(context).textTheme.headlineMedium),
        TextButton(
          onPressed: () {},
          child: Text(
            "VER TODO",
            style: TextStyle(color: Colors.deepOrange.withOpacity(0.7)),
          ),
        )
      ],
    );
  }

  /// Lista horizontal de categorías
  Widget _categoryList() {
    return ListItemSelector(
      categories: controller.categories,
      onItemPressed: (index) => controller.filterItemsByCategory(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.loadAllProducts();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con logo y texto
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo2.png',
                    height: 30,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bienvenido a YaVaz",
                          style: Theme.of(context).textTheme.displaySmall),
                      Text("Explora nuestros productos",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // CARRUSEL PROMOCIONAL
              const _PromoCarousel(),

              const SizedBox(height: 20),

              // CATEGORÍAS
              _categoryHeader(context),
              _categoryList(),

              const SizedBox(height: 20),

              // LISTA DE PRODUCTOS
              GetBuilder<ProductController>(
                builder: (controller) {
                  return ProductGridView(
                    items: controller.filteredProducts,
                    likeButtonPressed: (index) =>
                        controller.toggleFavorite(index),
                    isPriceOff: (product) => controller.isPriceOff(product),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

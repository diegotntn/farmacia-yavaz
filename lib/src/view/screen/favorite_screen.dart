import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ProductController controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();

    // 📌 Evita el error de actualización durante la animación.
    Future.microtask(() {
      controller.showFavoriteItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color rojo = const Color(0xFFE53935);
    final Color azul = const Color(0xFF1E88E5);
    final Color blanco = Colors.white;

    return Scaffold(
      backgroundColor: blanco,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: rojo,
        centerTitle: true,
        title: Text(
          "Mis Favoritos",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: blanco,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GetBuilder<ProductController>(
          builder: (controller) {
            final favorites =
                controller.filteredProducts.where((p) => p.isFavorite).toList();

            // -----------------------------------------------------------------
            // Estado vacío — cuando no hay productos favoritos
            // -----------------------------------------------------------------
            if (favorites.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: azul.withOpacity(0.7),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Todavía no tienes productos favoritos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Presiona el ícono ❤️ en un producto para agregarlo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              );
            }

            // -----------------------------------------------------------------
            // Render de los productos favoritos
            // -----------------------------------------------------------------
            return ProductGridView(
              items: favorites,
              likeButtonPressed: (index) {
                Future.microtask(() {
                  controller.toggleFavorite(
                    controller.filteredProducts.indexOf(favorites[index]),
                  );
                });
              },
              isPriceOff: controller.isPriceOff,
            );
          },
        ),
      ),
    );
  }
}

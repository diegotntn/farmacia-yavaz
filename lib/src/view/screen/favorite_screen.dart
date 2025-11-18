import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid_view.dart';

/// Usamos el controlador existente
final ProductController controller = Get.find<ProductController>();

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Se usa el método correcto
    controller.showFavoriteItems();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GetBuilder<ProductController>(
          builder: (controller) {
            // Lista solo con productos favoritos
            final favorites =
                controller.filteredProducts.where((p) => p.isFavorite).toList();

            // Si no hay favoritos, mostrar mensaje
            if (favorites.isEmpty) {
              return const Center(
                child: Text(
                  "You have no favorite products yet ❤️",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ProductGridView(
              items: favorites,

              // Alterna favorito al presionar el botón
              likeButtonPressed: (index) {
                controller.toggleFavorite(
                  controller.filteredProducts.indexOf(favorites[index]),
                );
              },

              isPriceOff: (product) => controller.isPriceOff(product),
            );
          },
        ),
      ),
    );
  }
}

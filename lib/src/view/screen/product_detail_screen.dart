import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_flutter/core/app_color.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';

/// Controlador global de productos (GetX)
final ProductController controller = Get.put(ProductController());

/// ---------------------------------------------------------------------------
/// PANTALLA DE DETALLE DE PRODUCTO
///
/// Muestra información detallada de un solo producto, incluyendo:
/// - Imagen principal
/// - Nombre, precio y descuento
/// - Estado de stock
/// - Descripción o texto simulado
/// - Botón de agregar al carrito (solo si hay stock)
/// ---------------------------------------------------------------------------
class ProductDetailScreen extends StatelessWidget {
  final Product product; // Producto recibido al abrir esta vista

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Calcula si hay descuento
    final bool hasDiscount = product.off != null;
    // Calcula si hay unidades disponibles
    final bool inStock = (product.stock ?? 0) > 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Botón de favorito (reactivo)
          IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: product.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => controller.toggleFavoriteByProduct(product),
          ),
        ],
      ),

      // Contenido principal
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------------
            // Imagen del producto
            // ---------------------------------------------------------------
            Center(
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  product.images.first,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------------
            // Nombre del producto
            // ---------------------------------------------------------------
            Text(
              product.name,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            // ---------------------------------------------------------------
            // Precio (con o sin descuento)
            // ---------------------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hasDiscount ? "\$${product.off}" : "\$${product.price}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.deepOrange),
                ),
                const SizedBox(width: 8),
                Visibility(
                  visible: hasDiscount,
                  child: Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ---------------------------------------------------------------
            // Estado de stock (verde si disponible, rojo si agotado)
            // ---------------------------------------------------------------
            Row(
              children: [
                Icon(
                  inStock ? Icons.check_circle : Icons.error_outline,
                  color: inStock ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  inStock
                      ? "Stock disponible: ${product.stock} unidades"
                      : "Agotado",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: inStock ? Colors.green[800] : Colors.red[800],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ---------------------------------------------------------------
            // Descripción del producto (texto simulado)
            // ---------------------------------------------------------------
            Text(
              "Descripción del producto",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              "Este es un producto de alta calidad disponible en nuestra tienda. "
              "Perfecto para quienes buscan un equilibrio entre rendimiento, "
              "precio y estilo. ¡Aprovecha nuestras ofertas limitadas!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),

            const SizedBox(height: 25),

            // ---------------------------------------------------------------
            // Botón de agregar al carrito (deshabilitado si no hay stock)
            // ---------------------------------------------------------------
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: inStock
                      ? () => controller.addToCart(product)
                      : null, // 🔒 deshabilitado si no hay stock
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        inStock ? AppColor.darkOrange : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text(
                    inStock
                        ? "Agregar al carrito"
                        : "No disponible actualmente",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---------------------------------------------------------------
            // Productos recomendados o relacionados (si deseas)
            // ---------------------------------------------------------------
            Text(
              "También te puede interesar",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Mini lista de productos sugeridos (solo 2 o 3)
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppColor.randomColors.length,
                itemBuilder: (_, i) {
                  final suggested =
                      controller.allProducts[i % controller.allProducts.length];
                  return GestureDetector(
                    onTap: () => Get.to(
                      () => ProductDetailScreen(product: suggested),
                    ),
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(suggested.images.first, height: 70),
                          const SizedBox(height: 6),
                          Text(
                            suggested.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "\$${suggested.price}",
                            style: const TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

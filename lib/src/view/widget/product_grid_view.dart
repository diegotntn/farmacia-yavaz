import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/animation/open_container_wrapper.dart';

/// ============================================================================
/// Widget que muestra una cuadrícula de productos.
///
/// Parámetros:
///  - [items]: Lista de productos.
///  - [isPriceOff]: Función que determina si un producto tiene descuento.
///  - [likeButtonPressed]: Callback para alternar el estado favorito.
/// ============================================================================
class ProductGridView extends StatelessWidget {
  const ProductGridView({
    super.key,
    required this.items,
    required this.isPriceOff,
    required this.likeButtonPressed,
  });

  final List<Product> items;
  final bool Function(Product product) isPriceOff;
  final void Function(int index) likeButtonPressed;

  // ----------------------------------------------------------------------------
  // Encabezado: botón favorito + etiqueta de descuento
  // ----------------------------------------------------------------------------
  Widget _buildHeader(Product product, int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Etiqueta de descuento
          Visibility(
            visible: isPriceOff(product),
            child: Container(
              width: 80,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: const Text(
                "30% OFF",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),

          /// Botón de favoritos
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: items[index].isFavorite
                  ? Colors.redAccent
                  : const Color(0xFFA6A3A0),
            ),
            onPressed: () {
              // 🔥 FIX DEL ERROR setState during build
              Future.microtask(() {
                likeButtonPressed(index);
              });
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------
  // Cuerpo: imagen del producto
  // ----------------------------------------------------------------------------
  Widget _buildImage(Product product) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E6E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(product.images[0], scale: 3),
    );
  }

  // ----------------------------------------------------------------------------
  // Pie: nombre, precio y stock
  // ----------------------------------------------------------------------------
  Widget _buildFooter(Product product, BuildContext context) {
    final bool hasDiscount = product.off != null;
    final bool inStock = (product.stock ?? 0) > 0;

    return Container(
      height: 95,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// Nombre
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),

          /// Precio
          Row(
            children: [
              Text(
                hasDiscount ? "\$${product.off}" : "\$${product.price}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 4),
              Visibility(
                visible: hasDiscount,
                child: Text(
                  "\$${product.price}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          /// Stock
          Text(
            inStock ? "Stock: ${product.stock} unidades" : "Agotado",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: inStock ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------
  // Render de la grilla de productos
  // ----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 10 / 16,
        ),
        itemBuilder: (_, index) {
          final product = items[index];

          return OpenContainerWrapper(
            product: product,
            child: GridTile(
              header: _buildHeader(product, index),
              footer: _buildFooter(product, context),
              child: _buildImage(product),
            ),
          );
        },
      ),
    );
  }
}

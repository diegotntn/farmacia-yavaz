import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/animation/open_container_wrapper.dart';

/// ---------------------------------------------------------------------------
/// Widget que muestra una cuadrícula de productos.
///
/// Este componente recibe:
/// - [items]: lista de productos a mostrar.
/// - [isPriceOff]: función que determina si un producto tiene descuento.
/// - [likeButtonPressed]: callback para alternar el estado de favorito.
/// ---------------------------------------------------------------------------
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

  // -------------------------------------------------------------------------
  // Encabezado: descuento y botón favorito
  // -------------------------------------------------------------------------
  Widget _gridItemHeader(Product product, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto "30% OFF"
          Visibility(
            visible: isPriceOff(product),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              width: 80,
              height: 30,
              alignment: Alignment.center,
              child: const Text(
                "30% OFF",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // Botón favorito
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: items[index].isFavorite
                  ? Colors.redAccent
                  : const Color(0xFFA6A3A0),
            ),
            onPressed: () => likeButtonPressed(index),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Cuerpo: imagen del producto
  // -------------------------------------------------------------------------
  Widget _gridItemBody(Product product) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E6E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(product.images[0], scale: 3),
    );
  }

  // -------------------------------------------------------------------------
  // Pie de tarjeta: nombre, precio, stock
  // -------------------------------------------------------------------------
  Widget _gridItemFooter(Product product, BuildContext context) {
    final bool hasDiscount = product.off != null;
    final bool inStock = (product.stock ?? 0) > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      height: 95, // 🔧 Altura ajustada para evitar overflow
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
          // Nombre del producto
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 14,
            ),
          ),

          // Precio (con descuento si aplica)
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
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          // Stock
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

  // -------------------------------------------------------------------------
  // Render de la grilla de productos
  // -------------------------------------------------------------------------
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
              header: _gridItemHeader(product, index),
              footer: _gridItemFooter(product, context),
              child: _gridItemBody(product),
            ),
          );
        },
      ),
    );
  }
}

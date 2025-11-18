import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_flutter/core/extensions.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/animation/animated_switcher_wrapper.dart';
import 'package:e_commerce_flutter/src/view/widget/empty_cart.dart';

/// ------------------------------------------------------------
/// 🛒 CartScreen
///
/// Pantalla que muestra el carrito de compras:
/// - Lista de productos agregados
/// - Modificación de cantidades
/// - Total acumulado
/// - Botón de compra
/// ------------------------------------------------------------
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Controlador GetX para manejar los productos y el carrito
  final ProductController controller = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    // Se asegura de actualizar los productos visibles en el carrito después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
          .showCartItems(); // ✅ Evita errores de actualización durante build
    });
  }

  /// AppBar con título
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "My cart",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }

  /// Lista de productos dentro del carrito
  Widget _cartList() {
    return SingleChildScrollView(
      child: Column(
        children: controller.cartProducts.mapWithIndex((index, _) {
          final Product product = controller.cartProducts[index];

          return Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200]?.withAlpha(60),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // 🔸 Imagen del producto
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: ColorExtension.randomColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        product.images.first,
                        width: 100,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 🔸 Información del producto: nombre, talla, precio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre del producto
                      Text(
                        product.name.nextLine,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Talla seleccionada
                      Text(
                        controller.getCurrentSize(product),
                        style: TextStyle(
                          color: Colors.black.withAlpha(120),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Precio (con descuento si aplica)
                      Text(
                        controller.isPriceOff(product)
                            ? "\$${product.off}"
                            : "\$${product.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 23,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 5),

                // 🔸 Controles para aumentar o disminuir cantidad
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // Botón disminuir cantidad
                      IconButton(
                        splashRadius: 10.0,
                        icon:
                            const Icon(Icons.remove, color: Color(0xFFEC6813)),
                        onPressed: () =>
                            controller.decreaseItemQuantity(product),
                      ),

                      // Cantidad actual (observable con animación)
                      GetBuilder<ProductController>(
                        builder: (_) {
                          return AnimatedSwitcherWrapper(
                            child: Text(
                              '${product.quantity}',
                              key: ValueKey<int>(product.quantity),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),

                      // Botón aumentar cantidad
                      IconButton(
                        splashRadius: 10.0,
                        icon: const Icon(Icons.add, color: Color(0xFFEC6813)),
                        onPressed: () =>
                            controller.increaseItemQuantity(product),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Muestra el total acumulado en el carrito
  Widget _bottomBarTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total", style: TextStyle(fontSize: 22)),
          // Muestra el total observable con animación
          Obx(
            () => AnimatedSwitcherWrapper(
              child: Text(
                "\$${controller.totalPrice.value}",
                key: ValueKey<int>(controller.totalPrice.value),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEC6813),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Botón de compra
  Widget _bottomBarButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
          ),
          // Deshabilitado si el carrito está vacío
          onPressed: controller.isEmptyCart
              ? null
              : () {
                  // Aquí puedes colocar la lógica de compra o navegación
                  // Ej: Get.to(() => CheckoutScreen());
                },
          child: const Text("Buy Now"),
        ),
      ),
    );
  }

  /// Build principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Contenido: productos del carrito o carrito vacío
          Expanded(
            child: controller.isEmptyCart
                ? const EmptyCart()
                : _cartList(), // Renderiza la lista
          ),

          // Total y botón inferior
          _bottomBarTitle(),
          _bottomBarButton(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_commerce_flutter/core/extensions.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/animation/animated_switcher_wrapper.dart';
import 'package:e_commerce_flutter/src/view/widget/empty_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ProductController controller = Get.put(ProductController());

  final Color rojo = const Color(0xFFE53935);
  final Color azul = const Color(0xFF1E88E5);
  final Color blanco = Colors.white;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.showCartItems();
    });
  }

  // --------------------------------------------------------
  // 🔵 APPBAR PERSONALIZADO
  // --------------------------------------------------------
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: rojo,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Mi Carrito",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: blanco,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  // --------------------------------------------------------
  // 🔴 TARJETAS DE PRODUCTO ESTILIZADAS
  // --------------------------------------------------------
  Widget _cartList() {
    return SingleChildScrollView(
      child: Column(
        children: controller.cartProducts.mapWithIndex((index, _) {
          final Product product = controller.cartProducts[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: blanco,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: azul.withOpacity(.12),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                )
              ],
            ),
            child: Row(
              children: [
                // 🖼 Imagen
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      product.images.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // 📄 Información del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name.nextLine,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.getCurrentSize(product),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.isPriceOff(product)
                            ? "\$${product.off}"
                            : "\$${product.price}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: rojo,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔵 Controles de cantidad
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    color: azul.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Disminuir
                      InkWell(
                        onTap: () => controller.decreaseItemQuantity(product),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.remove, color: rojo, size: 22),
                        ),
                      ),

                      // Cantidad animada
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

                      // Aumentar
                      InkWell(
                        onTap: () => controller.increaseItemQuantity(product),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.add, color: azul, size: 22),
                        ),
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

  // --------------------------------------------------------
  // 💵 TOTAL DEL CARRITO
  // --------------------------------------------------------
  Widget _bottomBarTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total", style: TextStyle(fontSize: 22)),
          Obx(
            () => AnimatedSwitcherWrapper(
              child: Text(
                "\$${controller.totalPrice.value}",
                key: ValueKey<int>(controller.totalPrice.value),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: rojo,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // 🔵 BOTÓN DE COMPRA ESTILIZADO
  // --------------------------------------------------------
  Widget _bottomBarButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: azul,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: controller.isEmptyCart ? null : () {},
          child: Text(
            "Comprar ahora",
            style: TextStyle(
              color: blanco,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------
  // 🧱 BUILD PRINCIPAL
  // --------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: blanco,
      body: Column(
        children: [
          Expanded(
            child: controller.isEmptyCart ? const EmptyCart() : _cartList(),
          ),
          _bottomBarTitle(),
          _bottomBarButton(),
        ],
      ),
    );
  }
}

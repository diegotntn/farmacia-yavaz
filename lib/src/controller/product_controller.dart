import 'package:get/get.dart';
import 'package:e_commerce_flutter/core/app_data.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/model/numerical.dart';
import 'package:e_commerce_flutter/src/model/product_category.dart';
import 'package:e_commerce_flutter/src/model/product_size_type.dart';

/// ===========================================================================
/// 🛍️ PRODUCT CONTROLLER
/// ---------------------------------------------------------------------------
/// Controlador GetX que administra toda la lógica de productos:
/// - Filtrado por categoría
/// - Gestión de favoritos
/// - Carrito de compras con control de stock
/// - Cálculo de precios y descuentos
/// - Selección de tallas o presentaciones
/// ===========================================================================
class ProductController extends GetxController {
  /// Lista completa de productos (simulada desde AppData)
  List<Product> allProducts = AppData.products;

  /// Lista reactiva de productos actualmente filtrados
  RxList<Product> filteredProducts = AppData.products.obs;

  /// Productos agregados al carrito
  RxList<Product> cartProducts = <Product>[].obs;

  /// Categorías disponibles para filtrar productos
  RxList<ProductCategory> categories = AppData.categories.obs;

  /// Precio total del carrito
  RxInt totalPrice = 0.obs;

  // -------------------------------------------------------------------------
  // 🔍 FILTRO POR CATEGORÍA
  // -------------------------------------------------------------------------
  /// Filtra los productos según la categoría seleccionada
  void filterItemsByCategory(int index) {
    // Reiniciar selección de categorías
    for (var category in categories) {
      category.isSelected = false;
    }
    categories[index].isSelected = true;

    // Si es "All", muestra todos
    if (categories[index].type == ProductType.all) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts
            .where((item) => item.type == categories[index].type)
            .toList(),
      );
    }
    update();
  }

  // -------------------------------------------------------------------------
  // ⭐ FAVORITOS
  // -------------------------------------------------------------------------
  /// Alterna el estado de favorito en el listado principal
  void toggleFavorite(int index) {
    filteredProducts[index].isFavorite = !filteredProducts[index].isFavorite;
    update();
  }

  /// Alterna favorito desde un producto directo (por ejemplo, en el detalle)
  void toggleFavoriteByProduct(Product product) {
    final index = allProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      allProducts[index].isFavorite = !allProducts[index].isFavorite;
      update();
    }
  }

  /// Muestra únicamente los productos marcados como favoritos
  void showFavoriteItems() {
    filteredProducts.assignAll(allProducts.where((item) => item.isFavorite));
    update();
  }

  // -------------------------------------------------------------------------
  // 🛒 CARRITO DE COMPRAS
  // -------------------------------------------------------------------------
  /// Agrega un producto al carrito verificando el stock
  void addToCart(Product product) {
    if (product.stock > 0 && product.quantity < product.stock) {
      product.quantity++;
      cartProducts.add(product);
      calculateTotalPrice();
      update();
    } else {
      Get.snackbar(
        "Sin stock",
        "No hay suficiente stock para agregar ${product.name}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Incrementa la cantidad de un producto en el carrito
  void increaseItemQuantity(Product product) {
    if (product.quantity < product.stock) {
      product.quantity++;
      calculateTotalPrice();
      update();
    } else {
      Get.snackbar(
        "Stock insuficiente",
        "${product.name} no tiene más unidades disponibles",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Disminuye la cantidad (si es mayor a 0)
  void decreaseItemQuantity(Product product) {
    if (product.quantity > 0) {
      product.quantity--;
      calculateTotalPrice();
      update();
    }
  }

  /// Vacía todo el carrito
  void clearCart() {
    for (var product in cartProducts) {
      product.quantity = 0;
    }
    cartProducts.clear();
    totalPrice.value = 0;
    update();
  }

  /// Devuelve `true` si el carrito está vacío
  bool get isEmptyCart => cartProducts.isEmpty;

  /// Calcula el total del carrito considerando descuentos
  void calculateTotalPrice() {
    int total = 0;
    for (var item in cartProducts) {
      final double price =
          (item.off != null ? item.off!.toDouble() : item.price);
      total += (item.quantity * price).toInt();
    }
    totalPrice.value = total;
  }

  /// Muestra solo los productos que están actualmente en el carrito
  void showCartItems() {
    cartProducts.assignAll(allProducts.where((item) => item.quantity > 0));
    update();
  }

  // -------------------------------------------------------------------------
  // 📦 PRODUCTOS GENERALES
  // -------------------------------------------------------------------------
  /// Carga todos los productos (inicio o refresco)
  void loadAllProducts() {
    filteredProducts.assignAll(allProducts);
    update();
  }

  /// Devuelve `true` si el producto tiene descuento
  bool isPriceOff(Product product) => product.off != null;

  /// Devuelve `true` si el producto tiene tallas numéricas
  bool isNominal(Product product) => product.sizes?.numerical != null;

  /// Devuelve `true` si el producto está agotado
  bool isOutOfStock(Product product) => product.stock <= 0;

  // -------------------------------------------------------------------------
  // 📏 TAMAÑOS Y PRESENTACIONES
  // -------------------------------------------------------------------------
  /// Devuelve todas las tallas (numéricas o categóricas)
  List<Numerical> sizeType(Product product) {
    final List<Numerical> result = [];

    // Si tiene tallas numéricas
    if (product.sizes?.numerical != null) {
      for (var num in product.sizes!.numerical!) {
        result.add(Numerical(num.numerical, num.isSelected));
      }
    }

    // Si tiene tallas categóricas (S, M, L, etc.)
    if (product.sizes?.categorical != null) {
      for (var cat in product.sizes!.categorical!) {
        result.add(Numerical(cat.categorical.name, cat.isSelected));
      }
    }

    return result;
  }

  /// Cambia la talla seleccionada (únicamente una activa a la vez)
  void switchBetweenProductSizes(Product product, int index) {
    // Desactiva todas las tallas
    sizeType(product).forEach((e) => e.isSelected = false);

    // Activa la seleccionada
    if (product.sizes?.categorical != null &&
        index < product.sizes!.categorical!.length) {
      product.sizes!.categorical![index].isSelected = true;
    }

    if (product.sizes?.numerical != null &&
        index < product.sizes!.numerical!.length) {
      product.sizes!.numerical![index].isSelected = true;
    }

    update();
  }

  /// Devuelve el texto de la talla actualmente seleccionada
  String getCurrentSize(Product product) {
    if (product.sizes?.categorical != null) {
      final selected =
          product.sizes!.categorical!.firstWhereOrNull((e) => e.isSelected);
      if (selected != null) return "Talla: ${selected.categorical.name}";
    }

    if (product.sizes?.numerical != null) {
      final selected =
          product.sizes!.numerical!.firstWhereOrNull((e) => e.isSelected);
      if (selected != null) return "Talla: ${selected.numerical}";
    }

    return "";
  }
}

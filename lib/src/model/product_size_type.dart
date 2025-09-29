import 'package:e_commerce_flutter/src/model/categorical.dart';
import 'package:e_commerce_flutter/src/model/numerical.dart';

/// Clase que representa los tamaños o variantes de un producto
/// Puede incluir opciones numéricas (Numerical) y categóricas (Categorical)
class ProductSizeType {
  /// Lista de opciones numéricas del producto (por ejemplo, "32GB", "128GB")
  List<Numerical>? numerical;

  /// Lista de opciones categóricas del producto (por ejemplo, small, medium, large)
  List<Categorical>? categorical;

  /// Constructor opcional, permite inicializar con listas vacías o nulas
  ProductSizeType({this.numerical, this.categorical});

  // ----------------- Serialización -----------------

  /// Crea una instancia de ProductSizeType desde un JSON
  /// - 'numerical': se espera una lista de mapas que representan objetos Numerical
  /// - 'categorical': se espera una lista de mapas que representan objetos Categorical
  /// Si alguna de las listas no está presente, se inicializa como null
  factory ProductSizeType.fromJson(Map<String, dynamic> json) {
    return ProductSizeType(
      numerical: json['numerical'] != null
          ? List<Numerical>.from(
              json['numerical'].map((x) => Numerical.fromJson(x)))
          : null, // Si no hay datos numéricos, se deja null
      categorical: json['categorical'] != null
          ? List<Categorical>.from(
              json['categorical'].map((x) => Categorical.fromJson(x)))
          : null, // Si no hay datos categóricos, se deja null
    );
  }

  /// Convierte la instancia de ProductSizeType a JSON
  /// - Se incluyen solo las listas que no son null
  /// - Cada objeto Numerical y Categorical se convierte usando su propio toJson
  Map<String, dynamic> toJson() {
    return {
      if (numerical != null)
        'numerical': numerical!.map((e) => e.toJson()).toList(),
      if (categorical != null)
        'categorical': categorical!.map((e) => e.toJson()).toList(),
    };
  }
}

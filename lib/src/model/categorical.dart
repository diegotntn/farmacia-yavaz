/// Enum que representa los posibles tamaños/categorías
enum CategoricalType { small, medium, large }

/// Clase que representa una opción categórica seleccionable
class Categorical {
  /// Tipo de la categoría (small, medium, large)
  CategoricalType categorical;

  /// Indica si la opción está seleccionada
  bool isSelected;

  /// Constructor
  /// [isSelected] es opcional, por defecto es false
  Categorical(this.categorical, [this.isSelected = false]);

  // ----------------- Serialización -----------------

  /// Crea una instancia de Categorical desde un JSON
  /// Se espera un JSON con las claves:
  /// - "categorical": String que representa el enum (small, medium, large)
  /// - "isSelected": bool opcional
  factory Categorical.fromJson(Map<String, dynamic> json) {
    return Categorical(
      CategoricalType.values.firstWhere(
        (e) => e.toString() == 'CategoricalType.${json['categorical']}',
        orElse: () =>
            CategoricalType.small, // Valor por defecto si no se encuentra
      ),
      json['isSelected'] ?? false, // Valor por defecto si no existe
    );
  }

  /// Convierte la instancia de Categorical a JSON
  Map<String, dynamic> toJson() {
    return {
      'categorical':
          categorical.toString().split('.').last, // Solo el nombre del enum
      'isSelected': isSelected,
    };
  }
}

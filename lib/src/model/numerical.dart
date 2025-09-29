/// Clase que representa una opción numérica seleccionable
class Numerical {
  /// Valor numérico representado como String (por ejemplo, "32GB", "128GB")
  String numerical;

  /// Indica si la opción está seleccionada
  bool isSelected;

  /// Constructor
  /// [isSelected] es opcional, por defecto es false
  Numerical(this.numerical, [this.isSelected = false]);

  // ----------------- Serialización -----------------

  /// Crea una instancia de Numerical desde un JSON
  /// Se espera un JSON con las claves:
  /// - "numerical": String que representa el valor
  /// - "isSelected": bool opcional
  factory Numerical.fromJson(Map<String, dynamic> json) {
    return Numerical(
      json['numerical'] ?? '', // Valor por defecto si no existe
      json['isSelected'] ?? false, // Valor por defecto si no existe
    );
  }

  /// Convierte la instancia de Numerical a JSON
  Map<String, dynamic> toJson() {
    return {
      'numerical': numerical,
      'isSelected': isSelected,
    };
  }
}

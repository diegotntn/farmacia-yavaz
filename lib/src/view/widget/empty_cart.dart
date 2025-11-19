import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🖼 Imagen capitan.jpg con transparencia suave
          Opacity(
            opacity: 0.50, // cambia entre 0.3 y 0.7 según prefieras
            child: Image.asset(
              "assets/images/capitan.jpg",
              width: 280,
              height: 280,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Empty cart",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

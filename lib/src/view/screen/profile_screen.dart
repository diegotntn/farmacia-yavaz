import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/core/app_color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Colores del logo YaVaz
    const Color logoBlue = Color(0xFF004C9A);
    const Color logoRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.white, // 🤍 FONDO BLANCO
      appBar: AppBar(
        backgroundColor: logoRed,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mi Perfil",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LOGO GRANDE
            Image.asset(
              'assets/images/yavaz_logo.png',
              height: 165,
            ),

            const SizedBox(height: 45),

            // AVATAR
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: logoBlue.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 65,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/default_avatar.png'),
              ),
            ),

            const SizedBox(height: 28),

            // NOMBRE
            Text(
              "Usuario",
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: logoBlue,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Usuario registrado",
              style: TextStyle(
                color: AppColor.darkGrey,
                fontSize: 16,
              ),
            ),

            // ↓↓↓ MÁS ESPACIO ANTES DEL BOTÓN ↓↓↓
            const SizedBox(height: 110), // 👈 BOTÓN MÁS ABAJO

            // BOTÓN CERRAR SESIÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: logoRed,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Cerrar sesión",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40), // extra spacing bottom
          ],
        ),
      ),
    );
  }
}

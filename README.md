
# Farmacia Yavaz 🏥💊

Proyecto desarrollado en **Flutter/Dart**.

---

## 🚀 Clonar el repositorio

### Opción 1: Clonar con HTTPS
```bash
git clone https://github.com/diegotntn/farmacia-yavaz.git
cd farmacia-yavaz
````

Te pedirá tu usuario y un **Personal Access Token** (PAT) de GitHub en lugar de contraseña.
👉 [Cómo generar un token](https://docs.github.com/es/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

### Opción 2: Clonar con SSH (recomendado)

Primero configura tu llave SSH en GitHub. Luego:

```bash
git clone git@github.com:diegotntn/farmacia-yavaz.git
cd farmacia-yavaz
```

---

## 📦 Instalar dependencias

Asegúrate de tener **Flutter** instalado y configurado.
Dentro del proyecto, corre:

```bash
flutter pub get
```

---

## ▶️ Ejecutar el proyecto

En dispositivo/emulador:

```bash
flutter run
```

En navegador (web):

```bash
flutter run -d chrome
```

---

## 📂 Estructura del proyecto

```plaintext
📂lib
 │───main.dart  
 │
 │───📂core  
 │   │──app_data.dart
 │   │──app_theme.dart
 │   │──app_color.dart
 │   └──extensions.dart
 │
 └───📂src
     │
     │────📂model
     │    │──user.dart                 ← clase base (id, nombre, email, role)
     │    │──client.dart               ← modelo extendido (datos cliente)
     │    │──vendor.dart               ← modelo extendido (datos vendedor)
     │    │──product.dart
     │    │──product_category.dart
     │    │──product_size_type.dart
     │    │──recommended_product.dart
     │    │──categorical.dart
     │    │──numerical.dart
     │    └──bottom_nav_bar_item.dart
     │
     │────📂view
     │    │
     │    │───📂screen
     │    │   │──login_screen.dart      ← login clientes/vendedores
     │    │   │──register_screen.dart   ← registro clientes/vendedores
     │    │   │──home_screen.dart
     │    │   │──product_list_screen.dart
     │    │   │──product_detail_screen.dart
     │    │   │──favorite_screen.dart
     │    │   │──cart_screen.dart
     │    │   └──profile_screen.dart
     │    │
     │    │───📂widget
     │    │   │──carousel_slider.dart
     │    │   │──product_grid_view.dart
     │    │   │──list_item_selector.dart
     │    │   └──empty_cart.dart
     │    │
     │    └───📂animation
     │        │──animated_switcher_wrapper.dart
     │        │──open_container_wrapper.dart
     │        └──page_transition_switcher_wrapper.dart
     │
     └────📂controller
          │──auth_controller.dart       ← login/registro/logout
          │──client_controller.dart     ← lógica de cliente (pedidos, carrito, historial)
          │──vendor_controller.dart     ← lógica de vendedor (productos, ventas)
          └──product_controller.dart    ← lógica de productos compartida
```

---

## ✅ Requisitos previos

* [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
* Tener configurado un emulador Android/iOS o navegador Chrome.
* Acceso al repositorio privado (ser colaborador).


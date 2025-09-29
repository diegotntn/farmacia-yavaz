import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import 'home_screen.dart'; // Importar pantalla de inicio
import 'register_screen.dart'; // Importar pantalla de registro

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables de estado
  bool _isVendor = false; // Define si el login es como vendedor o cliente
  bool _isLoading = false; // Controla el estado de carga durante el login

  // Controlador de autenticación que maneja la lógica de login
  final AuthController _authController = AuthController();

  // Función principal para manejar el proceso de login
  Future<void> _login() async {
    // Validar el formulario antes de proceder
    if (!_formKey.currentState!.validate()) return;

    // Activar estado de carga
    setState(() {
      _isLoading = true;
    });

    // Obtener y limpiar los datos del formulario
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Llamar al controlador de autenticación
    bool success = await _authController.login(
      email: email,
      password: password,
      isVendor: _isVendor,
    );

    // Desactivar estado de carga
    setState(() {
      _isLoading = false;
    });

    // Manejar el resultado del login
    if (success) {
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Login exitoso como ${_isVendor ? 'vendedor' : 'cliente'}'),
        ),
      );

      // 🔄 REDIRECCIÓN PRINCIPAL: Navegar a HomeScreen y reemplazar la pila
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login fallido, verifica tus credenciales'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 📧 Campo de email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      // Validar que el campo no esté vacío
                      if (value == null || value.isEmpty)
                        return 'Ingrese su correo';
                      // Validar formato de email con expresión regular
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Ingrese un correo válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // 🔒 Campo de contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true, // Oculta el texto para contraseñas
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      // Validar que el campo no esté vacío
                      if (value == null || value.isEmpty)
                        return 'Ingrese su contraseña';
                      // Validar longitud mínima de contraseña
                      if (value.length < 6)
                        return 'La contraseña debe tener al menos 6 caracteres';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // 🔄 Switch para seleccionar tipo de usuario
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Login como vendedor'),
                      Switch(
                        value: _isVendor,
                        onChanged: (value) {
                          setState(() {
                            _isVendor = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ⏳ Mostrar indicador de carga o botón de login
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          child: const Text('Iniciar sesión'),
                        ),

                  const SizedBox(height: 16),

                  // 🔗 Botón para redirigir a pantalla de registro
                  TextButton(
                    onPressed: () {
                      // 📂 REDIRECCIÓN SECUNDARIA: Navegar a RegisterScreen
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()));
                    },
                    child: const Text('¿No tienes cuenta? Regístrate'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método para limpiar los controladores cuando el widget se destruye
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

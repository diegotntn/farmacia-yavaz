import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';

/// ---------------------------------------------------------------------------
/// 🧾 RegisterScreen (Clientes)
///
/// Esta pantalla maneja el registro de CLIENTES en la aplicación.
/// NO muestra opción para registrar vendedores (eso irá en otra pantalla).
///
/// Incluye:
/// ✅ Validación de formulario
/// ✅ Controladores de texto para cada campo
/// ✅ Selector de fecha de nacimiento
/// ✅ Llamada al AuthController para registrar en la lógica de negocio
/// ✅ Indicador de carga durante el registro
/// ✅ Mensajes visuales de éxito/error
///
/// Future-ready:
/// - Fácilmente conectable a backend / Firebase
/// - Mantiene separación entre UI y lógica
/// ---------------------------------------------------------------------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Clave global para referenciar y validar el formulario
  final _formKey = GlobalKey<FormState>();

  /// Controladores para capturar valores de entrada
  /// Se destruyen automáticamente cuando el widget se elimina
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  /// Fecha opcional de nacimiento
  DateTime? _fechaNacimiento;

  /// Bandera para controlar estado de carga (circular progress indicator)
  bool _isLoading = false;

  /// Controlador de autenticación (lógica de negocio)
  /// Aquí se centraliza la lógica de login/registro/logout
  final AuthController _authController = AuthController();

  // ---------------------------------------------------------------------------
  // 📍 Método para registrar al usuario cliente
  // ---------------------------------------------------------------------------
  Future<void> _register() async {
    // Bloquea acción si formulario no es válido
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true); // Muestra loader

    // Captura valores de campos
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Nombre opcional: si está vacío -> null
    String? name = _nombreController.text.trim().isEmpty
        ? null
        : _nombreController.text.trim();

    // Llamamos al método del AuthController para registrar cliente
    bool success = await _authController.registerClient(
      email: email,
      password: password,
      name: name,
      fechaNacimiento: _fechaNacimiento,
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
    );

    // Quitamos loader
    setState(() => _isLoading = false);

    // Respuesta visual al usuario
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Registro exitoso como cliente')),
      );

      // TODO: redirigir a Login o Home en el flujo real
      // Navigator.pushReplacement(...);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Error al registrar')),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // 📅 Selector de fecha de nacimiento
  // ---------------------------------------------------------------------------
  Future<void> _selectDate() async {
    // Fecha inicial sugerida = hace 18 años (mayoría de edad)
    DateTime initialDate =
        DateTime.now().subtract(const Duration(days: 365 * 18));

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // Fecha inicial
      firstDate: DateTime(1950), // No permitir fechas irrealmente viejas
      lastDate: DateTime.now(), // No permitir fechas futuras
    );

    // Si escogió una fecha, guardarla
    if (picked != null) {
      setState(() => _fechaNacimiento = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Cliente'),
        centerTitle: true,
      ),

      // Padding general
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // Form: permite validación y control de campos
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // -------------------------------------------------------------------
                  // ✉️ Campo Correo
                  // -------------------------------------------------------------------
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Ingresa tu correo';

                      // Validación básica de email usando RegEx
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value))
                        return 'Correo no válido';

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // -------------------------------------------------------------------
                  // 🔑 Contraseña
                  // -------------------------------------------------------------------
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true, // Ocultar texto
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value != null && value.length >= 6
                        ? null
                        : 'Mínimo 6 caracteres',
                  ),

                  const SizedBox(height: 16),

                  // -------------------------------------------------------------------
                  // 👤 Nombre completo
                  // -------------------------------------------------------------------
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // -------------------------------------------------------------------
                  // 📅 Fecha nacimiento
                  // -------------------------------------------------------------------
                  Row(
                    children: [
                      const Text('Fecha de nacimiento (opcional): '),
                      TextButton(
                        onPressed: _selectDate,
                        child: Text(
                          _fechaNacimiento == null
                              ? 'Seleccionar'
                              : '${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // -------------------------------------------------------------------
                  // 📞 Teléfono
                  // -------------------------------------------------------------------
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // -------------------------------------------------------------------
                  // 🏡 Dirección
                  // -------------------------------------------------------------------
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // -------------------------------------------------------------------
                  // ✅ Botón registrar o loader
                  // -------------------------------------------------------------------
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _register,
                          child: const Text('Registrarse'),
                        ),

                  const SizedBox(height: 10),

                  // -------------------------------------------------------------------
                  // 🔗 Enlace a login
                  // -------------------------------------------------------------------
                  TextButton(
                    onPressed: () {
                      // TODO: navegación a login
                      // Navigator.pop(context);
                    },
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

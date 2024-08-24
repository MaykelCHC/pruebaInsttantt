import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../models/user_model/user_model.dart';
import '../../../screens/screens.dart';
import '../../../services/services.dart';

/// Proveedor para manejar la lógica de registro en la aplicación.
class SignupProvider extends ChangeNotifier {
  /// Clave global para el formulario de registro.
  final formKey = GlobalKey<FormState>();

  /// Controlador para el campo de nombre de usuario.
  final usernameController = TextEditingController();

  /// Controlador para el campo de correo electrónico.
  final emailController = TextEditingController();

  /// Controlador para el campo de contraseña.
  final passwordController = TextEditingController();

  /// Controlador para el campo de confirmación de contraseña.
  final confirmPasswordController = TextEditingController();

  /// Estado de visibilidad de la contraseña.
  bool _hiddenPassword = true;

  /// Estado de visibilidad de la confirmación de contraseña.
  bool _hiddenConfirmPassword = true;

  /// Estado de validación de los datos del formulario.
  bool _validateData = false;

  /// Usuario actual después de registrarse.
  late UserModel? _currentUser;

  /// Obtiene el usuario actual después de registrarse.
  UserModel? get currentUser => _currentUser;

  /// Obtiene el estado de visibilidad de la contraseña.
  bool get hiddenPassword => _hiddenPassword;

  /// Obtiene el estado de visibilidad de la confirmación de contraseña.
  bool get hiddenConfirmPassword => _hiddenConfirmPassword;

  /// Obtiene el estado de validación de los datos del formulario.
  bool get validateData => _validateData;

  /// Establece la visibilidad de la contraseña.
  set hiddenPassword(bool value) {
    _hiddenPassword = value;
    notifyListeners();
  }

  /// Establece la visibilidad de la confirmación de contraseña.
  set hiddenConfirmPassword(bool value) {
    _hiddenConfirmPassword = value;
    notifyListeners();
  }

  /// Establece el estado de validación de los datos del formulario.
  set validateData(bool value) {
    _validateData = value;
    notifyListeners();
  }

  /// Alterna la visibilidad de la contraseña en el formulario.
  void showPassword() {
    _hiddenPassword = !_hiddenPassword;
    notifyListeners();
  }

  /// Alterna la visibilidad de la confirmación de contraseña en el formulario.
  void showConfirmPassword() {
    _hiddenConfirmPassword = !_hiddenConfirmPassword;
    notifyListeners();
  }

  /// Verifica si los datos del formulario están completos y son válidos.
  void checkEmptyData() {
    if (formKey.currentState!.validate()) {
      validateData = true;
    } else {
      validateData = false;
    }
    notifyListeners();
  }

  /// Maneja el proceso de registro de un nuevo usuario.
  Future<void> register(BuildContext context) async {
    try {
      final db = await DatabaseService().database;

      // Verifica si el usuario ya existe en la base de datos
      final existingUser = await db.query(
        'users',
        where: 'username = ? OR email = ?',
        whereArgs: [usernameController.text, emailController.text],
      );

      if (existingUser.isNotEmpty) {
        // Si ya existe un usuario con el mismo username o email, muestra un error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error de registro'),
              content: const Text(
                'El nombre de usuario o correo electrónico ya está en uso. Por favor, elige otro.',
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Inserta el nuevo usuario en la base de datos
        final user = UserModel(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
        );

        await db.insert('users', user.toJson());

        // Establece el usuario actual
        _currentUser = user;

        // Navega a la pantalla de inicio de sesión después del registro exitoso
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SigninScreen(),
          ),
        );

        notifyListeners();
      }
    } catch (e) {
      // Registra cualquier error que ocurra durante el registro
      log('Error al intentar adicionar un usuario a la base de datos: $e');
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/models.dart';
import '../../../screens/screens.dart';
import '../../../services/services.dart';

/// Proveedor para manejar la lógica de inicio de sesión y registro en la aplicación.
class SigninProvider extends ChangeNotifier {
  /// Clave global para el formulario de inicio de sesión.
  final formKey = GlobalKey<FormState>();

  /// Controlador para el campo de correo electrónico.
  final emailController = TextEditingController();

  /// Controlador para el campo de contraseña.
  final passwordController = TextEditingController();

  /// Estado de visibilidad de la contraseña.
  bool _hiddenPassword = true;

  /// Estado de carga, utilizado para mostrar indicadores de progreso.
  bool _isLoading = false;

  /// Usuario actual de la sesión.
  late UserModel? _currentUser = UserModel();

  /// Estado de validación de los datos del formulario.
  bool _validateData = false;

  /// Imagen de perfil del usuario.
  File? _image;

  /// Obtiene el usuario actual de la sesión.
  UserModel? get currentUser => _currentUser;

  /// Obtiene el estado de visibilidad de la contraseña.
  bool get hiddenPassword => _hiddenPassword;

  /// Obtiene el estado de carga.
  bool get isLoading => _isLoading;

  /// Obtiene el estado de validación de los datos del formulario.
  bool get validateData => _validateData;

  /// Obtiene la imagen seleccionada para el perfil del usuario.
  File? get image => _image;

  /// Establece la visibilidad de la contraseña.
  set hiddenPassword(bool value) {
    _hiddenPassword = value;
    notifyListeners();
  }

  /// Establece el estado de validación de los datos del formulario.
  set validateData(bool value) {
    _validateData = value;
    notifyListeners();
  }

  /// Establece el estado de carga.
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Establece la imagen seleccionada para el perfil del usuario.
  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  /// Alterna la visibilidad de la contraseña.
  void showPassword() {
    hiddenPassword = !hiddenPassword;
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

  /// Maneja el proceso de inicio de sesión.
  Future<void> login(BuildContext context) async {
    final db = await DatabaseService().database;
    isLoading = true;

    // Consulta la base de datos para verificar al usuario.
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [emailController.text, passwordController.text],
    );

    if (result.isNotEmpty) {
      // Si el usuario existe, crea el objeto UserModel y navega a la pantalla de usuario.
      _currentUser = UserModel(
        username: result.first['username']?.toString(),
        email: result.first['email']?.toString(),
        password: result.first['password']?.toString(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserScreen(userModel: currentUser),
        ),
      );

      isLoading = false;
      notifyListeners();
    } else {
      // Si las credenciales son incorrectas, muestra un diálogo de error.
      isLoading = false;
      notifyListeners();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error de autenticación'),
            content: const Text(
                'Correo o contraseña incorrectos. Por favor, inténtalo de nuevo.'),
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
    }
  }

  /// Cierra la sesión del usuario actual.
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Solicita permisos necesarios para el acceso a la cámara, fotos y almacenamiento.
  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.storage.request();
  }

  /// Permite al usuario seleccionar una imagen desde la cámara o la galería.
  Future<void> pickImage(ImageSource source) async {
    try {
      await requestPermissions();
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        // Si se selecciona una imagen, se guarda en la variable `image`.
        image = File(pickedFile.path);
        notifyListeners();
      } else {
        // Maneja el caso en que no se selecciona ninguna imagen.
        throw Exception('No se seleccionó ninguna imagen.');
      }
    } catch (e) {
      // Maneja errores durante la selección de la imagen.
      throw Exception('Error al seleccionar la imagen: $e');
    }
  }
}

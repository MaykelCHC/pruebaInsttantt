import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/models.dart';
import '../../../screens/screens.dart';
import '../../../services/services.dart';

class SigninProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hiddenPassword = true;
  bool _isLoading = false;
  late UserModel? _currentUser = UserModel();
  bool _validateData = false;

  UserModel? get currentUser => _currentUser;
  bool get hiddenPassword => _hiddenPassword;
  bool get isLoading => _isLoading;
  bool get validateData => _validateData;

  set hiddenPassword(bool value) {
    _hiddenPassword = value;
    notifyListeners();
  }

  set validateData(bool value) {
    _validateData = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void showPassword() {
    hiddenPassword = !hiddenPassword;
    notifyListeners();
  }

  void checkEmptyData() {
    if (formKey.currentState!.validate()) {
      validateData = true;
    } else {
      validateData = false;
    }
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    final db = await DatabaseService().database;
    isLoading = true;

    // Query the database for the user.
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [emailController.text, passwordController.text],
    );

    if (result.isNotEmpty) {
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
      // Muestra un diálogo con el mensaje de error
      isLoading = false;
      notifyListeners();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de autenticación'),
            content: Text(
                'Correo o contraseña incorrectos. Por favor, inténtalo de nuevo.'),
            actions: [
              TextButton(
                child: Text('OK'),
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

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  late File? _image;
  File? get image => _image;

  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.storage.request();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      await requestPermissions();
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        image = File(pickedFile.path);
        notifyListeners();
      } else {
        // Handle the case where no image was picked
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}

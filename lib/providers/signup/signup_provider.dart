import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../models/user_model/user_model.dart';
import '../../../screens/screens.dart';
import '../../../services/services.dart';

class SignupProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _hiddenPassword = true;
  bool _hiddenConfirmPassword = true;
  bool _validateData = false;
  late UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get hiddenPassword => _hiddenPassword;
  bool get hiddenConfirmPassword => _hiddenConfirmPassword;
  bool get validateData => _validateData;

  set hiddenPassword(bool value) {
    _hiddenPassword = value;
    notifyListeners();
  }

  set hiddenConfirmPassword(bool value) {
    _hiddenConfirmPassword = value;
    notifyListeners();
  }

  set validateData(bool value) {
    _validateData = value;
    notifyListeners();
  }

  void showPassword() {
    _hiddenPassword = !_hiddenPassword;
    notifyListeners();
  }

  void showConfirmPassword() {
    _hiddenConfirmPassword = !_hiddenConfirmPassword;
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

  Future<void> register(BuildContext context) async {
    try {
      final user = UserModel(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      final db = await DatabaseService().database;

      // Insert user into the database.
      await db.insert('users', user.toJson());
      // Set current user.
      _currentUser = user;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SigninScreen(),
        ),
      );

      notifyListeners();
    } catch (e) {
      log('Error al intentar adicionar un usuario a la base datos $e');
    }
  }
}

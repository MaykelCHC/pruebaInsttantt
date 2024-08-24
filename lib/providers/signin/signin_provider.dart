import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../models/models.dart';
import '../../../screens/screens.dart';
import '../../../services/services.dart';

class SigninProvider extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool _canCheckBiometrics = false;
  bool _isBiometricEnabled = false;
  Timer? _sessionTimer;
  Timer? _dialogTimer;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _hiddenPassword = true;
  bool _isLoading = false;

  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get canCheckBiometrics => _canCheckBiometrics;

  late UserModel? _currentUser = UserModel();
  bool _validateData = false;
  File? _image;

  UserModel? get currentUser => _currentUser;
  bool get hiddenPassword => _hiddenPassword;
  bool get isLoading => _isLoading;
  bool get validateData => _validateData;
  File? get image => _image;

  set hiddenPassword(bool value) {
    _hiddenPassword = value;
    notifyListeners();
  }

  set validateData(bool value) {
    _validateData = value;
    notifyListeners();
  }

  set isBiometricEnabled(bool value) {
    _isBiometricEnabled = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set image(File? value) {
    _image = value;
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

      if (!_isBiometricEnabled) {
        await _promptBiometricSetup(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserScreen(userModel: currentUser),
          ),
        );
      }

      isLoading = false;
      notifyListeners();
    } else {
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

  Future<void> _promptBiometricSetup(BuildContext context) async {
    try {
      final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final hasBiometricSupport = await auth.isDeviceSupported();

      if (canAuthenticateWithBiometrics && hasBiometricSupport) {
        final authenticated = await auth.authenticate(
          localizedReason:
              'Por favor, autentíquese para habilitar la biometría.',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          await secureStorage.write(key: 'email', value: emailController.text);
          await secureStorage.write(
              key: 'password', value: passwordController.text);
          await secureStorage.write(key: 'isBiometricEnabled', value: 'true');
          isBiometricEnabled = true;
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Biometría no disponible'),
              content: const Text(
                  'La autenticación biométrica no está disponible o no está configurada en su dispositivo.'),
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
    } catch (e) {
      throw Exception('Error al configurar la biometría: $e');
    }
  }

  Future<void> checkBiometrics() async {
    _canCheckBiometrics = await auth.canCheckBiometrics;
    _isBiometricEnabled =
        (await secureStorage.read(key: 'isBiometricEnabled')) == 'true';
  }

  Future<void> loginWithBiometrics(BuildContext context) async {
    final authenticated = await auth.authenticate(
      localizedReason: 'Por favor, autentíquese para ingresar con biometría.',
      options: const AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );

    if (authenticated) {
      final email = await secureStorage.read(key: 'email');
      final password = await secureStorage.read(key: 'password');

      emailController.text = email!;
      passwordController.text = password!;

      await login(context);
    }
  }

  void startSessionTimer(BuildContext context) {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(const Duration(minutes: 2), () {
      _promptSessionRenewal(context);
    });
  }

  void _promptSessionRenewal(BuildContext context) {
    _dialogTimer = Timer(const Duration(seconds: 10), () {
      logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sesión a punto de expirar'),
          content: const Text('¿Desea renovar su sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                _dialogTimer?.cancel();
                startSessionTimer(context);
                Navigator.of(context).pop();
              },
              child: const Text('Renovar'),
            ),
            TextButton(
              onPressed: () {
                logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SigninScreen()),
                );
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  void logout() {
    _currentUser = null;
    _sessionTimer?.cancel();
    _dialogTimer?.cancel();
    notifyListeners();
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
        throw Exception('No se seleccionó ninguna imagen.');
      }
    } catch (e) {
      throw Exception('Error al seleccionar la imagen: $e');
    }
  }
}

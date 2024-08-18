import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/core.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SigninProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

/// La clase principal de la aplicación que configura y ejecuta el widget de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Test Mobile', // Título de la aplicación que se muestra en el sistema.
      home: AnimatedSplashScreen(
        splash: Icons
            .home, // Icono que se muestra durante la pantalla de inicio animada.
        duration: 3000, // Duración de la pantalla de inicio en milisegundos.
        splashIconSize: 230, // Tamaño del icono en la pantalla de inicio.
        nextScreen:
            const SigninScreen(), // Pantalla a la que se navega después de la pantalla de inicio.
        splashTransition: SplashTransition
            .fadeTransition, // Tipo de transición de la pantalla de inicio.
        backgroundColor:
            AppColors.background, // Color de fondo de la pantalla de inicio.
      ),
    );
  }
}

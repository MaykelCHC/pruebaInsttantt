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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Mobile',
      home: AnimatedSplashScreen(
        splash: Icons.home,
        duration: 3000,
        splashIconSize: 230,
        nextScreen: const SigninScreen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: AppColors.background,
      ),
    );
  }
}

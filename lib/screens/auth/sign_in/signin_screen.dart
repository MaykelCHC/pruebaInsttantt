import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../screens.dart';

/// Pantalla de inicio de sesión de la aplicación.
class SigninScreen extends StatelessWidget {
  /// Constructor de la pantalla de inicio de sesión.
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(color: Colors.transparent),
      ),
      child: ChangeNotifierProvider<SigninProvider>(
        create: (_) => SigninProvider(),
        child: Consumer<SigninProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              // Botón persistente en el pie de página.
              persistentFooterButtons: [_buildButton(theme, context)],
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SingleChildScrollView(
                    child: Form(
                      key: provider.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            'Bienvenido',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(AppImages.logo),
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildForm(provider),
                          const SizedBox(height: 40),
                          PrimaryButton(
                            params: PrimaryButtonParams(
                              title: 'Iniciar Sesión',
                              borderRadius: 30,
                              backgroundColor: provider.validateData
                                  ? AppColors.primary
                                  : null,
                              isLoading: provider.isLoading,
                              textStyle: theme.textTheme.labelLarge!.copyWith(
                                color: provider.validateData
                                    ? AppColors.surface
                                    : AppColors.onSurface.withOpacity(0.38),
                              ),
                              onPressed: provider.validateData
                                  ? () => provider.login(context)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Construye el botón para navegar a la pantalla de registro.
  _buildButton(ThemeData theme, BuildContext context) {
    return PrimaryButton(
      params: PrimaryButtonParams(
        title: 'Registrarse',
        backgroundColor: AppColors.primary,
        borderRadius: 30,
        width: 250,
        textStyle: theme.textTheme.labelLarge!.copyWith(
          color: AppColors.surface,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupScreen(),
          ),
        ),
      ),
    );
  }

  /// Construye el formulario de inicio de sesión.
  _buildForm(SigninProvider provider) {
    return Column(
      children: [
        MainTextFormField(
          prefixIcon: const Icon(Icons.email),
          labelText: 'Correo',
          controller: provider.emailController,
          onChanged: (value) {
            provider.checkEmptyData();
          },
          keyboardType: TextInputType.name,
          validator: Validators.emailValidator,
        ),
        const SizedBox(height: 30),
        MainTextFormField(
          prefixIcon: const Icon(Icons.lock_rounded),
          labelText: 'Contraseña',
          controller: provider.passwordController,
          onChanged: (password) {
            provider.checkEmptyData();
          },
          keyboardType: TextInputType.visiblePassword,
          validator: Validators.passwordValidator,
          suffixIcon: IconButton(
            icon: provider.hiddenPassword
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.remove_red_eye_outlined),
            onPressed: provider.showPassword,
          ),
          obscureText: provider.hiddenPassword,
        ),
      ],
    );
  }
}

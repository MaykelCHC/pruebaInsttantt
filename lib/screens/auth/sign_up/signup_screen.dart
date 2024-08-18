import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

/// Pantalla de registro de la aplicación.
class SignupScreen extends StatelessWidget {
  /// Constructor de la pantalla de registro.
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(color: Colors.transparent),
      ),
      child: ChangeNotifierProvider<SignupProvider>(
        create: (_) => SignupProvider(),
        child: Consumer<SignupProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Registro'),
                centerTitle: true,
              ),
              persistentFooterButtons: [_buildButton(provider, theme, context)],
              body: SingleChildScrollView(
                child: Form(
                  key: provider.formKey,
                  child: _buildForm(provider, size),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Construye el botón para completar el registro.
  _buildButton(SignupProvider provider, ThemeData theme, BuildContext context) {
    return PrimaryButton(
      params: PrimaryButtonParams(
        title: 'Completar Registro',
        borderRadius: 30,
        textStyle: theme.textTheme.labelLarge!.copyWith(
          color: provider.validateData
              ? AppColors.surface
              : AppColors.onSurface.withOpacity(0.38),
        ),
        onPressed:
            provider.validateData ? () => provider.register(context) : null,
      ),
    );
  }

  /// Construye el formulario de registro.
  _buildForm(SignupProvider provider, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SizedBox(
            height: size.height * .1,
          ),
          MainTextFormField(
            prefixIcon: const Icon(Icons.person),
            labelText: 'Nombre de Usuario',
            controller: provider.usernameController,
            onChanged: (value) {
              provider.checkEmptyData();
            },
            keyboardType: TextInputType.name,
            validator: Validators.usernameValidator,
          ),
          const SizedBox(height: 30),
          MainTextFormField(
            prefixIcon: const Icon(Icons.email),
            labelText: 'Correo electrónico',
            controller: provider.emailController,
            onChanged: (email) {
              provider.checkEmptyData();
            },
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailValidator,
          ),
          const SizedBox(height: 30),
          MainTextFormField(
            prefixIcon: const Icon(Icons.lock),
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
          const SizedBox(height: 30),
          MainTextFormField(
            prefixIcon: const Icon(Icons.lock),
            labelText: 'Confirmar contraseña',
            onChanged: (password) {
              provider.checkEmptyData();
            },
            keyboardType: TextInputType.visiblePassword,
            validator: (value) => Validators.confirmPasswordValidator(
              value,
              provider.passwordController.text,
            ),
            suffixIcon: IconButton(
              icon: provider.hiddenConfirmPassword
                  ? const Icon(Icons.visibility_off_outlined)
                  : const Icon(Icons.remove_red_eye_outlined),
              onPressed: provider.showConfirmPassword,
            ),
            obscureText: provider.hiddenConfirmPassword,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

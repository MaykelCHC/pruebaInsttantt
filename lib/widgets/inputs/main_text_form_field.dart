import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';

/// Un widget de campo de texto personalizado con características adicionales.
/// Este widget envuelve un [TextFormField] con opciones para personalizar el comportamiento y la apariencia.
class MainTextFormField extends StatelessWidget {
  /// Crea una instancia de [MainTextFormField] con los parámetros especificados.
  ///
  /// Todos los parámetros son opcionales y tienen valores predeterminados.
  const MainTextFormField({
    super.key,
    this.autofocus = false,
    this.autovalidateMode,
    this.controller,
    this.counterText,
    this.focusNode,
    this.helperText,
    this.hintText,
    this.icon,
    this.initialValue,
    this.inputFormatters,
    this.keyboardType,
    this.labelText,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.prefixIcon,
    this.readOnly = false,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.decoration,
    this.style,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  /// Indica si el campo de texto debe recibir el foco automáticamente cuando se construye el widget.
  final bool autofocus;

  /// Modo de validación automática del campo de texto.
  final AutovalidateMode? autovalidateMode;

  /// Controlador para el campo de texto.
  final TextEditingController? controller;

  /// Texto que se muestra como contador en el campo de texto.
  final String? counterText;

  /// Nodo de enfoque para el campo de texto.
  final FocusNode? focusNode;

  /// Texto que se muestra debajo del campo de texto para proporcionar una ayuda adicional.
  final String? helperText;

  /// Texto que se muestra dentro del campo de texto cuando está vacío.
  final String? hintText;

  /// Ícono que se muestra en el campo de texto.
  final Widget? icon;

  /// Valor inicial del campo de texto.
  final String? initialValue;

  /// Formateadores de entrada que se aplican al texto ingresado.
  final List<TextInputFormatter>? inputFormatters;

  /// Tipo de teclado que se muestra para el campo de texto.
  final TextInputType? keyboardType;

  /// Texto de etiqueta que se muestra dentro del campo de texto cuando no hay valor.
  final String? labelText;

  /// Longitud máxima permitida del texto.
  final int? maxLength;

  /// Número máximo de líneas que el campo de texto puede mostrar.
  final int maxLines;

  /// Indica si el texto debe ser oculto (por ejemplo, para contraseñas).
  final bool obscureText;

  /// Función que se llama cuando el texto en el campo de texto cambia.
  final Function(String)? onChanged;

  /// Función que se llama cuando el usuario envía el texto (presiona "Enter" o "Enviar").
  final Function(String)? onFieldSubmitted;

  /// Función que se llama cuando el usuario toca el campo de texto.
  final void Function()? onTap;

  /// Función que se llama cuando el usuario toca fuera del campo de texto.
  final void Function(PointerDownEvent)? onTapOutside;

  /// Ícono que se muestra al inicio del campo de texto.
  final Widget? prefixIcon;

  /// Indica si el campo de texto debe ser solo lectura.
  final bool readOnly;

  /// Ícono que se muestra al final del campo de texto.
  final Widget? suffixIcon;

  /// Capitalización del texto ingresado.
  final TextCapitalization textCapitalization;

  /// Función de validación para el campo de texto.
  final String? Function(String?)? validator;

  /// Decoración personalizada para el campo de texto.
  final InputDecoration? decoration;

  /// Estilo del texto dentro del campo de texto.
  final TextStyle? style;

  /// Acción del teclado cuando se envía el texto.
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      textInputAction: textInputAction,
      autofocus: autofocus,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      obscureText: obscureText,
      obscuringCharacter: '*',
      onTapOutside: onTapOutside,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly,
      onFieldSubmitted: onFieldSubmitted,
      style: style ??
          theme.textTheme.bodyLarge!.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            counterText: counterText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            helperStyle: theme.textTheme.bodySmall!.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            labelStyle: theme.textTheme.bodyLarge!.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            hintStyle: theme.textTheme.bodyLarge!.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            icon: icon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
    );
  }
}

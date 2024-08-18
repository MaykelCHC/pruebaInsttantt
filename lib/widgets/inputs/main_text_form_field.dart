import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';

class MainTextFormField extends StatelessWidget {
  final AutovalidateMode? autovalidateMode;
  final bool autofocus;
  final bool obscureText;
  final bool readOnly;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? counterText;
  final String? Function(String?)? validator;
  final String? helperText;
  final String? hintText;
  final String? initialValue;
  final String? labelText;
  final TextCapitalization textCapitalization;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final Widget? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  const MainTextFormField(
      {super.key,
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
      this.onFieldSubmitted});
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

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../others/discrete_circle.dart';

/// Widget de botón primario personalizado.
class PrimaryButton extends StatelessWidget {
  /// Crea un botón primario con los parámetros especificados.
  ///
  /// Requiere [params], que contiene la configuración del botón.
  const PrimaryButton({
    super.key,
    required this.params,
  });

  /// Parámetros para configurar el botón primario.
  final PrimaryButtonParams params;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: SizedBox(
          height: params.height,
          width: params.width ?? size.width,
          child: FilledButton(
            style: ButtonStyle(
              shadowColor: WidgetStateColor.resolveWith(
                (states) => AppColors.onBackground.withOpacity(0.15),
              ),
              backgroundColor: WidgetStatePropertyAll(params.backgroundColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: BorderSide(
                    color: params.colorside,
                    width: params.sidewidth,
                    style: params.borderstyle,
                  ),
                  borderRadius: BorderRadius.circular(
                    params.borderRadius,
                  ),
                ),
              ),
            ),
            onPressed: params.onPressed,
            child: params.isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: DiscreteCircle(
                            color: AppColors.white,
                            secondCircleColor:
                                AppColors.white.withOpacity(0.20),
                            thirdCircleColor: AppColors.white.withOpacity(0.35),
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        params.title,
                        style: params.textStyle ?? theme.textTheme.labelLarge,
                      ),
                    ],
                  )
                : params.isRowIcon
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (params.isRowIcon)
                            Icon(
                              params.icon,
                              color: params.iconColor,
                              size: 18,
                            ),
                          if (params.isRowIcon)
                            const SizedBox(
                              width: 5,
                            ),
                          Text(
                            params.title,
                            style: params.textStyle ??
                                theme.textTheme.labelLarge!.copyWith(
                                  color: AppColors.onSurface.withOpacity(0.12),
                                ),
                          ),
                        ],
                      )
                    : Text(
                        params.title,
                        style: params.textStyle ??
                            theme.textTheme.labelLarge!.copyWith(
                              color: AppColors.onSurface.withOpacity(0.12),
                            ),
                      ),
          ),
        ),
      ),
    );
  }
}

/// Clase que define los parámetros para el botón primario.
///
/// Los parámetros permiten configurar el estilo, el comportamiento y la apariencia del botón.
class PrimaryButtonParams {
  /// Crea una instancia de [PrimaryButtonParams].
  ///
  /// Requiere [title], que es el texto que se muestra en el botón.
  /// Todos los demás parámetros son opcionales y tienen valores predeterminados.
  const PrimaryButtonParams({
    this.onPressed,
    this.iconColor,
    this.sizeIcon = 24,
    required this.title,
    this.borderRadius = 4,
    this.width,
    this.backgroundColor,
    this.height = 50,
    this.isRowIcon = false,
    this.icon = Icons.question_answer,
    this.textStyle,
    this.borderstyle = BorderStyle.solid,
    this.colorside = Colors.transparent,
    this.sidewidth = 0,
    this.isLoading = false,
  });

  /// Función que se llama cuando se presiona el botón.
  final Function()? onPressed;

  /// Texto que se muestra en el botón.
  final String title;

  /// Estilo del texto del botón.
  final TextStyle? textStyle;

  /// Estilo del borde del botón.
  final BorderStyle borderstyle;

  /// Indica si el botón debe mostrar un ícono junto al texto.
  final bool isRowIcon;

  /// Ícono que se muestra junto al texto si [isRowIcon] es `true`.
  final IconData icon;

  /// Indica si el botón está en estado de carga.
  final bool isLoading;

  /// Radio de borde del botón.
  final double borderRadius;

  /// Ancho del botón.
  final double? width;

  /// Alto del botón.
  final double? height;

  /// Tamaño del ícono.
  final double? sizeIcon;

  /// Ancho del borde del botón.
  final double sidewidth;

  /// Color de fondo del botón.
  final Color? backgroundColor;

  /// Color del ícono.
  final Color? iconColor;

  /// Color del borde del botón.
  final Color colorside;
}

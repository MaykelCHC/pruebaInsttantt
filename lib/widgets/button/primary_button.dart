import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../others/discrete_circle.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.params,
  });
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

class PrimaryButtonParams {
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
  final Function()? onPressed;
  final String title;
  final TextStyle? textStyle;
  final BorderStyle borderstyle;

  final bool isRowIcon;
  final IconData icon;
  final bool isLoading;

  final double borderRadius;
  final double? width;
  final double? height;
  final double? sizeIcon;
  final double sidewidth;

  final Color? backgroundColor;
  final Color? iconColor;
  final Color colorside;
}

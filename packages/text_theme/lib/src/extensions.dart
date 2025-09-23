import 'package:flutter/material.dart';
import 'package:format_ecran_package/format_ecran_package.dart';

extension TextThemeX on TextTheme {
  TextStyle? body(BuildContext context) => context.isMobile
      ? bodySmall
      : context.isTabletOrDesktop
          ? bodyLarge
          : bodyLarge;

  TextStyle? display(BuildContext context) => context.isMobile
      ? displaySmall
      : context.isTabletOrDesktop
          ? displayLarge
          : displayLarge;

  TextStyle? label(BuildContext context) => context.isMobile
      ? labelSmall
      : context.isTabletOrDesktop
          ? labelLarge
          : labelLarge;

  TextStyle? title(BuildContext context) => context.isMobile
      ? titleSmall
      : context.isTabletOrDesktop
          ? titleLarge
          : titleLarge;
}

import 'package:flutter/widgets.dart';

extension BuildContextX on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 480;

  bool get isTablet =>
      MediaQuery.of(this).size.width >= 480 &&
      MediaQuery.of(this).size.width < 1280;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1280;

  bool get isTabletOrDesktop => isTablet || isDesktop;
}

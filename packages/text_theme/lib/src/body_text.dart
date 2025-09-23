import 'package:flutter/material.dart';
import 'package:format_ecran_package/format_ecran_package.dart';

class BodyText extends StatelessWidget {
  const BodyText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: style ??
          (context.isMobile
              ? Theme.of(context).textTheme.bodySmall
              : context.isTabletOrDesktop
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyLarge),
    );
  }
}

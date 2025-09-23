import 'package:flutter/material.dart';
import 'package:format_ecran_package/format_ecran_package.dart';

class LabelText extends StatelessWidget {
  const LabelText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final TextOverflow? overflow;
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style ??
          (context.isMobile
              ? Theme.of(context).textTheme.labelSmall
              : context.isTabletOrDesktop
                  ? Theme.of(context).textTheme.labelLarge
                  : Theme.of(context).textTheme.labelLarge),
    );
  }

  LabelText copyWith({
    String? data,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return LabelText(
      data ?? this.data,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      maxLines: maxLines ?? this.maxLines,
    );
  }
}

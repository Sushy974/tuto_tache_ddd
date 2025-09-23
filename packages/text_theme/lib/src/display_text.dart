import 'package:flutter/material.dart';
import 'package:format_ecran_package/format_ecran_package.dart';

class DisplayText extends StatelessWidget {
  const DisplayText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });

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
      style: style ??
          (context.isMobile
              ? Theme.of(context).textTheme.displaySmall
              : context.isTabletOrDesktop
                  ? Theme.of(context).textTheme.displayLarge
                  : Theme.of(context).textTheme.displayLarge),
    );
  }

  DisplayText copyWith({
    String? data,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return DisplayText(
      data ?? this.data,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      maxLines: maxLines ?? this.maxLines,
    );
  }
}

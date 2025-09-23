import 'package:flutter/material.dart';
import 'package:text_theme/text_theme.dart';

class BoutonPillule extends StatelessWidget {
  const BoutonPillule({
    required this.libelle,
    required this.estActif,
    required this.onPressed,
    super.key,
  });

  final String libelle;
  final bool estActif;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actifStyle = FilledButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      shape: const StadiumBorder(),
    );
    final inactifStyle = FilledButton.styleFrom(
      backgroundColor: theme.colorScheme.secondaryContainer,
      foregroundColor: theme.colorScheme.onSecondaryContainer,
      shape: const StadiumBorder(),
    );

    return FilledButton(
      style: estActif ? actifStyle : inactifStyle,
      onPressed: onPressed,
      child: LabelText(libelle),
    );
  }
}

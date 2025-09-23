import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_theme/text_theme.dart';
import 'package:tuto_tache_ddd/l10n/l10n.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_bloc.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_event.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_state.dart';

class CarteTache extends StatelessWidget {
  const CarteTache({required this.item, super.key});

  final TacheItemUi item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final priorite = _prioriteDepuisCle(l10n, item.prioriteCle);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(item.titre),
            const SizedBox(height: 8),
            BodyText(l10n.listeTachesEcheance(item.dateTexte)),
            const SizedBox(height: 4),
            LabelText(l10n.listeTachesPriorite(priorite)),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: () => context.read<ListeTachesBloc>().add(
                    ListeTachesEditionDemandee(item.identifiant),
                  ),
                  child: LabelText(l10n.listeTachesModifier),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => context.read<ListeTachesBloc>().add(
                    ListeTachesSuppressionDemandee(item.identifiant),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                  child: LabelText(l10n.listeTachesSupprimer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _prioriteDepuisCle(AppLocalizations l10n, String cle) {
    switch (cle) {
      case 'prioriteElevee':
        return l10n.prioriteElevee;
      case 'prioriteMoyenne':
        return l10n.prioriteMoyenne;
      case 'prioriteFaible':
        return l10n.prioriteFaible;
      default:
        return '';
    }
  }
}

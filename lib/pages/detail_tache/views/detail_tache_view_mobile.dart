import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:text_theme/text_theme.dart';
import 'package:tuto_tache_ddd/l10n/l10n.dart';
import 'package:tuto_tache_ddd/pages/detail_tache/bloc/detail_tache_bloc.dart';
import 'package:tuto_tache_ddd/pages/detail_tache/bloc/detail_tache_event.dart';
import 'package:tuto_tache_ddd/pages/detail_tache/bloc/detail_tache_state.dart';

class DetailTacheViewMobile extends StatelessWidget {
  const DetailTacheViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: TitleText(l10n.detailTacheTitrePage),
      ),
      body: BlocBuilder<DetailTacheBloc, DetailTacheState>(
        builder: (context, state) {
          if (state.status == FormzSubmissionStatus.inProgress &&
              state.tache == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state.status == FormzSubmissionStatus.failure) {
            return Center(child: BodyText(l10n.detailTacheErreur));
          }
          final tache = state.tache;
          if (tache == null) {
            return const SizedBox.shrink();
          }
          final priorite = _prioriteDepuisCle(l10n, tache.prioriteCle);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(tache.titre),
                const SizedBox(height: 12),
                BodyText(tache.description),
                const SizedBox(height: 16),
                BodyText(l10n.detailTacheEcheance(tache.dateTexte)),
                const SizedBox(height: 4),
                LabelText(l10n.detailTachePriorite(priorite)),
                const SizedBox(height: 24),
                SwitchListTile.adaptive(
                  value: tache.estComplete,
                  onChanged: (valeur) => context.read<DetailTacheBloc>().add(
                    DetailTacheBasculerStatut(complet: valeur),
                  ),
                  title: LabelText(l10n.detailTacheStatutLabel),
                ),
                const Spacer(),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => context.read<DetailTacheBloc>().add(
                        const DetailTacheSuppressionDemandee(),
                      ),
                      child: LabelText(l10n.detailTacheSupprimer),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: LabelText(l10n.detailTacheModifier),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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

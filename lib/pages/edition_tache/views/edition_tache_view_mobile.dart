import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:text_theme/text_theme.dart';
import 'package:tuto_tache_ddd/inputs/priorite_tache_input.dart';
import 'package:tuto_tache_ddd/l10n/l10n.dart';
import 'package:tuto_tache_ddd/pages/edition_tache/bloc/edition_tache_bloc.dart';
import 'package:tuto_tache_ddd/pages/edition_tache/bloc/edition_tache_event.dart';
import 'package:tuto_tache_ddd/pages/edition_tache/bloc/edition_tache_state.dart';

class EditionTacheViewMobile extends StatelessWidget {
  const EditionTacheViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<EditionTacheBloc>();

    return Scaffold(
      appBar: AppBar(
        title: TitleText(l10n.editionTacheTitrePage),
      ),
      body: BlocBuilder<EditionTacheBloc, EditionTacheState>(
        builder: (context, state) {
          final estEnCours = state.status == FormzSubmissionStatus.inProgress;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelText(l10n.editionTacheTitreChamp),
                const SizedBox(height: 8),
                TextField(
                  enabled: !estEnCours,
                  onChanged: (valeur) =>
                      bloc.add(EditionTacheTitreChange(valeur)),
                  decoration: InputDecoration(
                    hintText: l10n.editionTacheHintTitre,
                    errorText: _texteErreur(l10n, state.titre.error),
                  ),
                ),
                const SizedBox(height: 16),
                LabelText(l10n.editionTacheDescriptionChamp),
                const SizedBox(height: 8),
                TextField(
                  enabled: !estEnCours,
                  minLines: 3,
                  maxLines: 5,
                  onChanged: (valeur) =>
                      bloc.add(EditionTacheDescriptionChange(valeur)),
                  decoration: InputDecoration(
                    hintText: l10n.editionTacheHintDescription,
                    errorText: _texteErreur(l10n, state.description.error),
                  ),
                ),
                const SizedBox(height: 16),
                LabelText(l10n.editionTacheDateChamp),
                const SizedBox(height: 8),
                TextField(
                  enabled: !estEnCours,
                  onChanged: (valeur) =>
                      bloc.add(EditionTacheDateChange(valeur)),
                  decoration: InputDecoration(
                    hintText: l10n.editionTacheHintDate,
                    errorText: _texteErreur(l10n, state.dateEcheance.error),
                  ),
                ),
                const SizedBox(height: 16),
                LabelText(l10n.editionTachePrioriteChamp),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: PrioriteTacheUi.values
                      .map(
                        (priorite) => ChoiceChip(
                          label: LabelText(
                            _textePriorite(l10n, priorite),
                          ),
                          selected: state.priorite.value == priorite,
                          onSelected: estEnCours
                              ? null
                              : (_) => bloc.add(
                                  EditionTachePrioriteChange(priorite),
                                ),
                        ),
                      )
                      .toList(),
                ),
                if (!state.priorite.isValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: BodyText(
                      _texteErreur(l10n, state.priorite.error) ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    FilledButton(
                      onPressed: estEnCours
                          ? null
                          : () => bloc.add(const EditionTacheSoumise()),
                      child: LabelText(l10n.editionTacheEnregistrer),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: estEnCours
                          ? null
                          : () => Navigator.of(context).maybePop(),
                      child: LabelText(l10n.editionTacheAnnuler),
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

  String? _texteErreur(AppLocalizations l10n, String? cle) {
    switch (cle) {
      case 'erreurTitreObligatoire':
        return l10n.erreurTitreObligatoire;
      case 'erreurDescriptionObligatoire':
        return l10n.erreurDescriptionObligatoire;
      case 'erreurDateInvalide':
        return l10n.erreurDateInvalide;
      case 'erreurPrioriteObligatoire':
        return l10n.erreurPrioriteObligatoire;
      default:
        return null;
    }
  }

  String _textePriorite(AppLocalizations l10n, PrioriteTacheUi priorite) {
    switch (priorite) {
      case PrioriteTacheUi.elevee:
        return l10n.prioriteElevee;
      case PrioriteTacheUi.moyenne:
        return l10n.prioriteMoyenne;
      case PrioriteTacheUi.faible:
        return l10n.prioriteFaible;
    }
  }
}

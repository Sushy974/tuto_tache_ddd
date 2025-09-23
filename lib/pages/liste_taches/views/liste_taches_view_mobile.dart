import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:text_theme/text_theme.dart';
import 'package:tuto_tache_ddd/l10n/l10n.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_bloc.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_event.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_state.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/widgets/carte_tache.dart';
import 'package:tuto_tache_ddd/shared/widgets/bouton_pillule.dart';

class ListeTachesViewMobile extends StatelessWidget {
  const ListeTachesViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: TitleText(l10n.listeTachesTitre),
      ),
      body: BlocBuilder<ListeTachesBloc, ListeTachesState>(
        builder: (context, state) {
          if (state.status == FormzSubmissionStatus.inProgress) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state.status == FormzSubmissionStatus.failure) {
            return Center(child: BodyText(l10n.listeTachesErreur));
          }
          if (state.estVide) {
            return Center(child: BodyText(l10n.listeTachesVide));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = state.taches[index];
              return CarteTache(item: item);
            },
            separatorBuilder: (context, _) => const SizedBox(height: 12),
            itemCount: state.taches.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ListeTachesBloc>().add(
          const ListeTachesCreationDemandee(),
        ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: BlocBuilder<ListeTachesBloc, ListeTachesState>(
            buildWhen: (previous, current) =>
                previous.estFiltreTerminees != current.estFiltreTerminees,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BoutonPillule(
                    libelle: l10n.listeTachesEnCours,
                    estActif: !state.estFiltreTerminees,
                    onPressed: () => context.read<ListeTachesBloc>().add(
                      const ListeTachesFiltreChange(afficherTerminees: false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BoutonPillule(
                    libelle: l10n.listeTachesTerminees,
                    estActif: state.estFiltreTerminees,
                    onPressed: () => context.read<ListeTachesBloc>().add(
                      const ListeTachesFiltreChange(afficherTerminees: true),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_event.dart';
import 'package:tuto_tache_ddd/pages/liste_taches/bloc/liste_taches_state.dart';

class ListeTachesBloc extends Bloc<ListeTachesEvent, ListeTachesState> {
  ListeTachesBloc() : super(const ListeTachesState()) {
    on<ListeTachesDemarre>(_onDemarre);
    on<ListeTachesFiltreChange>(_onFiltreChange);
    on<ListeTachesChargerPlus>(_onChargerPlus);
    on<ListeTachesEditionDemandee>(_onEditionDemandee);
    on<ListeTachesSuppressionDemandee>(_onSuppressionDemandee);
    on<ListeTachesCreationDemandee>(_onCreationDemandee);
  }

  Future<void> _onDemarre(
    ListeTachesDemarre event,
    Emitter<ListeTachesState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // TODO(app): charger la liste des taches via le domaine.
  }

  void _onFiltreChange(
    ListeTachesFiltreChange event,
    Emitter<ListeTachesState> emit,
  ) {
    // TODO(app): filtrer la liste selon event.afficherTerminees.
  }

  Future<void> _onChargerPlus(
    ListeTachesChargerPlus event,
    Emitter<ListeTachesState> emit,
  ) async {
    // TODO(app): appliquer la pagination sur la liste des taches.
  }

  void _onEditionDemandee(
    ListeTachesEditionDemandee event,
    Emitter<ListeTachesState> emit,
  ) {
    // TODO(app): declencher la navigation vers l'ecran d'edition.
  }

  void _onSuppressionDemandee(
    ListeTachesSuppressionDemandee event,
    Emitter<ListeTachesState> emit,
  ) {
    // TODO(app): demander la confirmation de suppression via le domaine.
  }

  void _onCreationDemandee(
    ListeTachesCreationDemandee event,
    Emitter<ListeTachesState> emit,
  ) {
    // TODO(app): ouvrir l'ecran de creation de tache.
  }
}

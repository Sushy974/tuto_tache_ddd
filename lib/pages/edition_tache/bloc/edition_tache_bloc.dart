import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:tuto_tache_ddd/inputs/date_echeance_input.dart';
import 'package:tuto_tache_ddd/inputs/description_tache_input.dart';
import 'package:tuto_tache_ddd/inputs/priorite_tache_input.dart';
import 'package:tuto_tache_ddd/inputs/titre_tache_input.dart';

import 'package:tuto_tache_ddd/pages/edition_tache/bloc/edition_tache_event.dart';
import 'package:tuto_tache_ddd/pages/edition_tache/bloc/edition_tache_state.dart';

class EditionTacheBloc extends Bloc<EditionTacheEvent, EditionTacheState> {
  EditionTacheBloc() : super(const EditionTacheState()) {
    on<EditionTacheInitialisee>(_onInitialisee);
    on<EditionTacheTitreChange>(_onTitreChange);
    on<EditionTacheDescriptionChange>(_onDescriptionChange);
    on<EditionTacheDateChange>(_onDateChange);
    on<EditionTachePrioriteChange>(_onPrioriteChange);
    on<EditionTacheSoumise>(_onSoumise);
  }

  void _onInitialisee(
    EditionTacheInitialisee event,
    Emitter<EditionTacheState> emit,
  ) {
    // TODO(app): charger les donnees initiales si necessaire.
  }

  void _onTitreChange(
    EditionTacheTitreChange event,
    Emitter<EditionTacheState> emit,
  ) {
    emit(state.copyWith(titre: TitreTacheInput.dirty(event.valeur)));
  }

  void _onDescriptionChange(
    EditionTacheDescriptionChange event,
    Emitter<EditionTacheState> emit,
  ) {
    emit(
      state.copyWith(description: DescriptionTacheInput.dirty(event.valeur)),
    );
  }

  void _onDateChange(
    EditionTacheDateChange event,
    Emitter<EditionTacheState> emit,
  ) {
    emit(state.copyWith(dateEcheance: DateEcheanceInput.dirty(event.valeur)));
  }

  void _onPrioriteChange(
    EditionTachePrioriteChange event,
    Emitter<EditionTacheState> emit,
  ) {
    emit(state.copyWith(priorite: PrioriteTacheInput.dirty(event.priorite)));
  }

  Future<void> _onSoumise(
    EditionTacheSoumise event,
    Emitter<EditionTacheState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // TODO(app): appeler le cas d'usage de creation ou mise a jour.
  }
}

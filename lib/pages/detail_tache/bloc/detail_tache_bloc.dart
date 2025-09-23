import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:tuto_tache_ddd/pages/detail_tache/bloc/detail_tache_event.dart';
import 'package:tuto_tache_ddd/pages/detail_tache/bloc/detail_tache_state.dart';

class DetailTacheBloc extends Bloc<DetailTacheEvent, DetailTacheState> {
  DetailTacheBloc() : super(const DetailTacheState()) {
    on<DetailTacheCharge>(_onCharge);
    on<DetailTacheBasculerStatut>(_onBasculerStatut);
    on<DetailTacheSuppressionDemandee>(_onSuppressionDemandee);
  }

  Future<void> _onCharge(
    DetailTacheCharge event,
    Emitter<DetailTacheState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    // TODO(app): charger le detail de la tache via le domaine.
  }

  Future<void> _onBasculerStatut(
    DetailTacheBasculerStatut event,
    Emitter<DetailTacheState> emit,
  ) async {
    // TODO(app): basculer le statut de la tache via le domaine.
  }

  Future<void> _onSuppressionDemandee(
    DetailTacheSuppressionDemandee event,
    Emitter<DetailTacheState> emit,
  ) async {
    // TODO(app): demander la suppression via le domaine.
  }
}

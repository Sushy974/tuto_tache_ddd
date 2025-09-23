import 'package:equatable/equatable.dart';

class ErreurTache extends Equatable {
  final String code;

  const ErreurTache._(this.code);

  static const ErreurTache tacheIntrouvable = ErreurTache._(
    'tache_introuvable',
  );
  static const ErreurTache transitionStatutInvalide = ErreurTache._(
    'transition_statut_invalide',
  );
  static const ErreurTache delaiSuppressionNonAtteint = ErreurTache._(
    'delai_suppression_non_atteint',
  );
  static const ErreurTache erreurTechnique = ErreurTache._(
    'erreur_technique',
  );

  @override
  List<Object?> get props => [code];
}

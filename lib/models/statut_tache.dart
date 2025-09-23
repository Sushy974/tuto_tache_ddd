import 'package:equatable/equatable.dart';

class StatutTache extends Equatable {
  final String valeur;

  const StatutTache._(this.valeur);

  static const StatutTache aFaire = StatutTache._('a_faire');
  static const StatutTache enCours = StatutTache._('en_cours');
  static const StatutTache terminee = StatutTache._('terminee');

  bool peutPasserVers(StatutTache cible) {
    if (this == cible) {
      return true;
    }
    if (this == StatutTache.aFaire) {
      return cible == StatutTache.enCours;
    }
    if (this == StatutTache.enCours) {
      return cible == StatutTache.terminee;
    }
    return false;
  }

  @override
  List<Object?> get props => [valeur];
}

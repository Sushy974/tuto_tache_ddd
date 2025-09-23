import '../core/horloge.dart';
import '../core/resultat.dart';
import '../errors/erreur_tache.dart';
import '../models/identifiant_tache.dart';
import '../models/statut_tache.dart';
import '../models/tache.dart';
import '../repositories/tache_repository.dart';

class ModifierTacheCommande {
  final IdentifiantTache identifiant;
  final String? titre;
  final String? description;
  final StatutTache? statut;
  const ModifierTacheCommande({
    required this.identifiant,
    this.titre,
    this.description,
    this.statut,
  });
}

class ModifierTacheUsecase {
  final TacheRepository _repository;
  final Horloge _horloge;
  ModifierTacheUsecase({
    required TacheRepository repository,
    required Horloge horloge,
  }) : _repository = repository,
       _horloge = horloge;
  Future<Resultat<Tache, ErreurTache>> executer(
    ModifierTacheCommande commande,
  ) async {
    final resultatTache = await _repository.obtenirParIdentifiant(
      commande.identifiant,
    );
    if (resultatTache.estErreur) {
      return Resultat.echec(resultatTache.erreur!);
    }
    final tacheActuelle = resultatTache.valeur!;
    final nouveauStatut = commande.statut ?? tacheActuelle.statut;
    if (!tacheActuelle.statut.peutPasserVers(nouveauStatut)) {
      return Resultat.echec(ErreurTache.transitionStatutInvalide);
    }
    final maintenant = _horloge.maintenant();
    final tacheModifiee = tacheActuelle.copyWith(
      titre: commande.titre ?? tacheActuelle.titre,
      description: commande.description ?? tacheActuelle.description,
      statut: nouveauStatut,
      dateModification: maintenant,
    );
    return _repository.sauvegarder(tacheModifiee);
  }
}

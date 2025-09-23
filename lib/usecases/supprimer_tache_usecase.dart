import '../core/horloge.dart';
import '../core/resultat.dart';
import '../errors/erreur_tache.dart';
import '../models/identifiant_tache.dart';
import '../repositories/tache_repository.dart';

class SupprimerTacheCommande {
  final IdentifiantTache identifiant;
  const SupprimerTacheCommande({
    required this.identifiant,
  });
}

class SupprimerTacheUsecase {
  final TacheRepository _repository;
  final Horloge _horloge;
  SupprimerTacheUsecase({
    required TacheRepository repository,
    required Horloge horloge,
  }) : _repository = repository,
       _horloge = horloge;
  Future<Resultat<bool, ErreurTache>> executer(
    SupprimerTacheCommande commande,
  ) async {
    final resultatTache = await _repository.obtenirParIdentifiant(
      commande.identifiant,
    );
    if (resultatTache.estErreur) {
      return Resultat.echec(resultatTache.erreur!);
    }
    final tache = resultatTache.valeur!;
    final maintenant = _horloge.maintenant();
    final delaiAutorise = tache.dateCreation.add(const Duration(days: 30));
    if (!maintenant.isAfter(delaiAutorise)) {
      return Resultat.echec(ErreurTache.delaiSuppressionNonAtteint);
    }
    return _repository.supprimer(commande.identifiant);
  }
}

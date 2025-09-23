import '../core/fabrique_identifiant_tache.dart';
import '../core/horloge.dart';
import '../core/resultat.dart';
import '../errors/erreur_tache.dart';
import '../models/statut_tache.dart';
import '../models/tache.dart';
import '../repositories/tache_repository.dart';

class CreerTacheCommande {
  final String titre;
  final String description;

  const CreerTacheCommande({
    required this.titre,
    required this.description,
  });
}

class CreerTacheUsecase {
  final TacheRepository _repository;
  final Horloge _horloge;
  final FabriqueIdentifiantTache _fabriqueIdentifiant;

  CreerTacheUsecase({
    required TacheRepository repository,
    required Horloge horloge,
    required FabriqueIdentifiantTache fabriqueIdentifiant,
  }) : _repository = repository,
       _horloge = horloge,
       _fabriqueIdentifiant = fabriqueIdentifiant;

  Future<Resultat<Tache, ErreurTache>> executer(
    CreerTacheCommande commande,
  ) async {
    final identifiant = _fabriqueIdentifiant.generer();
    final maintenant = _horloge.maintenant();
    final tache = Tache(
      identifiant: identifiant,
      titre: commande.titre,
      description: commande.description,
      dateCreation: maintenant,
      dateModification: maintenant,
      statut: StatutTache.aFaire,
    );
    return _repository.creer(tache);
  }
}

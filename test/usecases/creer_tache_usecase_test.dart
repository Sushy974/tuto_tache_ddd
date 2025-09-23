import 'package:test/test.dart';

import 'package:tuto_tache_ddd/core/fabrique_identifiant_tache.dart';
import 'package:tuto_tache_ddd/core/horloge.dart';
import 'package:tuto_tache_ddd/core/resultat.dart';
import 'package:tuto_tache_ddd/errors/erreur_tache.dart';
import 'package:tuto_tache_ddd/models/identifiant_tache.dart';
import 'package:tuto_tache_ddd/models/statut_tache.dart';
import 'package:tuto_tache_ddd/models/tache.dart';
import 'package:tuto_tache_ddd/repositories/tache_repository.dart';
import 'package:tuto_tache_ddd/usecases/creer_tache_usecase.dart';

// -----------------------------------------------------------------------------
// TDD pas-a-pas :
// 1) Ecrire le test (RED)
// 2) Impl GREEN la logique minimale
// 3) Refactoriser (noms revelateurs, Equatable/copyWith, extractions)
// 4) Relancer les tests (doivent rester GREEN)
// 5) Preparer les commits Git : test(...), feat(...)
// -----------------------------------------------------------------------------
void main() {
  group('Fonctionnalite : Gestion des taches', () {
    late _Fixture fixture;

    setUp(() {
      fixture = _Fixture();
    });

    test(
      'Cas d\'utilisation : Creation (cas nominal)',
      () async {
        // -------------------------------------------------------------------
        // Fonctionnalite : Creation de tache
        // Scenario : Creation reussie d\'une tache
        // etantDonne une demande valide avec titre et description
        // lorsque j\'execute le cas d\'utilisation de creation
        // alors la tache est persistee avec statut a faire et dates coherentes
        // -------------------------------------------------------------------
        fixture.etantDonneHorlogeFixe(DateTime(2024, 5, 20, 10));
        fixture.etantDonneFabriqueIdentifiant(
          const IdentifiantTache('tache-123'),
        );
        final commande = const CreerTacheCommande(
          titre: 'Preparer la reunion',
          description: 'Lister les points a aborder',
        );

        final resultat = await fixture.lorsqueJeCreeUneTache(commande);

        fixture.alorsLaTacheEstPersistee(
          resultat,
          identifiantAttendu: const IdentifiantTache('tache-123'),
          titreAttendu: 'Preparer la reunion',
          descriptionAttendue: 'Lister les points a aborder',
          horodatageAttendu: DateTime(2024, 5, 20, 10),
          statutAttendu: StatutTache.aFaire,
        );
      },
    );
  });
}

class _Fixture {
  late TacheRepositoryMemoire _repository;
  late HorlogeFixe _horloge;
  late FabriqueIdentifiantTacheFixe _fabrique;

  _Fixture() {
    _repository = TacheRepositoryMemoire();
    _horloge = HorlogeFixe(DateTime(2024, 1, 1));
    _fabrique = FabriqueIdentifiantTacheFixe(
      const IdentifiantTache('tache-par-defaut'),
    );
  }

  void etantDonneHorlogeFixe(DateTime instant) {
    _horloge = HorlogeFixe(instant);
  }

  void etantDonneFabriqueIdentifiant(IdentifiantTache identifiant) {
    _fabrique = FabriqueIdentifiantTacheFixe(identifiant);
  }

  Future<Resultat<Tache, ErreurTache>> lorsqueJeCreeUneTache(
    CreerTacheCommande commande,
  ) {
    final usecase = CreerTacheUsecase(
      repository: _repository,
      horloge: _horloge,
      fabriqueIdentifiant: _fabrique,
    );
    return usecase.executer(commande);
  }

  Future<void> alorsLaTacheEstPersistee(
    Resultat<Tache, ErreurTache> resultat, {
    required IdentifiantTache identifiantAttendu,
    required String titreAttendu,
    required String descriptionAttendue,
    required DateTime horodatageAttendu,
    required StatutTache statutAttendu,
  }) async {
    expect(resultat.estSucces, isTrue);
    final tacheCree = resultat.valeur!;
    expect(tacheCree.identifiant, identifiantAttendu);
    expect(tacheCree.titre, titreAttendu);
    expect(tacheCree.description, descriptionAttendue);
    expect(tacheCree.dateCreation, horodatageAttendu);
    expect(tacheCree.dateModification, horodatageAttendu);
    expect(tacheCree.statut, statutAttendu);

    final lecture = await _repository.obtenirParIdentifiant(identifiantAttendu);
    expect(lecture.estSucces, isTrue);
    expect(lecture.valeur, tacheCree);
  }
}

class HorlogeFixe implements Horloge {
  final DateTime fixedNow;

  HorlogeFixe(this.fixedNow);

  @override
  DateTime maintenant() {
    return fixedNow;
  }
}

class FabriqueIdentifiantTacheFixe implements FabriqueIdentifiantTache {
  final IdentifiantTache _identifiant;

  FabriqueIdentifiantTacheFixe(this._identifiant);

  @override
  IdentifiantTache generer() {
    return _identifiant;
  }
}

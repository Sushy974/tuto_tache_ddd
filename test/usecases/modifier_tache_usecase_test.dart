import 'package:test/test.dart';

import 'package:tuto_tache_ddd/core/horloge.dart';
import 'package:tuto_tache_ddd/core/resultat.dart';
import 'package:tuto_tache_ddd/errors/erreur_tache.dart';
import 'package:tuto_tache_ddd/models/identifiant_tache.dart';
import 'package:tuto_tache_ddd/models/statut_tache.dart';
import 'package:tuto_tache_ddd/models/tache.dart';
import 'package:tuto_tache_ddd/repositories/tache_repository.dart';
import 'package:tuto_tache_ddd/usecases/modifier_tache_usecase.dart';

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
      'Cas d\'utilisation : Transition a faire vers en cours',
      () async {
        // -------------------------------------------------------------------
        // Fonctionnalite : Mise a jour d'une tache
        // Scenario : Passage d'une tache du statut a faire vers en cours
        // etantDonne une tache enregistree en statut a faire
        // lorsque je demande la transition vers en cours
        // alors la tache est mise a jour et horodatee a l'instant donne
        // -------------------------------------------------------------------
        final identifiant = const IdentifiantTache('tache-456');
        fixture.etantDonneHorlogeFixe(DateTime(2024, 6, 1, 9));
        await fixture.etantDonneTacheEnregistree(
          identifiant: identifiant,
          titre: 'Organiser la formation',
          description: 'Contacter les formateurs',
          statut: StatutTache.aFaire,
          dateCreation: DateTime(2024, 5, 20),
          dateModification: DateTime(2024, 5, 20),
        );

        final resultat = await fixture.lorsqueJeModifieLaTache(
          ModifierTacheCommande(
            identifiant: identifiant,
            statut: StatutTache.enCours,
          ),
        );

        await fixture.alorsLaTacheEstMiseAJour(
          resultat,
          identifiant: identifiant,
          nouveauStatut: StatutTache.enCours,
          horodatageAttendu: DateTime(2024, 6, 1, 9),
        );
      },
    );

    test(
      'Cas d\'utilisation : Transition interdite vers terminee',
      () async {
        // -------------------------------------------------------------------
        // Fonctionnalite : Mise a jour d'une tache
        // Scenario : Passage direct de a faire vers terminee interdit
        // etantDonne une tache enregistree en statut a faire
        // lorsque je demande la transition directe vers terminee
        // alors une erreur transition_statut_invalide est retournee
        // -------------------------------------------------------------------
        final identifiant = const IdentifiantTache('tache-789');
        fixture.etantDonneHorlogeFixe(DateTime(2024, 6, 1, 10));
        await fixture.etantDonneTacheEnregistree(
          identifiant: identifiant,
          titre: 'Clore le sprint',
          description: 'Organiser la retro',
          statut: StatutTache.aFaire,
          dateCreation: DateTime(2024, 5, 10),
          dateModification: DateTime(2024, 5, 15),
        );

        final resultat = await fixture.lorsqueJeModifieLaTache(
          ModifierTacheCommande(
            identifiant: identifiant,
            statut: StatutTache.terminee,
          ),
        );

        await fixture.alorsLaTransitionEstRefusee(
          resultat,
          identifiant: identifiant,
          statutInitial: StatutTache.aFaire,
          erreurAttendue: ErreurTache.transitionStatutInvalide,
        );
      },
    );
  });
}

class _Fixture {
  late TacheRepositoryMemoire _repository;
  late HorlogeFixe _horloge;

  _Fixture() {
    _repository = TacheRepositoryMemoire();
    _horloge = HorlogeFixe(DateTime(2024, 1, 1));
  }

  void etantDonneHorlogeFixe(DateTime instant) {
    _horloge = HorlogeFixe(instant);
  }

  Future<void> etantDonneTacheEnregistree({
    required IdentifiantTache identifiant,
    required String titre,
    required String description,
    required StatutTache statut,
    required DateTime dateCreation,
    required DateTime dateModification,
  }) async {
    final tache = TacheBuilder()
        .avecIdentifiant(identifiant.valeur)
        .avecTitre(titre)
        .avecDescription(description)
        .avecStatut(statut)
        .avecDateCreation(dateCreation)
        .avecDateModification(dateModification)
        .construire();
    await _repository.creer(tache);
  }

  Future<Resultat<Tache, ErreurTache>> lorsqueJeModifieLaTache(
    ModifierTacheCommande commande,
  ) {
    final usecase = ModifierTacheUsecase(
      repository: _repository,
      horloge: _horloge,
    );
    return usecase.executer(commande);
  }

  Future<void> alorsLaTacheEstMiseAJour(
    Resultat<Tache, ErreurTache> resultat, {
    required IdentifiantTache identifiant,
    required StatutTache nouveauStatut,
    required DateTime horodatageAttendu,
  }) async {
    expect(resultat.estSucces, isTrue);
    final tache = resultat.valeur!;
    expect(tache.identifiant, identifiant);
    expect(tache.statut, nouveauStatut);
    expect(tache.dateModification, horodatageAttendu);

    final lecture = await _repository.obtenirParIdentifiant(identifiant);
    expect(lecture.estSucces, isTrue);
    expect(lecture.valeur!.statut, nouveauStatut);
    expect(lecture.valeur!.dateModification, horodatageAttendu);
  }

  Future<void> alorsLaTransitionEstRefusee(
    Resultat<Tache, ErreurTache> resultat, {
    required IdentifiantTache identifiant,
    required StatutTache statutInitial,
    required ErreurTache erreurAttendue,
  }) async {
    expect(resultat.estErreur, isTrue);
    expect(resultat.erreur, erreurAttendue);
    final lecture = await _repository.obtenirParIdentifiant(identifiant);
    expect(lecture.estSucces, isTrue);
    expect(lecture.valeur!.statut, statutInitial);
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

import 'package:test/test.dart';

import 'package:tuto_tache_ddd/core/horloge.dart';
import 'package:tuto_tache_ddd/core/resultat.dart';
import 'package:tuto_tache_ddd/errors/erreur_tache.dart';
import 'package:tuto_tache_ddd/models/identifiant_tache.dart';
import 'package:tuto_tache_ddd/models/statut_tache.dart';
import 'package:tuto_tache_ddd/models/tache.dart';
import 'package:tuto_tache_ddd/repositories/tache_repository.dart';
import 'package:tuto_tache_ddd/usecases/supprimer_tache_usecase.dart';

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
      'Cas d\'utilisation : Suppression refusee avant 30 jours',
      () async {
        // -------------------------------------------------------------------
        // Fonctionnalite : Suppression conditionnelle
        // Scenario : Rejet tant que la tache a moins de 30 jours
        // etantDonne une tache creee il y a 10 jours
        // lorsque je tente de la supprimer
        // alors l\'erreur delai_suppression_non_atteint est retournee
        // -------------------------------------------------------------------
        final identifiant = const IdentifiantTache('tache-321');
        fixture.etantDonneHorlogeFixe(DateTime(2024, 7, 1));
        await fixture.etantDonneTacheEnregistree(
          identifiant: identifiant,
          statut: StatutTache.aFaire,
          dateCreation: fixture.horloge.fixedNow.subtract(
            const Duration(days: 10),
          ),
          dateModification: fixture.horloge.fixedNow.subtract(
            const Duration(days: 10),
          ),
        );

        final resultat = await fixture.lorsqueJeSupprimeLaTache(identifiant);

        await fixture.alorsLaSuppressionEstRefusee(
          resultat,
          identifiant: identifiant,
          erreurAttendue: ErreurTache.delaiSuppressionNonAtteint,
        );
      },
    );

    test(
      'Cas d\'utilisation : Suppression acceptee apres 30 jours',
      () async {
        // -------------------------------------------------------------------
        // Fonctionnalite : Suppression conditionnelle
        // Scenario : Autorisation lorsque la tache depasse 30 jours
        // etantDonne une tache creee il y a 40 jours
        // lorsque je la supprime
        // alors elle disparait du repository
        // -------------------------------------------------------------------
        final identifiant = const IdentifiantTache('tache-654');
        fixture.etantDonneHorlogeFixe(DateTime(2024, 7, 1));
        await fixture.etantDonneTacheEnregistree(
          identifiant: identifiant,
          statut: StatutTache.terminee,
          dateCreation: fixture.horloge.fixedNow.subtract(
            const Duration(days: 40),
          ),
          dateModification: fixture.horloge.fixedNow.subtract(
            const Duration(days: 20),
          ),
        );

        final resultat = await fixture.lorsqueJeSupprimeLaTache(identifiant);

        await fixture.alorsLaSuppressionReussit(
          resultat,
          identifiant: identifiant,
        );
      },
    );

    test(
      'Propriete : suppression autorisee uniquement au-dela de 30 jours',
      () async {
        // -------------------------------------------------------------------
        // Fonctionnalite : Suppression conditionnelle
        // Scenario : Validation de la propriete age_superieur_a_30_jours
        // etantDonne plusieurs ages de taches
        // lorsque je tente la suppression
        // alors elle reussit si et seulement si age > 30 jours
        // -------------------------------------------------------------------
        fixture.etantDonneHorlogeFixe(DateTime(2024, 7, 1));
        final cas = <int, bool>{
          5: false,
          29: false,
          30: false,
          31: true,
          60: true,
        };

        for (final entree in cas.entries) {
          final identifiant = IdentifiantTache('tache-${entree.key}');
          await fixture.etantDonneTacheEnregistree(
            identifiant: identifiant,
            statut: StatutTache.aFaire,
            dateCreation: fixture.horloge.fixedNow.subtract(
              Duration(days: entree.key),
            ),
            dateModification: fixture.horloge.fixedNow.subtract(
              Duration(days: entree.key),
            ),
          );

          final resultat = await fixture.lorsqueJeSupprimeLaTache(identifiant);

          expect(
            resultat.estSucces,
            entree.value,
            reason:
                'suppression attendue=${entree.value} pour age=${entree.key} jours',
          );
        }
      },
    );
  });
}

class _Fixture {
  late TacheRepositoryMemoire _repository;
  late HorlogeFixe horloge;

  _Fixture() {
    _repository = TacheRepositoryMemoire();
    horloge = HorlogeFixe(DateTime(2024, 1, 1));
  }

  void etantDonneHorlogeFixe(DateTime instant) {
    horloge = HorlogeFixe(instant);
  }

  Future<void> etantDonneTacheEnregistree({
    required IdentifiantTache identifiant,
    required StatutTache statut,
    required DateTime dateCreation,
    required DateTime dateModification,
  }) async {
    final tache = TacheBuilder()
        .avecIdentifiant(identifiant.valeur)
        .avecStatut(statut)
        .avecTitre('Titre ${identifiant.valeur}')
        .avecDescription('Description ${identifiant.valeur}')
        .avecDateCreation(dateCreation)
        .avecDateModification(dateModification)
        .construire();
    await _repository.creer(tache);
  }

  Future<Resultat<bool, ErreurTache>> lorsqueJeSupprimeLaTache(
    IdentifiantTache identifiant,
  ) {
    final usecase = SupprimerTacheUsecase(
      repository: _repository,
      horloge: horloge,
    );
    return usecase.executer(
      SupprimerTacheCommande(identifiant: identifiant),
    );
  }

  Future<void> alorsLaSuppressionEstRefusee(
    Resultat<bool, ErreurTache> resultat, {
    required IdentifiantTache identifiant,
    required ErreurTache erreurAttendue,
  }) async {
    expect(resultat.estErreur, isTrue);
    expect(resultat.erreur, erreurAttendue);
    final lecture = await _repository.obtenirParIdentifiant(identifiant);
    expect(lecture.estSucces, isTrue);
  }

  Future<void> alorsLaSuppressionReussit(
    Resultat<bool, ErreurTache> resultat, {
    required IdentifiantTache identifiant,
  }) async {
    expect(resultat.estSucces, isTrue);
    expect(resultat.valeur, isTrue);
    final lecture = await _repository.obtenirParIdentifiant(identifiant);
    expect(lecture.estErreur, isTrue);
    expect(lecture.erreur, ErreurTache.tacheIntrouvable);
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

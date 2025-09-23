import 'package:test/test.dart';

import 'package:tuto_tache_ddd/errors/erreur_tache.dart';
import 'package:tuto_tache_ddd/models/identifiant_tache.dart';
import 'package:tuto_tache_ddd/models/tache.dart';
import 'package:tuto_tache_ddd/repositories/tache_repository.dart';

// -----------------------------------------------------------------------------
// TDD pas-a-pas :
// 1) Ecrire le test (RED)
// 2) Impl GREEN la logique minimale
// 3) Refactoriser (noms revelateurs, Equatable/copyWith, extractions)
// 4) Relancer les tests (doivent rester GREEN)
// 5) Preparer les commits Git : test(...), feat(...)
// -----------------------------------------------------------------------------
void main() {
  group('Fonctionnalite : Acces au stockage des taches', () {
    late TacheRepository repository;

    setUp(() {
      repository = TacheRepositoryMemoire();
    });

    test('Contrat : consultation tache inexistante', () async {
      // -------------------------------------------------------------------
      // Fonctionnalite : Acces au stockage des taches
      // Scenario : Consultation d'une tache absente
      // etantDonne un repository vide
      // lorsque je recherche un identifiant inconnu
      // alors une erreur tache_introuvable est retournee
      // -------------------------------------------------------------------
      final resultat = await repository.obtenirParIdentifiant(
        const IdentifiantTache('absente'),
      );

      expect(resultat.estErreur, isTrue);
      expect(resultat.erreur, ErreurTache.tacheIntrouvable);
    });

    test('Contrat : sauvegarde remplace la tache', () async {
      // -------------------------------------------------------------------
      // Fonctionnalite : Acces au stockage des taches
      // Scenario : Sauvegarde d'une tache existante
      // etantDonne une tache deja enregistree
      // lorsque je la sauvegarde avec un nouveau titre
      // alors la version persistee est remplacee
      // -------------------------------------------------------------------
      final tacheInitiale = TacheBuilder()
          .avecIdentifiant('identifiant-1')
          .avecTitre('Ancien titre')
          .construire();
      await repository.creer(tacheInitiale);

      final tacheMiseAJour = tacheInitiale.copyWith(titre: 'Nouveau titre');
      final resultat = await repository.sauvegarder(tacheMiseAJour);

      expect(resultat.estSucces, isTrue);
      expect(resultat.valeur!.titre, 'Nouveau titre');
      final lecture = await repository.obtenirParIdentifiant(
        const IdentifiantTache('identifiant-1'),
      );
      expect(lecture.valeur!.titre, 'Nouveau titre');
    });
  });
}

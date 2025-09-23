import 'package:test/test.dart';

import 'package:tuto_tache_ddd/models/identifiant_tache.dart';
import 'package:tuto_tache_ddd/models/statut_tache.dart';
import 'package:tuto_tache_ddd/models/tache.dart';

// -----------------------------------------------------------------------------
// TDD pas-a-pas :
// 1) Ecrire le test (RED)
// 2) Impl GREEN la logique minimale
// 3) Refactoriser (noms revelateurs, Equatable/copyWith, extractions)
// 4) Relancer les tests (doivent rester GREEN)
// 5) Preparer les commits Git : test(...), feat(...)
// -----------------------------------------------------------------------------
void main() {
  group('Fonctionnalite : Modele Tache', () {
    test('copyWith conserve les champs non modifies', () {
      // -----------------------------------------------------------------
      // Fonctionnalite : Modele Tache
      // Scenario : Clonage partiel avec copyWith
      // etantDonne une tache existante avec des attributs renseignes
      // lorsque je copie en changeant uniquement le titre
      // alors les autres attributs restent identiques
      // -----------------------------------------------------------------
      final tacheInitiale = Tache(
        identifiant: const IdentifiantTache('tache-1'),
        titre: 'Titre initial',
        description: 'Description initiale',
        dateCreation: DateTime(2024, 1, 1),
        dateModification: DateTime(2024, 1, 2),
        statut: StatutTache.aFaire,
      );

      final tacheModifiee = tacheInitiale.copyWith(titre: 'Nouveau titre');

      expect(tacheModifiee.identifiant, tacheInitiale.identifiant);
      expect(tacheModifiee.description, tacheInitiale.description);
      expect(tacheModifiee.dateCreation, tacheInitiale.dateCreation);
      expect(tacheModifiee.dateModification, tacheInitiale.dateModification);
      expect(tacheModifiee.statut, tacheInitiale.statut);
      expect(tacheModifiee.titre, 'Nouveau titre');
    });
  });
}

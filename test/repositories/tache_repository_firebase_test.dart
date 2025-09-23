import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tuto_tache_ddd/errors/erreur_tache.dart';
import 'package:tuto_tache_ddd/models/identifiant_tache.dart';
import 'package:tuto_tache_ddd/models/statut_tache.dart';
import 'package:tuto_tache_ddd/models/tache.dart';
import 'package:tuto_tache_ddd/repositories/tache_repository.dart';

class _MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class _MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  group('TacheRepositoryFirebase', () {
    test(
      'Fonctionnalité: Adapter Firebase des tâches — Scénario: Création réussie',
      () async {
        // Fonctionnalité: Adapter Firebase des tâches
        // Scénario: Création réussie
        // étantDonne un dépôt Firestore vide
        final firestore = FakeFirebaseFirestore();
        final repository = TacheRepositoryFirebase(
          collection: firestore.collection('taches'),
        );
        final tache = TacheBuilder()
            .avecIdentifiant('tache-creation')
            .avecTitre('Titre creation')
            .avecDescription('Description creation')
            .avecStatut(StatutTache.enCours)
            .construire();

        // lorsque on crée la tâche
        final resultat = await repository.creer(tache);

        // alors la tâche est persistée en succès
        expect(resultat.estSucces, isTrue);
        final document = await firestore
            .collection('taches')
            .doc(tache.identifiant.valeur)
            .get();
        expect(document.exists, isTrue);
        expect(document.data()?['titre'], 'Titre creation');
      },
    );

    test(
      'Fonctionnalité: Adapter Firebase des tâches — Scénario: Liste vide',
      () async {
        // Fonctionnalité: Adapter Firebase des tâches
        // Scénario: Liste vide
        // étantDonne un dépôt Firestore vide
        final firestore = FakeFirebaseFirestore();
        final repository = TacheRepositoryFirebase(
          collection: firestore.collection('taches'),
        );

        // lorsque on récupère les tâches
        final resultat = await repository.lister();

        // alors une liste vide est renvoyée en succès
        expect(resultat.estSucces, isTrue);
        expect(resultat.valeur, isEmpty);
      },
    );

    test(
      'Fonctionnalité: Adapter Firebase des tâches — Scénario: Lecture introuvable',
      () async {
        // Fonctionnalité: Adapter Firebase des tâches
        // Scénario: Lecture introuvable
        // étantDonne un dépôt Firestore vide
        final firestore = FakeFirebaseFirestore();
        final repository = TacheRepositoryFirebase(
          collection: firestore.collection('taches'),
        );

        // lorsque on récupère une tâche inexistante
        final resultat = await repository.obtenirParIdentifiant(
          const IdentifiantTache('absente'),
        );

        // alors une erreur métier tacheIntrouvable est renvoyée
        expect(resultat.estErreur, isTrue);
        expect(resultat.erreur, ErreurTache.tacheIntrouvable);
      },
    );

    test(
      'Fonctionnalité: Adapter Firebase des tâches — Scénario: Schéma invalide',
      () async {
        // Fonctionnalité: Adapter Firebase des tâches
        // Scénario: Schéma invalide
        // étantDonne un document Firestore incomplet
        final firestore = FakeFirebaseFirestore();
        await firestore.collection('taches').doc('mauvaise').set({
          'titre': 'Sans dates',
          'description': 'Doc incomplet',
          'statut': StatutTache.aFaire.valeur,
        });
        final repository = TacheRepositoryFirebase(
          collection: firestore.collection('taches'),
        );

        // lorsque on liste les tâches
        final resultat = await repository.lister();

        // alors une erreur technique est renvoyée
        expect(resultat.estErreur, isTrue);
        expect(resultat.erreur, ErreurTache.erreurTechnique);
      },
    );

    test(
      'Fonctionnalité: Adapter Firebase des tâches — Scénario: Mise à jour introuvable',
      () async {
        // Fonctionnalité: Adapter Firebase des tâches
        // Scénario: Mise à jour introuvable
        // étantDonne un dépôt Firestore sans la tâche cible
        final firestore = FakeFirebaseFirestore();
        final repository = TacheRepositoryFirebase(
          collection: firestore.collection('taches'),
        );
        final tache = TacheBuilder()
            .avecIdentifiant('manquante')
            .avecTitre('Titre MAJ')
            .construire();

        // lorsque on sauvegarde la tâche inexistante
        final resultat = await repository.sauvegarder(tache);

        // alors une erreur métier tacheIntrouvable est renvoyée
        expect(resultat.estErreur, isTrue);
        expect(resultat.erreur, ErreurTache.tacheIntrouvable);
      },
    );

    test(
      'Fonctionnalité: Adapter Firebase des tâches — Scénario: Suppression réussie',
      () async {
        // Fonctionnalité: Adapter Firebase des tâches
        // Scénario: Suppression réussie
        // étantDonne une tâche persistée
        final firestore = FakeFirebaseFirestore();
        final collection = firestore.collection('taches');
        final repository = TacheRepositoryFirebase(collection: collection);
        final tache = TacheBuilder()
            .avecIdentifiant('supprimer')
            .avecTitre('Titre à supprimer')
            .construire();
        await repository.creer(tache);

        // lorsque on supprime la tâche
        final resultat = await repository.supprimer(tache.identifiant);

        // alors la suppression réussit et le document disparaît
        expect(resultat.estSucces, isTrue);
        expect(resultat.valeur, isTrue);
        final existeEncore = await collection.doc('supprimer').get();
        expect(existeEncore.exists, isFalse);
      },
    );

    test(
      'Fonctionnalité: Adapter Firebase des tâches — Scénario: Erreur technique Firestore',
      () async {
        // Fonctionnalité: Adapter Firebase des tâches
        // Scénario: Erreur technique Firestore
        // étantDonne un client Firestore qui échoue
        final collection = _MockCollectionReference();
        final document = _MockDocumentReference();
        when(() => collection.doc(any())).thenReturn(document);
        when(() => document.set(any<Map<String, dynamic>>())).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
          ),
        );
        final repository = TacheRepositoryFirebase(collection: collection);
        final tache = TacheBuilder()
            .avecIdentifiant('erreur-technique')
            .avecTitre('Ne sera pas créé')
            .construire();

        // lorsque on tente de créer la tâche
        final resultat = await repository.creer(tache);

        // alors une erreur technique est renvoyée
        expect(resultat.estErreur, isTrue);
        expect(resultat.erreur, ErreurTache.erreurTechnique);
      },
    );
  });
}

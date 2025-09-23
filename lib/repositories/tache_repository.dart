import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/resultat.dart';
import '../errors/erreur_tache.dart';
import '../models/identifiant_tache.dart';
import '../models/statut_tache.dart';
import '../models/tache.dart';

abstract class TacheRepository {
  Future<Resultat<Tache, ErreurTache>> creer(Tache tache);
  Future<Resultat<Tache, ErreurTache>> obtenirParIdentifiant(
    IdentifiantTache identifiant,
  );
  Future<Resultat<List<Tache>, ErreurTache>> lister();
  Future<Resultat<Tache, ErreurTache>> sauvegarder(Tache tache);
  Future<Resultat<bool, ErreurTache>> supprimer(IdentifiantTache identifiant);
}

class TacheRepositoryMemoire implements TacheRepository {
  final Map<IdentifiantTache, Tache> _taches = {};
  @override
  Future<Resultat<Tache, ErreurTache>> creer(Tache tache) async {
    _taches[tache.identifiant] = tache;
    return Resultat.succes(tache);
  }

  @override
  Future<Resultat<List<Tache>, ErreurTache>> lister() async {
    return Resultat.succes(List.unmodifiable(_taches.values));
  }

  @override
  Future<Resultat<Tache, ErreurTache>> obtenirParIdentifiant(
    IdentifiantTache identifiant,
  ) async {
    final tache = _taches[identifiant];
    if (tache == null) {
      return Resultat.echec(ErreurTache.tacheIntrouvable);
    }
    return Resultat.succes(tache);
  }

  @override
  Future<Resultat<Tache, ErreurTache>> sauvegarder(Tache tache) async {
    final existe = _taches.containsKey(tache.identifiant);
    if (!existe) {
      return Resultat.echec(ErreurTache.tacheIntrouvable);
    }
    _taches[tache.identifiant] = tache;
    return Resultat.succes(tache);
  }

  @override
  Future<Resultat<bool, ErreurTache>> supprimer(
    IdentifiantTache identifiant,
  ) async {
    final suppression = _taches.remove(identifiant);
    if (suppression == null) {
      return Resultat.echec(ErreurTache.tacheIntrouvable);
    }
    return Resultat.succes(true);
  }
}

class TacheRepositoryFirebase implements TacheRepository {
  TacheRepositoryFirebase({
    CollectionReference<Map<String, dynamic>>? collection,
  }) : _collection = collection ??
            FirebaseFirestore.instance.collection('taches');

  final CollectionReference<Map<String, dynamic>> _collection;

  @override
  Future<Resultat<Tache, ErreurTache>> creer(Tache tache) async {
    try {
      await _collection.doc(tache.identifiant.valeur).set(_versDonnees(tache));
      return Resultat.succes(tache);
    } on FirebaseException {
      return Resultat.echec(ErreurTache.erreurTechnique);
    } catch (_) {
      return Resultat.echec(ErreurTache.erreurTechnique);
    }
  }

  @override
  Future<Resultat<List<Tache>, ErreurTache>> lister() async {
    try {
      final reponse = await _collection.get();
      final taches = <Tache>[];
      for (final document in reponse.docs) {
        taches.add(_depuisDocument(document));
      }
      return Resultat.succes(List.unmodifiable(taches));
    } on FirebaseException {
      return Resultat.echec(ErreurTache.erreurTechnique);
    } on FormatException {
      return Resultat.echec(ErreurTache.erreurTechnique);
    } catch (_) {
      return Resultat.echec(ErreurTache.erreurTechnique);
    }
  }

  @override
  Future<Resultat<Tache, ErreurTache>> obtenirParIdentifiant(
    IdentifiantTache identifiant,
  ) async {
    try {
      final document = await _collection.doc(identifiant.valeur).get();
      if (!document.exists) {
        return Resultat.echec(ErreurTache.tacheIntrouvable);
      }
      return Resultat.succes(_depuisDocument(document));
    } on FirebaseException {
      return Resultat.echec(ErreurTache.erreurTechnique);
    } on FormatException {
      return Resultat.echec(ErreurTache.erreurTechnique);
    } catch (_) {
      return Resultat.echec(ErreurTache.erreurTechnique);
    }
  }

  @override
  Future<Resultat<Tache, ErreurTache>> sauvegarder(Tache tache) async {
    final document = _collection.doc(tache.identifiant.valeur);
    try {
      final snapshot = await document.get();
      if (!snapshot.exists) {
        return Resultat.echec(ErreurTache.tacheIntrouvable);
      }
      await document.update(_versDonnees(tache));
      return Resultat.succes(tache);
    } on FirebaseException catch (erreur) {
      if (erreur.code == 'not-found') {
        return Resultat.echec(ErreurTache.tacheIntrouvable);
      }
      return Resultat.echec(ErreurTache.erreurTechnique);
    } catch (_) {
      return Resultat.echec(ErreurTache.erreurTechnique);
    }
  }

  @override
  Future<Resultat<bool, ErreurTache>> supprimer(
    IdentifiantTache identifiant,
  ) async {
    final document = _collection.doc(identifiant.valeur);
    try {
      final snapshot = await document.get();
      if (!snapshot.exists) {
        return Resultat.echec(ErreurTache.tacheIntrouvable);
      }
      await document.delete();
      return Resultat.succes(true);
    } on FirebaseException catch (erreur) {
      if (erreur.code == 'not-found') {
        return Resultat.echec(ErreurTache.tacheIntrouvable);
      }
      return Resultat.echec(ErreurTache.erreurTechnique);
    } catch (_) {
      return Resultat.echec(ErreurTache.erreurTechnique);
    }
  }

  Map<String, dynamic> _versDonnees(Tache tache) {
    return {
      'titre': tache.titre,
      'description': tache.description,
      'dateCreation': Timestamp.fromDate(tache.dateCreation),
      'dateModification': Timestamp.fromDate(tache.dateModification),
      'statut': tache.statut.valeur,
      'identifiant': tache.identifiant.valeur,
    };
  }

  Tache _depuisDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final donnees = document.data();
    if (donnees == null) {
      throw const FormatException('document tache vide');
    }

    final titre = donnees['titre'];
    final description = donnees['description'];
    final brutDateCreation = donnees['dateCreation'];
    final brutDateModification = donnees['dateModification'];
    final statutTexte = donnees['statut'];

    if (titre is! String || description is! String) {
      throw const FormatException('champs texte invalides');
    }

    final statut = _statutDepuisTexte(statutTexte);
    if (statut == null) {
      throw const FormatException('statut inconnu');
    }

    final dateCreation = _extraireDate(brutDateCreation, 'dateCreation');
    final dateModification =
        _extraireDate(brutDateModification, 'dateModification');

    return Tache(
      identifiant: IdentifiantTache(document.id),
      titre: titre,
      description: description,
      dateCreation: dateCreation,
      dateModification: dateModification,
      statut: statut,
    );
  }

  DateTime _extraireDate(dynamic valeur, String champ) {
    if (valeur is Timestamp) {
      return valeur.toDate();
    }
    if (valeur is DateTime) {
      return valeur;
    }
    throw FormatException('champ $champ invalide');
  }

  StatutTache? _statutDepuisTexte(dynamic valeur) {
    if (valeur is! String) {
      return null;
    }
    if (valeur == StatutTache.aFaire.valeur) {
      return StatutTache.aFaire;
    }
    if (valeur == StatutTache.enCours.valeur) {
      return StatutTache.enCours;
    }
    if (valeur == StatutTache.terminee.valeur) {
      return StatutTache.terminee;
    }
    return null;
  }
}

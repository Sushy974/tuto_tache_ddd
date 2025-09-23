import 'package:equatable/equatable.dart';

import 'identifiant_tache.dart';
import 'statut_tache.dart';

class Tache extends Equatable {
  final IdentifiantTache identifiant;
  final String titre;
  final String description;
  final DateTime dateCreation;
  final DateTime dateModification;
  final StatutTache statut;

  const Tache({
    required this.identifiant,
    required this.titre,
    required this.description,
    required this.dateCreation,
    required this.dateModification,
    required this.statut,
  });

  Tache copyWith({
    IdentifiantTache? identifiant,
    String? titre,
    String? description,
    DateTime? dateCreation,
    DateTime? dateModification,
    StatutTache? statut,
  }) {
    return Tache(
      identifiant: identifiant ?? this.identifiant,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
      statut: statut ?? this.statut,
    );
  }

  @override
  List<Object?> get props => [
    identifiant,
    titre,
    description,
    dateCreation,
    dateModification,
    statut,
  ];
}

class TacheBuilder {
  IdentifiantTache _identifiant = const IdentifiantTache(
    'identifiant-par-defaut',
  );
  String _titre = 'Titre par defaut';
  String _description = 'Description par defaut';
  DateTime _dateCreation = DateTime(2024, 1, 1);
  DateTime _dateModification = DateTime(2024, 1, 1);
  StatutTache _statut = StatutTache.aFaire;

  TacheBuilder avecIdentifiant(String valeur) {
    _identifiant = IdentifiantTache(valeur);
    return this;
  }

  TacheBuilder avecTitre(String titre) {
    _titre = titre;
    return this;
  }

  TacheBuilder avecDescription(String description) {
    _description = description;
    return this;
  }

  TacheBuilder avecDateCreation(DateTime date) {
    _dateCreation = date;
    return this;
  }

  TacheBuilder avecDateModification(DateTime date) {
    _dateModification = date;
    return this;
  }

  TacheBuilder avecStatut(StatutTache statut) {
    _statut = statut;
    return this;
  }

  Tache construire() {
    return Tache(
      identifiant: _identifiant,
      titre: _titre,
      description: _description,
      dateCreation: _dateCreation,
      dateModification: _dateModification,
      statut: _statut,
    );
  }
}

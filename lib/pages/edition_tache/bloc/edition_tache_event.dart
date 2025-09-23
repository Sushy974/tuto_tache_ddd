import 'package:equatable/equatable.dart';
import 'package:tuto_tache_ddd/inputs/priorite_tache_input.dart';

abstract class EditionTacheEvent extends Equatable {
  const EditionTacheEvent();

  @override
  List<Object?> get props => [];
}

class EditionTacheInitialisee extends EditionTacheEvent {
  const EditionTacheInitialisee();
}

class EditionTacheTitreChange extends EditionTacheEvent {
  const EditionTacheTitreChange(this.valeur);

  final String valeur;

  @override
  List<Object?> get props => [valeur];
}

class EditionTacheDescriptionChange extends EditionTacheEvent {
  const EditionTacheDescriptionChange(this.valeur);

  final String valeur;

  @override
  List<Object?> get props => [valeur];
}

class EditionTacheDateChange extends EditionTacheEvent {
  const EditionTacheDateChange(this.valeur);

  final String valeur;

  @override
  List<Object?> get props => [valeur];
}

class EditionTachePrioriteChange extends EditionTacheEvent {
  const EditionTachePrioriteChange(this.priorite);

  final PrioriteTacheUi priorite;

  @override
  List<Object?> get props => [priorite];
}

class EditionTacheSoumise extends EditionTacheEvent {
  const EditionTacheSoumise();
}

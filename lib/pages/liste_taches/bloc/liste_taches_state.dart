import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class TacheItemUi extends Equatable {
  const TacheItemUi({
    required this.identifiant,
    required this.titre,
    required this.dateTexte,
    required this.prioriteCle,
    required this.estTerminee,
  });

  final String identifiant;
  final String titre;
  final String dateTexte;
  final String prioriteCle;
  final bool estTerminee;

  @override
  List<Object?> get props => [
    identifiant,
    titre,
    dateTexte,
    prioriteCle,
    estTerminee,
  ];
}

class ListeTachesState extends Equatable {
  const ListeTachesState({
    this.status = FormzSubmissionStatus.initial,
    this.taches = const [],
    this.estFiltreTerminees = false,
    this.aAtteintLaFin = false,
    this.messageCle,
  });

  final FormzSubmissionStatus status;
  final List<TacheItemUi> taches;
  final bool estFiltreTerminees;
  final bool aAtteintLaFin;
  final String? messageCle;

  bool get estVide => status == FormzSubmissionStatus.success && taches.isEmpty;

  ListeTachesState copyWith({
    FormzSubmissionStatus? status,
    List<TacheItemUi>? taches,
    bool? estFiltreTerminees,
    bool? aAtteintLaFin,
    String? messageCle,
  }) {
    return ListeTachesState(
      status: status ?? this.status,
      taches: taches ?? this.taches,
      estFiltreTerminees: estFiltreTerminees ?? this.estFiltreTerminees,
      aAtteintLaFin: aAtteintLaFin ?? this.aAtteintLaFin,
      messageCle: messageCle ?? this.messageCle,
    );
  }

  @override
  List<Object?> get props => [
    status,
    taches,
    estFiltreTerminees,
    aAtteintLaFin,
    messageCle,
  ];
}

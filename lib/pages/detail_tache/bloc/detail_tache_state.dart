import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class DetailTacheUi extends Equatable {
  const DetailTacheUi({
    required this.identifiant,
    required this.titre,
    required this.description,
    required this.dateTexte,
    required this.prioriteCle,
    required this.estComplete,
  });

  final String identifiant;
  final String titre;
  final String description;
  final String dateTexte;
  final String prioriteCle;
  final bool estComplete;

  @override
  List<Object?> get props => [
    identifiant,
    titre,
    description,
    dateTexte,
    prioriteCle,
    estComplete,
  ];
}

class DetailTacheState extends Equatable {
  const DetailTacheState({
    this.status = FormzSubmissionStatus.initial,
    this.tache,
    this.messageCle,
  });

  final FormzSubmissionStatus status;
  final DetailTacheUi? tache;
  final String? messageCle;

  DetailTacheState copyWith({
    FormzSubmissionStatus? status,
    DetailTacheUi? tache,
    String? messageCle,
  }) {
    return DetailTacheState(
      status: status ?? this.status,
      tache: tache ?? this.tache,
      messageCle: messageCle ?? this.messageCle,
    );
  }

  @override
  List<Object?> get props => [status, tache, messageCle];
}

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:tuto_tache_ddd/inputs/date_echeance_input.dart';
import 'package:tuto_tache_ddd/inputs/description_tache_input.dart';
import 'package:tuto_tache_ddd/inputs/priorite_tache_input.dart';
import 'package:tuto_tache_ddd/inputs/titre_tache_input.dart';

class EditionTacheState extends Equatable with FormzMixin {
  const EditionTacheState({
    this.status = FormzSubmissionStatus.initial,
    this.titre = const TitreTacheInput.pure(),
    this.description = const DescriptionTacheInput.pure(),
    this.dateEcheance = const DateEcheanceInput.pure(),
    this.priorite = const PrioriteTacheInput.pure(),
    this.messageCle,
  });

  final FormzSubmissionStatus status;
  final TitreTacheInput titre;
  final DescriptionTacheInput description;
  final DateEcheanceInput dateEcheance;
  final PrioriteTacheInput priorite;
  final String? messageCle;

  EditionTacheState copyWith({
    FormzSubmissionStatus? status,
    TitreTacheInput? titre,
    DescriptionTacheInput? description,
    DateEcheanceInput? dateEcheance,
    PrioriteTacheInput? priorite,
    String? messageCle,
  }) {
    return EditionTacheState(
      status: status ?? this.status,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      dateEcheance: dateEcheance ?? this.dateEcheance,
      priorite: priorite ?? this.priorite,
      messageCle: messageCle ?? this.messageCle,
    );
  }

  @override
  List<Object?> get props => [
    status,
    titre,
    description,
    dateEcheance,
    priorite,
    messageCle,
  ];

  @override
  List<FormzInput<dynamic, String>> get inputs => [
    titre,
    description,
    dateEcheance,
    priorite,
  ];
}

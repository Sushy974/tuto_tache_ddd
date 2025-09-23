import 'package:equatable/equatable.dart';

abstract class DetailTacheEvent extends Equatable {
  const DetailTacheEvent();

  @override
  List<Object?> get props => [];
}

class DetailTacheCharge extends DetailTacheEvent {
  const DetailTacheCharge();
}

class DetailTacheBasculerStatut extends DetailTacheEvent {
  const DetailTacheBasculerStatut({required this.complet});

  final bool complet;

  @override
  List<Object?> get props => [complet];
}

class DetailTacheSuppressionDemandee extends DetailTacheEvent {
  const DetailTacheSuppressionDemandee();
}

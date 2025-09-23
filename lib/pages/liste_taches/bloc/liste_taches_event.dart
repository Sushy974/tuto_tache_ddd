import 'package:equatable/equatable.dart';

abstract class ListeTachesEvent extends Equatable {
  const ListeTachesEvent();

  @override
  List<Object?> get props => [];
}

class ListeTachesDemarre extends ListeTachesEvent {
  const ListeTachesDemarre();
}

class ListeTachesFiltreChange extends ListeTachesEvent {
  const ListeTachesFiltreChange({required this.afficherTerminees});

  final bool afficherTerminees;

  @override
  List<Object?> get props => [afficherTerminees];
}

class ListeTachesChargerPlus extends ListeTachesEvent {
  const ListeTachesChargerPlus();
}

class ListeTachesEditionDemandee extends ListeTachesEvent {
  const ListeTachesEditionDemandee(this.identifiantTache);

  final String identifiantTache;

  @override
  List<Object?> get props => [identifiantTache];
}

class ListeTachesSuppressionDemandee extends ListeTachesEvent {
  const ListeTachesSuppressionDemandee(this.identifiantTache);

  final String identifiantTache;

  @override
  List<Object?> get props => [identifiantTache];
}

class ListeTachesCreationDemandee extends ListeTachesEvent {
  const ListeTachesCreationDemandee();
}

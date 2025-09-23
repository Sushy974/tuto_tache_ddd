import 'package:equatable/equatable.dart';

class IdentifiantTache extends Equatable {
  final String valeur;

  const IdentifiantTache(this.valeur) : assert(valeur != '');

  @override
  List<Object?> get props => [valeur];
}

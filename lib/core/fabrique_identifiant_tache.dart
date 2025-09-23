import '../models/identifiant_tache.dart';

abstract class FabriqueIdentifiantTache {
  IdentifiantTache generer();
}

class FabriqueUuidTache implements FabriqueIdentifiantTache {
  final String Function() _generateur;

  FabriqueUuidTache(this._generateur);

  @override
  IdentifiantTache generer() {
    return IdentifiantTache(_generateur());
  }
}

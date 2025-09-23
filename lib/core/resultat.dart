class Resultat<T, E> {
  final T? valeur;
  final E? erreur;

  const Resultat._({this.valeur, this.erreur});

  bool get estSucces => valeur != null;
  bool get estErreur => erreur != null;

  static Resultat<T, E> succes<T, E>(T valeur) {
    return Resultat._(valeur: valeur);
  }

  static Resultat<T, E> echec<T, E>(E erreur) {
    return Resultat._(erreur: erreur);
  }
}

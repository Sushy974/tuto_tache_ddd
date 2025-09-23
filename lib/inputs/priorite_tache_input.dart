import 'package:formz/formz.dart';

enum PrioriteTacheUi { elevee, moyenne, faible }

class PrioriteTacheInput extends FormzInput<PrioriteTacheUi?, String> {
  const PrioriteTacheInput.pure() : super.pure(null);
  const PrioriteTacheInput.dirty(PrioriteTacheUi? valeur) : super.dirty(valeur);

  @override
  String? validator(PrioriteTacheUi? valeur) {
    if (valeur == null) {
      return 'erreurPrioriteObligatoire';
    }
    return null;
  }
}

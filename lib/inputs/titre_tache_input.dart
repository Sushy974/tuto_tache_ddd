import 'package:formz/formz.dart';

class TitreTacheInput extends FormzInput<String, String> {
  const TitreTacheInput.pure() : super.pure('');
  const TitreTacheInput.dirty(String valeur) : super.dirty(valeur);

  @override
  String? validator(String valeur) {
    if (valeur.trim().isEmpty) {
      return 'erreurTitreObligatoire';
    }
    return null;
  }
}

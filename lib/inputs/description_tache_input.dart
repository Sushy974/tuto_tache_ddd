import 'package:formz/formz.dart';

class DescriptionTacheInput extends FormzInput<String, String> {
  const DescriptionTacheInput.pure() : super.pure('');
  const DescriptionTacheInput.dirty(String valeur) : super.dirty(valeur);

  @override
  String? validator(String valeur) {
    if (valeur.trim().isEmpty) {
      return 'erreurDescriptionObligatoire';
    }
    return null;
  }
}

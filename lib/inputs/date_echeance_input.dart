import 'package:formz/formz.dart';

class DateEcheanceInput extends FormzInput<String, String> {
  const DateEcheanceInput.pure() : super.pure('');
  const DateEcheanceInput.dirty(String valeur) : super.dirty(valeur);

  static final _pattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  @override
  String? validator(String valeur) {
    if (valeur.isEmpty || !_pattern.hasMatch(valeur)) {
      return 'erreurDateInvalide';
    }
    return null;
  }
}

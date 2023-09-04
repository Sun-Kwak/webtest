import 'package:formz/formz.dart';

enum NameValidationError { empty, invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');

  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NameValidationError.empty;
    } else if (value.length < 2) {
      return NameValidationError.invalid;
    } else {
      return null;
    }
  }

  static String? showNameErrorMessage(NameValidationError? error) {
    if (error == NameValidationError.empty) {
      return '이름을 입력하세요.';
    } else if (error == NameValidationError.invalid) {
      return '최소 2글자';
    } else {
      return null;
    }
  }
}

import 'package:formz/formz.dart';

enum DateValidationError { empty, invalid }

class Date extends FormzInput<String, DateValidationError> {
  const Date.pure() : super.pure('');

  const Date.dirty([String value = '']) : super.dirty(value);

  @override
  DateValidationError? validator(String value) {
    if (value.isEmpty) {
      return DateValidationError.empty;
    } else if (value.length < 6) {
      return DateValidationError.invalid;
    } else {
      return null;
    }
  }

  static String? showDateErrorMessage(DateValidationError? error) {
    if (error == DateValidationError.empty) {
      return '날짜를 선택하세요.';
    }else if( error == DateValidationError.invalid) {
      return '날짜를 선택하세요.';
    } else {
      return null;
    }
  }
}

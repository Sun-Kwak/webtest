import 'package:formz/formz.dart';

enum NameValidationError { empty, invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');

  const Name.dirty([String value = '']) : super.dirty(value);
  static const koreanEnglishPattern = r'^[a-zA-Z가-힣]+$';


  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NameValidationError.empty;
    } else if (!RegExp(koreanEnglishPattern, caseSensitive: false).hasMatch(value)) {
      return NameValidationError.invalid;
    } else {
      return null;
    }
  }

  static String? showNameErrorMessage(NameValidationError? error) {
    if (error == NameValidationError.empty) {
      return '이름을 입력하세요.';
    } else if (error == NameValidationError.invalid) {
      return '한글과 영어만 입력 가능합니다.';
    } else {
      return null;
    }
  }
}

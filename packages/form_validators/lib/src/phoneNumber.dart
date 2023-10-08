
import 'package:formz/formz.dart';

enum PhoneNumberValidationError { empty, invalid }

const String _kPhonePattern =
    r'^010[-]?\d{3,4}[-]?\d{4}$';

class Phone extends FormzInput<String, PhoneNumberValidationError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([String value ='']) : super.dirty(value);

  static final _regex = RegExp(_kPhonePattern);

  @override
  PhoneNumberValidationError? validator(String value) {
    if (_regex.hasMatch(value)) {
      return null;
    } else if (value.isEmpty) {
      return PhoneNumberValidationError.empty;
    } else {
      return PhoneNumberValidationError.invalid;
    }
  }

  static String? showPhoneErrorMessages(PhoneNumberValidationError? error) {
    if (error == PhoneNumberValidationError.empty) {
      return '전화번호를 입력하세요.';
    } else if( error == PhoneNumberValidationError.invalid) {
      return '유효한 전화번호 형식이 아닙니다.';
    } else {
      return null;
    }
  }
}
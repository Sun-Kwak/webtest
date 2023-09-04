import 'package:form_validator/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/auth/signup/controller/signup_state.dart';

final signUpProvider = StateNotifierProvider.autoDispose<SignUpController, SignUpState>(
      (ref) => SignUpController(),
);
class SignUpController extends StateNotifier<SignUpState> {
  SignUpController () : super(const SignUpState());

  void onNameChange(String value) {
    final name = Name.dirty(value);
    state = state.copyWith(
      name: name,
      status: Formz.validate([
        name,
        state.email,
        state.password,
      ]));
  }

  void onEmailChange(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.name,
        state.password,
      ]),
    );
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
      password: password,
      status: Formz.validate([
        password,
        state.name,
        state.email,
      ]),
    );
  }

  void signUpWithEmailAndPassword() async {
 if (state.status == FormzStatus.submissionSuccess){
    } else{
    };
  }
}
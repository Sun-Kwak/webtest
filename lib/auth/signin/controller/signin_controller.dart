import 'package:form_validator/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/auth/signin/controller/signin_state.dart';

final signInProvider = StateNotifierProvider.autoDispose<SignInController, SignInState>(
      (ref) => SignInController(),
);
class SignInController extends StateNotifier<SignInState> {
  SignInController () : super(const SignInState());

  void onEmailChange(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
      email: email,
      status: Formz.validate([
        email,
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
        state.email,
      ]),
    );
  }

  void signInWithEmailAndPassword() async {
    if (state.status == FormzStatus.submissionSuccess){
    } else{
    };
  }
}

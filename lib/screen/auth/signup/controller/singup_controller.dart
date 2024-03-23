import 'package:form_validator/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:authentication_repository/src/auth_repo_provider.dart';
import 'package:web_test2/screen/auth/signup/controller/signup_state.dart';

final signUpProvider =
    StateNotifierProvider.autoDispose<SignUpNotifier, SignUpState>(
  (ref) => SignUpNotifier(ref.watch(authRepoProvider)),
);

class SignUpNotifier extends StateNotifier<SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  SignUpNotifier(this._authenticationRepository) : super(const SignUpState());

  void onNameChange(String value) async {
    final name = Name.dirty(value);

    state = state.copyWith(
      name: name,
      status: Formz.validate(
        [
          name,
          state.email,
          state.password,
        ],
      ),
    );
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
    if (!state.status.isValidated) return;
    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      await _authenticationRepository.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
        displayName: state.name.value,
      );
      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }
}

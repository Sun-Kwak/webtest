import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:authentication_repository/src/auth_repo_provider.dart';

final googleSignInProvider =
StateNotifierProvider<GoogleSignInController, GoogleSignInState>(
      (ref) {
    final authenticationRepository = ref.watch(authRepoProvider);
    return GoogleSignInController(authenticationRepository);
  },
);

enum GoogleSignInState {
  initial,
  loading,
  success,
  error,
}

class GoogleSignInController extends StateNotifier<GoogleSignInState> {
  final AuthenticationRepository _authenticationRepository;

  GoogleSignInController(this._authenticationRepository)
      : super(GoogleSignInState.initial);

  Future<void> signInWithGoogle() async {
    state = GoogleSignInState.loading;

    try {
      await _authenticationRepository.signInWithGoogle();

      state = GoogleSignInState.success;
    } on SignInWithGoogleFailure catch (_) {

      state = GoogleSignInState.error;
    }
  }
}
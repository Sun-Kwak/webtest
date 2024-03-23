import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:authentication_repository/src/auth_repo_provider.dart';

final kakaoSignInProvider =
    StateNotifierProvider<KakaoSignInController, KakaoSignInState>(
  (ref) {
    final authenticationRepository = ref.watch(authRepoProvider);
    return KakaoSignInController(authenticationRepository);
  },
);

enum KakaoSignInState {
  initial,
  loading,
  success,
  error,
}

class KakaoSignInController extends StateNotifier<KakaoSignInState> {
  final AuthenticationRepository _authenticationRepository;

  KakaoSignInController(this._authenticationRepository,)
      : super(KakaoSignInState.initial);

  Future<void> signInWithKakao() async {
    state = KakaoSignInState.loading;

    try {
      await _authenticationRepository.signInWithKakao();

      state = KakaoSignInState.success;
    } on SignInWithKakaoFailure catch (_) {
      state = KakaoSignInState.error;
    }
  }
}

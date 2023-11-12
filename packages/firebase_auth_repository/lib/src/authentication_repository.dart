import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class FirebaseAuthRemoteDataSource {
  final String url =
      'https://asia-northeast3-web-test2-7a646.cloudfunctions.net/createCustomToken';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http.post(Uri.parse(url), body: user);

    return customTokenResponse.body;
  }
}

class SignUpWithEmailAndPasswordFailure implements Exception {
  final String code;

  const SignUpWithEmailAndPasswordFailure(this.code);
}

class SignInWithEmailAndPasswordFailure implements Exception {
  final String code;

  const SignInWithEmailAndPasswordFailure(this.code);
}

class ForgotPasswordFailure implements Exception {
  final String code;

  const ForgotPasswordFailure(this.code);
}

class CustomException implements Exception {
  final String message;

  const CustomException({required this.message});
}

class SignInWithGoogleFailure implements Exception {
  final String code;

  const SignInWithGoogleFailure(this.code);
}

class SignInWithKakaoFailure implements Exception {
  final String code;

  const SignInWithKakaoFailure(this.code);
}

class SignOutFailure implements Exception {
  final String message;

  SignOutFailure(this.message);

  @override
  String toString() => 'SignOutFailure: $message';
}

class AuthenticationRepository {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.standard();
  final _kakaoSignIn = kakao.UserApi.instance;
  final _employeeRepository = EmployeeRepository();

  Future<void> signInWithKakao() async {
    await _kakaoSignIn.loginWithKakaoAccount();

    final user = await _kakaoSignIn.me();
    final token = await _firebaseAuthDataSource.createCustomToken(
      {
        'uid': user.id.toString(),
        'displayName': user.kakaoAccount!.profile!.nickname,
        'email': user.kakaoAccount!.email,
        // 'authPlatform': 'Kakao',
      },
    );
    try {
      await FirebaseAuth.instance.signInWithCustomToken(token);
      _employeeRepository.signUpSetUserData(
          user.kakaoAccount!.email!, user.kakaoAccount!.profile!.nickname!);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove('flutter.com.kakao.token.version');
      // _kakaoSignIn.logout();

      kakao.UserApi.instance.logout();


    } catch (e) {
      throw SignInWithKakaoFailure(e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _employeeRepository.signUpSetUserData(email, displayName);
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure(e.code);
    }
  }

  Future<void> signInWithGoogle() async {
    try {

      GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signInSilently();

      if (googleSignInAccount == null) {

        try {
          await _googleSignIn.signIn();
        } catch (e) {

          googleSignInAccount =
              await _googleSignIn.signInSilently(); // 실패한 경우 null 반환
        }
      }

      if (googleSignInAccount != null) {
        final googleSignInAuth = await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken,
        );

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        final email = userCredential.user?.email;
        final displayName = userCredential.user?.displayName;
        _employeeRepository.signUpSetUserData(email!, displayName!);

      }
    } on FirebaseAuthException catch (e) {
      throw SignInWithGoogleFailure(e.toString());
    }
  }

  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? AuthUser.empty
          : AuthUser(
              id: firebaseUser.uid,
              email: firebaseUser.email,
              name: firebaseUser.displayName,
              emailVerified: firebaseUser.emailVerified,
            );
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure(e.code);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ForgotPasswordFailure(e.code);
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        // _kakaoSignIn.logout(),
        // kakao.UserApi.instance.logout(),
      ]);
    } catch (e) {
      throw SignOutFailure(e.toString());
    }
  }
}

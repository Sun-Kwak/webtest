import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:http/http.dart' as http;


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

class SignInWithGoogleFailure implements Exception {}

class SignInWithKakaoFailure implements Exception {}

class SignOutFailure implements Exception {}

class AuthenticationRepository {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.standard();
  final _kakaoSignIn = kakao.UserApi.instance;

  Future<void> signUpWithEmailAndPassword(
      {required String email, required String password, required String displayName}) async {
    try {
      UserCredential userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userCred.user!.updateDisplayName(displayName);

    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure(e.code);
    }
  }


  Future<bool?> signInWithKakao() async {
    final kakaoSignInAuth = await _kakaoSignIn.loginWithKakaoAccount();
    if (kakaoSignInAuth != null) {
      final user = await _kakaoSignIn.me();
      // final baseURL =
      //     'https://firebasestorage.googleapis.com/v0/b/web-test2-7a646.appspot.com/o/LAVIDA%20LOGO.jpg?alt=media&token=56352ce1-ef2f-49e3-b94b-78a65ce9e025';
      // final photoURL = user.kakaoAccount?.profile?.profileImageUrl ??
      //     baseURL; // 만약 null이면 baseURL 사용

      final token = await _firebaseAuthDataSource.createCustomToken(
        {
          'uid': user.id.toString(),
          'displayName': user.kakaoAccount!.profile!.nickname,
          'email': user.kakaoAccount!.email,
          'authPlatform': 'Kakao',
         // 'photoURL': photoURL,
        },
      );

      try {
        // Custom Token을 사용하여 Firebase에 로그인
        final newUser =
            await FirebaseAuth.instance.signInWithCustomToken(token);

        return newUser.additionalUserInfo?.isNewUser;
      } catch (e) {
        // Custom Token으로 로그인 중 오류 처리
        print('Error signing in with Custom Token: $e');
        throw SignInWithKakaoFailure();
      }
    }
  }

  Future<bool?> signInWithGoogle() async {
    try {
      // 시크릿 브라우저 쿠키를 사용하여 로그인 시도
      GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signInSilently();

      if (googleSignInAccount == null) {
        // 시크릿 브라우저 쿠키가 없으면 일반적인 로그인 시도
        try {
          await _googleSignIn.signIn();
        } catch (e) {
          // 로그인 시도 실패
          googleSignInAccount =
              await _googleSignIn.signInSilently(); // 실패한 경우 null 반환
        }
      }

      // 여기까지 왔다면 googleSignInAccount에 로그인 정보가 있을 것입니다.
      if (googleSignInAccount != null) {
        final googleSignInAuth = await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken,
        );

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return userCredential.additionalUserInfo?.isNewUser;
      } else {
        return null; // 구글 로그인 계정이 없는 경우 null 반환
      }
    } catch (_) {
      return null; // 예외 발생 시 null 반환
    }
  }

  // Future<bool?> signInWithGoogle() async {
  //   try {
  //     GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signInSilently();
  //
  //     if (googleSignInAccount == null) {
  //       // 웹 브라우저에 로그인 세션이 없는 경우에는 로그인 시도
  //       try {
  //         await _googleSignIn.signIn();
  //       } catch (error) {
  //         // signIn() 메서드가 실패하면 예외를 처리하고 다시 시도하거나 오류를 처리할 수 있습니다.
  //         print("Google Sign-In failed: $error");
  //         throw SignInWithGoogleFailure();
  //       }
  //
  //       // 다시 signInSilently()를 호출하여 로그인 성공 여부를 확인
  //       googleSignInAccount = await _googleSignIn.signInSilently();
  //
  //       if (googleSignInAccount == null) {
  //         throw SignInWithGoogleFailure();
  //       }
  //     }
  //
  //     final googleSignInAuth = await googleSignInAccount.authentication;
  //
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuth.accessToken,
  //       idToken: googleSignInAuth.idToken,
  //     );
  //
  //     final userCredential = await _firebaseAuth.signInWithCredential(credential);
  //
  //     return userCredential.additionalUserInfo?.isNewUser;
  //   } on FirebaseAuthException catch (_) {
  //     throw SignInWithGoogleFailure();
  //   }
  // }

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
        _kakaoSignIn.logout(),
      ]);
    } catch (_) {
      throw SignOutFailure();
    }
  }
}

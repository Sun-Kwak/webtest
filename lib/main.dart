import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:web_test2/auth/authentication_view.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/firebase_options.dart';
import 'package:web_test2/auth/controller/authentication_controller.dart';
import 'package:web_test2/screen/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '83f7860e16be3ceaa90d6d0cc408e407',
    javaScriptAppKey: '76648842040726cf58adb8c643b0a6a5',
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationState = ref.watch(authProvider);

    Widget getHome() {
      if (authenticationState.status == AuthenticationStatus.authenticated) {
        return const UserProfile();
      } else if (authenticationState.status ==
          AuthenticationStatus.unauthenticated) {
        return const AuthenticationView();
      } else {
        return const AuthenticationView();
      }
    }

    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
              bodyText1: TextStyle(
        fontSize: 14,
        color: PRIMARY_COLOR,
        fontWeight: FontWeight.w300,
      ))),
      debugShowCheckedModeBanner: false,
      home: getHome(),
    );
  }
}

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/view/splash_screen.dart';
import 'package:web_test2/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:web_test2/screen/auth/authentication_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "env");

  KakaoSdk.init(
    nativeAppKey: dotenv.env['NATIVEAPPKEY'],
    javaScriptAppKey: dotenv.env['JAVASCRIPTAPPKEY'],
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {

      var screenSize = MediaQuery.of(context).size;
      print('화면 너비: ${screenSize.width}');
      print('화면 높이: ${screenSize.height}');
    });
    final authenticationState = ref.watch(userMeProvider);


    Widget getHome() {
      if (authenticationState.status == AuthenticationStatus.authenticated) {
        return const SplashScreen();
      } else if (authenticationState.status ==
          AuthenticationStatus.unauthenticated) {
        return const AuthenticationView();
      } else {
        return const AuthenticationView();
      }
    }

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [Locale('en'), Locale('ko')],
      locale: const Locale('ko'),
      theme: ThemeData(
        scaffoldBackgroundColor: BACKGROUND_COLOR,
        fontFamily: 'SebangGothic',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w400,
              fontFamily: 'SebangGothic'),
          bodyMedium: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              fontFamily: 'SebangGothic'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: getHome(),
    );
  }
}

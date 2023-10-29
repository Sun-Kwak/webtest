import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/view/splash_screen.dart';
import 'package:web_test2/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:web_test2/screen/auth/authentication_view.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: '75da07fa08b08bddb7702c2f9947caa3',
    javaScriptAppKey: '0c5b5b974ec45563bc39542fb355f4d0',
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
      // 이 코드는 화면이 렌더링된 후에 실행됩니다.
      var screenSize = MediaQuery.of(context).size;
      print('화면 너비: ${screenSize.width}');
      print('화면 높이: ${screenSize.height}');
    });
    //
    // final signInUserState = ref.watch(signedInUserProvider);
    final authenticationState = ref.watch(userMeProvider);

    // final router = ref.watch(routerProvider);

    Widget getHome() {
      if (authenticationState.status == AuthenticationStatus.authenticated) {
        // if (signInUserState.value!.level < 5) {
        //   return const UserManagementScreen();
        // } else {
        return const SplashScreen();
        // }
      } else if (authenticationState.status ==
          AuthenticationStatus.unauthenticated) {
        return const AuthenticationView();
      } else {
        return const AuthenticationView();
      }
    }

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: [Locale('en'), Locale('ko')],
      locale: const Locale('ko'),
      theme: ThemeData(
        scaffoldBackgroundColor: BACKGROUND_COLOR,
        fontFamily: 'SebangGothic',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w400,
              fontFamily: 'SebangGothic'), // 기본 텍스트 스타일을 지정합니다.
          bodyMedium: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              fontFamily: 'SebangGothic'), // 다른 텍스트 유형에 대해서도 스타일을 지정할 수 있습니다.
          // 필요한 다른 텍스트 스타일을 지정할 수 있습니다.
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: getHome(),
      // routerConfig: router,
    );
  }
}

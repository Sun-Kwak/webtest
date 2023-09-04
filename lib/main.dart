
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/auth/authentication_view.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/firebase_options.dart';
import 'package:web_test2/auth/controller/authentication_controller.dart';
import 'package:web_test2/screen/profile.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authnticationState = ref.watch(authProvider);

    Widget getHome() {
      if(authnticationState.status == AuthenticationStatus.authenticated) {
        return const Profile();
      } else if (authnticationState.status == AuthenticationStatus.unauthenticated){
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
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      home: getHome(),
    );
  }
}

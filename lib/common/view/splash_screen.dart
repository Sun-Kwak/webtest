import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:web_test2/common/view/root_tab.dart';
import 'package:authentication_repository/src/signedIn_user_provider.dart';
import 'package:web_test2/screen/user_profile.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInUserState = ref.watch(signedInUserProvider);


    return signInUserState.when(
      loading: ()=> Lottie.asset('asset/lottie/initial.json',height: 200,width: 200),
      error: (error, stackTrace) => Text(error.toString()),
      data:(value) {
        if(value != null && value.level < 5) {
          return const RootTab();
        } else {
          return const UserProfile();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/view/root_tab.dart';
import 'package:authentication_repository/src/signedIn_user_provider.dart';
import 'package:web_test2/screen/user_profile.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInUserState = ref.watch(signedInUserProvider);

    return signInUserState.when(
      loading: ()=> LoadingAnimationWidget.fallingDot(color: PRIMARY_COLOR, size: 50),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/layout/default_layout.dart';
import 'package:authentication_repository/src/authentication_controller.dart';
import 'package:authentication_repository/src/signedIn_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends ConsumerWidget {

  const UserProfile({Key? key}) : super(key: key);

  static String get routeName => 'profile';


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(userMeProvider.notifier);
    final signInUserState = ref.watch(signedInUserProvider);


    Future<String?> getUserData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_name');
    }


    return FutureBuilder<String?>(
      future: getUserData(),
      builder: (context, snapshot) {
        String? showName = snapshot.data ?? signInUserState.value?.displayName;
        return DefaultLayout(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$showName님 반갑습니다. 임원전용 입니다. 관리자의 승인을 기다려 주세요!',
              ),
              SizedBox(height: 20,),
              TextButton(
                onPressed: () async {
                  authController.onSignOut();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('user_name');
                },
                child: const Text('로그아웃',style: TextStyle(color: CONSTRAINT_PRIMARY_COLOR),),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/auth/controller/authentication_controller.dart';
import 'package:web_test2/common/component/Gap.dart';
import 'package:web_test2/common/layout/default_layout.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({Key? key}) : super(key: key);

  static String get routeName => 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(userMeProvider.notifier);
    final authUser = ref.watch(userMeProvider).user;
    final authenticationState = ref.watch(userMeProvider);
    //final signedInUser = ref.watch(signedInUserProvider);

    // 비동기 함수를 사용하여 사용자 이름 가져오기
    // Future<String?> getUserName() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   return prefs.getString('user_name');
    // }

    return DefaultLayout(
      child: Column(
        children: [
          // FutureBuilder<String?>(
          //   // FutureBuilder를 사용하여 비동기 작업 처리
          //   future: getUserName(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       // 데이터를 아직 가져오지 않았을 때의 로딩 상태 처리
          //       return CircularProgressIndicator();
          //     } else if (snapshot.hasError) {
          //       // 오류 발생 시 처리
          //       return Text('오류 발생: ${snapshot.error}');
          //     } else {
          //       // 데이터를 가져오고 사용자 이름을 표시
          //       final userName = authUser.name ?? snapshot.data;
          //       return
        Text(
                  '${authUser.name} 님 반갑습니다. 임원전용 입니다. 관리자의 승인을 기다려 주세요!',
                ),
          TextButton(
            onPressed: () async {
              //

              authController.onSignOut();
              //context.goNamed(AuthenticationView.routeName);
              print(authenticationState.status);
            },
            child: const Text('로그아웃'),
          ),
          HeightGap(),
          // TextButton(
          //   onPressed: () async {
          //     print(authUser.id);
          //     final data = signedInUser.value?.level;
          //     print(data);
          //   },
          //   child: const Text('값출력'),
          // ),
        ],
      ),
    );
  }
}

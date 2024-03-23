import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web_test2/screen/auth/authentication_view.dart';
import 'package:authentication_repository/src/authentication_controller.dart';
import 'package:web_test2/screen/auth/forgot_password/forgot_password_view.dart';
import 'package:web_test2/screen/user_profile.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<AuthenticationState?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  // List<GoRoute> get routes =>
  //     [
  //       GoRoute
  //         (
  //         path: '/home',
  //         name: AuthenticationView.routeName,
  //         builder: (_, __) => const AuthenticationView(),
  //       ),
  //       GoRoute(
  //         path: '/forgotPassword',
  //         name: ForgotPasswordScreen.routeName,
  //         builder: (_, __) => const ForgotPasswordScreen(),
  //       ),
  //       GoRoute(
  //         path: '/profile',
  //         name: UserProfile.routeName,
  //         builder: (_, __) => const UserProfile(),
  //       ),
  //     ];
}
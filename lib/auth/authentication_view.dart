import 'package:flutter/material.dart';
import 'package:web_test2/auth/signin/signin_screen.dart';
import 'package:web_test2/auth/signup/signup_screen.dart';
import 'package:web_test2/common/component/Gap.dart';
import 'package:web_test2/common/component/auth_switch_button.dart';
import 'package:web_test2/common/component/side_fade_switcher.dart';
import 'package:web_test2/common/layout/default_layout.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  static String get routeName => 'home';

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  bool _showSignIn = true;
  bool _obscureText = true;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _loginFocusNode = FocusNode();

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double defaultWidth = screenWidth * 0.9;
    double minWidth = 400.0;

    double columnWidth = defaultWidth;
    if (defaultWidth <= minWidth) {
      columnWidth = minWidth - 30;
    }

    return Stack(
      //alignment: AlignmentDirectional.bottomEnd,
      children: [
        DefaultLayout(
          defaultWidth: 0.3,
          child: Column(
            children: [
              const HeightGap(defaultHeight: 50),
              SlideFadeSwitcher(
                child: _showSignIn
                    ? SignInScreen(
                        loginButtonOnPressed: () {},
                        emailFieldFocusNode: _emailFocusNode,
                        passwordFieldFocusNode: _passwordFocusNode,
                        loginButtonFocusNode: _loginFocusNode,
                        emailOnFieldSubmitted: _passwordFocusNode,
                        passwordOnFieldSubmitted: _loginFocusNode,
                        obscureText: _obscureText,
                        obscureIconOnPressed: _toggleObscureText,
                        columnWidth: columnWidth,
                        // ErrorDialog.show(context, "접속 실패");
                        //LoadingSheet.show(context);
                      )
                    : SignUpScreen(
                        nameFieldFocusNode: _nameFocusNode,
                        nameOnFieldSubmitted: _emailFocusNode,
                        emailFieldFocusNode: _emailFocusNode,
                        emailOnFieldSubmitted: _passwordFocusNode,
                        passwordFieldFocusNode: _passwordFocusNode,
                        passwordOnFieldSubmitted: _loginFocusNode,
                        loginButtonFocusNode: _loginFocusNode,
                        obscureText: _obscureText,
                        obscureIconOnPressed: _toggleObscureText,
                        columnWidth: columnWidth,
                      ),
              )
            ],
          ),
        ),
        // CompanyLogo(
        //     showSignin: _showSignIn,
        //     logoWidth: logoWidth,
        //     minLogoWidth: minLogoWidth),
        if (screenHeight > 600)
          AutoSwitchButton(
            onTap: () {
              setState(() {
                _showSignIn = !_showSignIn;
              });
            },
            showSignIn: _showSignIn,
          )
      ],
    );
  }
}

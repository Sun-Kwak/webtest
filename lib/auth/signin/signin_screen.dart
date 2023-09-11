import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validators.dart';
import 'package:web_test2/auth/forgot_password/forgot_password_view.dart';
import 'package:web_test2/auth/signin/controller/signin_controller.dart';
import 'package:web_test2/auth/signin/controller/signin_state.dart';
import 'package:web_test2/common/component/Gap.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/component/hoverText.dart';
import 'package:web_test2/common/component/logo.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/component/error_dialog.dart';
import 'package:web_test2/screen/user_profile.dart';

class SignInScreen extends ConsumerWidget {
  final double columnWidth;
  final FocusNode emailFieldFocusNode;
  final FocusNode passwordFieldFocusNode;
  final FocusNode loginButtonFocusNode;
  final bool obscureText;
  final VoidCallback obscureIconOnPressed;
  final VoidCallback loginButtonOnPressed;
  final FocusNode emailOnFieldSubmitted;
  final FocusNode passwordOnFieldSubmitted;

  const SignInScreen({
    required this.loginButtonOnPressed,
    required this.emailOnFieldSubmitted,
    required this.passwordOnFieldSubmitted,
    required this.loginButtonFocusNode,
    required this.obscureText,
    required this.obscureIconOnPressed,
    required this.passwordFieldFocusNode,
    required this.emailFieldFocusNode,
    required this.columnWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignInState>(
      signInProvider,
      (previous, current) {
        if (current.status.isSubmissionInProgress) {
          LoadingSheet.show(context);
        } else if (current.status.isSubmissionFailure) {
          Navigator.of(context).pop();
          ErrorDialog.show(context, '${current.errorMessage}');
        } else if (current.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        }
      },
    );
    double screenWidth = MediaQuery.of(context).size.width;
    double minLogoWidth = 300.0;
    double logoWidth = screenWidth * 0.1;

    return Column(
      children: [
        CompanyLogo(
          logoWidth: logoWidth,
          minLogoWidth: minLogoWidth,
        ),
        const HeightGap(defaultHeight: 20),
        _EmailField(
            onFieldSubmitted: emailOnFieldSubmitted,
            emailFieldFocusNode: emailFieldFocusNode),
        const HeightGap(),
        _PasswordField(
          onFieldSubmitted: passwordOnFieldSubmitted,
          obscureText: obscureText,
          onPressed: obscureIconOnPressed,
          passwordFieldFocusNode: passwordFieldFocusNode,
        ),
        const HeightGap(defaultHeight: 20),
        _ForgotPasswordButton(),
        const HeightGap(defaultHeight: 20),
        _LoginButton(
          loginButtonFocusNode: loginButtonFocusNode,
          columnWidth: columnWidth,
        ),
        const HeightGap(defaultHeight: 20),
        _OrDivider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GoogleLogo(),
            SizedBox(
              width: 10,
            ),
            AppleLogo(),
            SizedBox(
              width: 10,
            ),
            KaKaoLogo(),
            SizedBox(
              width: 10,
            ),
            NaverLogo(),
          ],
        )
      ],
    );
  }
}

//----------------------------------------------------------------------------
class _EmailField extends ConsumerWidget {
  final FocusNode emailFieldFocusNode;
  final FocusNode onFieldSubmitted;

  const _EmailField(
      {required this.onFieldSubmitted,
      required this.emailFieldFocusNode,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInProvider);
    final bool showError = signInState.email.invalid;
    final signInController = ref.read(signInProvider.notifier);

    return CustomTextFormField(
      onFieldSubmitted: onFieldSubmitted,
      autofocus: true,
      focusNode: emailFieldFocusNode,
      hintText: '이메일 입력',
      errorText: showError
          ? Email.showEmailErrorMessages(signInState.email.error)
          : null,
      onChanged: (email) => signInController.onEmailChange(email),
    );
  }
}

//----------------------------------------------------------------------------
class _PasswordField extends ConsumerWidget {
  final FocusNode onFieldSubmitted;
  final FocusNode passwordFieldFocusNode;
  final bool obscureText;
  final VoidCallback onPressed;

  const _PasswordField({
    required this.onFieldSubmitted,
    required this.onPressed,
    required this.obscureText,
    required this.passwordFieldFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInProvider);
    final bool showError = signInState.password.invalid;
    final signInController = ref.read(signInProvider.notifier);
    return CustomTextFormField(
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      focusNode: passwordFieldFocusNode,
      hintText: '비밀번호 입력',
      errorText: showError
          ? Password.showPasswordErrorMessage(signInState.password.error)
          : null,
      onChanged: (password) => signInController.onPasswordChange(password),
      suffixIcon: IconButton(
        icon: obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        onPressed: onPressed,
        color: obscureText ? PRIMARY_COLOR : CONSTRAINT_PRIMARY_COLOR,
        splashColor: obscureText ? Colors.redAccent : Colors.lightBlueAccent,
      ),
    );
  }
}

//----------------------------------------------------------------------------
class _LoginButton extends ConsumerWidget {
  final FocusNode loginButtonFocusNode;
  final double columnWidth;

  const _LoginButton({
    required this.loginButtonFocusNode,
    required this.columnWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInProvider);
    final bool isValidated = signInState.status.isValidated;
    final signInController = ref.read(signInProvider.notifier);

    return ElevatedButton(
      focusNode: loginButtonFocusNode,
      onPressed: isValidated
          ? () {signInController.signInWithEmailAndPassword();
      print('성공$signInState.status');}
          : (){ _showSnackbar(context); },
      child: Text('접속'),
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
        minimumSize: Size(columnWidth + 10, 65),
        padding: EdgeInsets.zero,
      ),
    );
  }

  void _showSnackbar(BuildContext context) {
    final snackbar = SnackBar(
      content: Center(child: const Text('필수정보들을 전부 입력해주세요')),
      duration: const Duration(seconds: 3), // Snackbar가 표시되는 시간 설정 (예: 2초)
      action: SnackBarAction(
        textColor: Colors.white,
        label: '닫기',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}


class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => ForgotPasswordScreen(),
          ),
        );
      },
      child: Container(
        alignment: AlignmentDirectional.centerEnd,
        child: HoverText(
          builder: (hovering) {
            final color = hovering ? CONSTRAINT_PRIMARY_COLOR : PRIMARY_COLOR;
            return Text(
              '비밀번호 찾기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: color,
                decoration: TextDecoration.none,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Text(
            " 또는 ",
            style: TextStyle(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

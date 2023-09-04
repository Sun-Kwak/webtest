import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validators.dart';
import 'package:web_test2/auth/forgot_password/forgot_password_view.dart';
import 'package:web_test2/auth/signin/controller/signin_controller.dart';
import 'package:web_test2/common/component/Gap.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/component/hoverText.dart';
import 'package:web_test2/common/component/logo.dart';
import 'package:web_test2/common/const/colors.dart';

class SignInScreen extends StatefulWidget {
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
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double minLogoWidth = 300.0;
    double logoWidth = screenWidth * 0.1;

    return Column(
      children: [
        CompanyLogo(logoWidth: logoWidth, minLogoWidth: minLogoWidth,),
        const HeightGap(),
        _EmailField(
            onFieldSubmitted: widget.emailOnFieldSubmitted,
            emailFieldFocusNode: widget.emailFieldFocusNode),
        const HeightGap(),
        _PasswordField(
          onFieldSubmitted: widget.passwordOnFieldSubmitted,
          obscureText: widget.obscureText,
          onPressed: widget.obscureIconOnPressed,
          passwordFieldFocusNode: widget.passwordFieldFocusNode,
        ),
        const HeightGap(defaultHeight: 20),
        _ForgotPasswordButton(),
        const HeightGap(defaultHeight: 20),
        _LoginButton(
          loginButtonFocusNode: widget.loginButtonFocusNode,
          columnWidth: widget.columnWidth,
          onPressed: widget.loginButtonOnPressed,
        ),
        const HeightGap(defaultHeight: 20),
        _OrDivider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GoogleLogo(),
            SizedBox(width: 10,),
            AppleLogo(),
            SizedBox(width: 10,),
            KaKaoLogo(),
            SizedBox(width: 10,),
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
      :null,
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
  final VoidCallback? onPressed;

  const _LoginButton({
    this.onPressed,
    required this.loginButtonFocusNode,
    required this.columnWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInProvider);
    final bool isValidated = signInState.status.isValidated;
    final signInController = ref.read(signInProvider.notifier);
    return ElevatedButton(
      focusNode: loginButtonFocusNode,
      onPressed: isValidated
          ? () {
        signInController.signInWithEmailAndPassword();
        print('성공$signInState.status');
      }: (){print('실패$signInState.status');},
      child: Text('접속'),
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
        minimumSize: Size(columnWidth + 10, 65),
        padding: EdgeInsets.zero,
      ),
    );
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

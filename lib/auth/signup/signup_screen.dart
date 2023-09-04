import 'package:flutter/material.dart';
import 'package:form_validator/form_validators.dart';
import 'package:web_test2/auth/signup/controller/singup_controller.dart';
import 'package:web_test2/common/component/Gap.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/component/logo.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends StatefulWidget {
  final double columnWidth;
  final FocusNode nameFieldFocusNode;
  final FocusNode emailFieldFocusNode;
  final FocusNode passwordFieldFocusNode;
  final FocusNode loginButtonFocusNode;
  final bool obscureText;
  final VoidCallback obscureIconOnPressed;
  final FocusNode nameOnFieldSubmitted;
  final FocusNode emailOnFieldSubmitted;
  final FocusNode passwordOnFieldSubmitted;

  const SignUpScreen({
    required this.nameFieldFocusNode,
    required this.nameOnFieldSubmitted,
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
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double minLogoWidth = 300.0;
    double logoWidth = screenWidth * 0.1;
    return Column(
      children: [
        CompanyLogo(logoWidth: logoWidth, minLogoWidth: minLogoWidth,),
        const HeightGap(),
        _NameField(
            onFieldSubmitted: widget.nameOnFieldSubmitted,
            nameFieldFocusNode: widget.nameFieldFocusNode,
        ),
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
        const HeightGap(),
        _SignUpButton(
          loginButtonFocusNode: widget.loginButtonFocusNode,
          columnWidth: widget.columnWidth,
        ),
      ],
    );
  }
}
//----------------------------------------------------------------------------
class _NameField extends ConsumerWidget {
  final FocusNode nameFieldFocusNode;
  final FocusNode onFieldSubmitted;

  const _NameField(
      {required this.onFieldSubmitted,
        required this.nameFieldFocusNode,
        super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpProvider);
    final showError = signUpState.name.invalid;
    final signUpController = ref.read(signUpProvider.notifier);
    
    return CustomTextFormField(
      onFieldSubmitted: onFieldSubmitted,
      autofocus: true,
      focusNode: nameFieldFocusNode,
      hintText: '이름 입력',
      errorText: showError
          ? Name.showNameErrorMessage(signUpState.name.error)
          :null,
      onChanged: (name) => signUpController.onNameChange(name),
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
    final signUpState = ref.watch(signUpProvider);
    final showError = signUpState.email.invalid;
    final signUpController = ref.read(signUpProvider.notifier);

    return CustomTextFormField(
      onFieldSubmitted: onFieldSubmitted,
      focusNode: emailFieldFocusNode,
      hintText: '이메일 입력',
      errorText: showError
          ? Email.showEmailErrorMessages(signUpState.email.error)
          : null,
      onChanged: (email) => signUpController.onEmailChange(email),
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
  Widget build(BuildContext context,WidgetRef ref ) {
    final signUpState = ref.watch(signUpProvider);
    final showError = signUpState.password.invalid;
    final signUpController = ref.read(signUpProvider.notifier);
    
    return CustomTextFormField(
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      focusNode: passwordFieldFocusNode,
      hintText: '비밀번호 입력',
      errorText: showError
      ? Password.showPasswordErrorMessage(signUpState.password.error)
      : null,
      onChanged: (password) => signUpController.onPasswordChange(password),
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
class _SignUpButton extends ConsumerWidget {
  final FocusNode loginButtonFocusNode;
  final double columnWidth;

  const _SignUpButton({
    required this.loginButtonFocusNode,
    required this.columnWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpProvider);
    final bool isValidated = signUpState.status.isValidated;
    final signUpController = ref.read(signUpProvider.notifier);

    return ElevatedButton(
      focusNode: loginButtonFocusNode,
      onPressed: isValidated
          ? () {
        signUpController.signUpWithEmailAndPassword();
        print('성공$signUpState.status');
      }: (){print('실패$signUpState.status');},
      child: Text('가입'),
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
        minimumSize: Size(columnWidth + 10, 60),
        padding: EdgeInsets.zero,
      ),
    );
  }
}


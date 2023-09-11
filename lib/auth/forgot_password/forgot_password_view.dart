import 'package:flutter/material.dart';
import 'package:web_test2/common/component/Gap.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/component/hoverText.dart';
import 'package:web_test2/common/component/logo.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/layout/default_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validators.dart';
import 'package:web_test2/common/component/error_dialog.dart';
import 'controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  static String get routeName => 'forgotPassword';

  String _getButtonText(FormzStatus status) {
    if (status.isSubmissionInProgress) {
      return "요청중";
    } else if (status.isSubmissionFailure) {
      return "실패";
    } else if (status.isSubmissionSuccess) {
      return "완료";
    } else {
      return "요청";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final status = forgotPasswordState.status;

    ref.listen<ForgotPasswordState>(
      forgotPasswordProvider,
      (previous, current) {
        if (current.status.isSubmissionFailure) {
          Navigator.of(context).pop();
          ErrorDialog.show(context, '${current.errorMessage}');
        }
      },
    );

    double screenWidth = MediaQuery.of(context).size.width;
    double minLogoWidth = 300.0;
    double logoWidth = screenWidth * 0.1;

    return DefaultLayout(
      defaultWidth: 0.3,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CompanyLogo(logoWidth: logoWidth, minLogoWidth: minLogoWidth),
          const HeightGap(defaultHeight: 20),
          CustomTextFormField(
            errorText: Email.showEmailErrorMessages(forgotPasswordState.email.error),
            autofocus: true,
            hintText: '비밀번호 찾기 이메일 입력',
            onChanged: (email) {
              ref.read(forgotPasswordProvider.notifier).onEmailChange(email);
            },
          ),
          const HeightGap(),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //       width: screenWidth, child: Text('가입할 때 입력했던 정보를 확인합니다.')),
          // ),
          // const HeightGap(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: status.isSubmissionInProgress ||
                          status.isSubmissionSuccess
                      ? null
                      : () {
                          ref
                              .read(forgotPasswordProvider.notifier)
                              .forgotPassword();
                        },
                  child: HoverText(
                    builder: (hovering) {
                      final color =
                          hovering ? CONSTRAINT_PRIMARY_COLOR : PRIMARY_COLOR;
                      return Text(
                        _getButtonText(status),
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
                WidthGap(screenWidth: screenWidth),
                Text("|"),
                WidthGap(screenWidth: screenWidth),
                GestureDetector(
                  onTap: status.isSubmissionInProgress
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: HoverText(
                    builder: (hovering) {
                      final color =
                          hovering ? CONSTRAINT_PRIMARY_COLOR : PRIMARY_COLOR;
                      return Text(
                        '취소',
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
              ],
            ),
          )
        ],
      ),
    );
  }
}

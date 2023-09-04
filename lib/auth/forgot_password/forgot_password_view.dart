import 'package:flutter/material.dart';
import 'package:web_test2/common/component/Gap.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/component/hoverText.dart';
import 'package:web_test2/common/component/logo.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/layout/default_layout.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double minLogoWidth = 300.0;
    double logoWidth = screenWidth * 0.1;

    return  DefaultLayout(
      defaultWidth: 0.3,
      child: Column(
       // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CompanyLogo(logoWidth: logoWidth, minLogoWidth: minLogoWidth),
          const HeightGap(defaultHeight: 50),
          _EmailField(),
          const HeightGap(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth,
                child: Text('가입할 때 입력했던 정보를 확인합니다.')),
          ),
          const HeightGap(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Request(),
                WidthGap(screenWidth: screenWidth),
                Text("|"),
                WidthGap(screenWidth: screenWidth),
                _Cancel(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      autofocus: true,
      hintText: '비밀번호 찾기 이메일 입력',
      onChanged: (value) {},
    );
  }
}

class _Cancel extends StatelessWidget {
  final VoidCallback onTap;
  const _Cancel({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: HoverText(
        builder: (hovering) {
          final color = hovering ? CONSTRAINT_PRIMARY_COLOR : PRIMARY_COLOR;
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
    );
  }
}

class _Request extends StatelessWidget {
  const _Request({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: HoverText(
        builder: (hovering) {
          final color = hovering ? CONSTRAINT_PRIMARY_COLOR : PRIMARY_COLOR;
          return Text(
            '전송',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: color,
              decoration: TextDecoration.none,
            ),
          );
        },
      ),
    );
  }
}


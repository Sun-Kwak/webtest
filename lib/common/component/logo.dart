import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_test2/common/component/side_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';

class CompanyLogo extends StatelessWidget {
  final double logoWidth;
  final double minLogoWidth;

  const CompanyLogo(
      {required this.logoWidth, required this.minLogoWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "asset/LAVIDA_LOGO.svg",
      width: logoWidth < minLogoWidth
          ? minLogoWidth
          : logoWidth, // 최대 너비를 넘지 않도록 조정
      fit: BoxFit.contain,
      key: ValueKey('SignIn'),
    );
  }
}

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularSvgImage(
      assetPath: "asset/btn_google.svg",
      borderColor: INPUT_BORDER_COLOR,
      borderWidth: 1,
      radius: 25.0,
    );
  }
}

class AppleLogo extends StatelessWidget {
  const AppleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularSvgImage(
      assetPath: "asset/btn_apple.svg",
      borderColor: INPUT_BORDER_COLOR,
      borderWidth: 1,
      radius: 25.0,
    );
  }
}

class KaKaoLogo extends StatelessWidget {
  const KaKaoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularSvgImage(
      assetPath: "asset/btn_kakao.svg",
      borderColor: INPUT_BORDER_COLOR,
      borderWidth: 0,
      radius: 25.0,
      padding: 0,
    );
  }
}

class NaverLogo extends StatelessWidget {
  const NaverLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularSvgImage(
      assetPath: "asset/btn_naver.svg",
      borderColor: INPUT_BORDER_COLOR,
      borderWidth: 0,
      radius: 25.0,
      padding: 0,
    );
  }
}

//---------------------------------------------------------------------------

class CircularSvgImage extends StatelessWidget {
  final String assetPath;
  final double radius;
  final Color borderColor;
  final double borderWidth;
  final double? padding;

  const CircularSvgImage({
    super.key,
    this.padding = 8.0,
    required this.assetPath,
    required this.radius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 2 * radius,
        height: 2 * radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding!),
          child: SvgPicture.asset(
            assetPath,
            width: 2 * radius,
            height: 2 * radius,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:web_test2/common/component/animated_Object.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/error_dialog.dart';
import 'package:web_test2/common/extensions/hover_extensions.dart';
import 'package:web_test2/common/view/splash_screen.dart';
import 'package:web_test2/screen/auth/social_signin/controller/google_signin_controller.dart';
import 'package:web_test2/screen/auth/social_signin/controller/kakao_signin_controller.dart';
import 'package:web_test2/screen/user_profile.dart';

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

class GoogleLogo extends ConsumerWidget {
  // LoadingSheet.show(context)
  const GoogleLogo({super.key});



  @override
  Widget build(BuildContext context,WidgetRef ref) {

    ref.listen<GoogleSignInState>(googleSignInProvider, (previous, current) {
      if (current == GoogleSignInState.loading){
        LoadingSheet.show(context);
      } else if (current == GoogleSignInState.error) {
        Navigator.of(context).pop();
        ErrorDialog.show(context, "구글 로그인 실패");
      } else {
        Navigator.of(context).pop();
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
        // context.goNamed(UserProfile.routeName);
      }
    });
    return AnimatedObject(
      onTap: (){
        ref.read(googleSignInProvider.notifier).signInWithGoogle();
      },
      child: CircularSvgImage(
        assetPath: "asset/btn_google.svg",
        borderColor: INPUT_BORDER_COLOR,
        borderWidth: 1,
        radius: 25.0,
      ).showCursorOnHover,
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
    ).showCursorOnHover;
  }
}

class KaKaoLogo extends ConsumerWidget {
  const KaKaoLogo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<KakaoSignInState>(kakaoSignInProvider, (previous, current) {
      if (current == KakaoSignInState.loading){
        LoadingSheet.show(context);
      } else if (current == KakaoSignInState.error) {
        Navigator.of(context).pop();
        ErrorDialog.show(context, "카카오 로그인 실패");
      } else if (current == KakaoSignInState.success){
        Navigator.of(context).pop();
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()));
      } else {
        Navigator.of(context).pop();
      }
    });
    return AnimatedObject(
      onTap: (){
        ref.read(kakaoSignInProvider.notifier).signInWithKakao();

      },
      child: CircularSvgImage(
        assetPath: "asset/btn_kakao.svg",
        borderColor: INPUT_BORDER_COLOR,
        borderWidth: 0,
        radius: 25.0,
        padding: 0,
      ).showCursorOnHover,
    );
  }
}

class NaverLogo extends ConsumerWidget {
  const NaverLogo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return AnimatedObject(
      onTap: (){
      },
      child: const CircularSvgImage(
        assetPath: "asset/btn_naver.svg",
        borderColor: INPUT_BORDER_COLOR,
        borderWidth: 0,
        radius: 25.0,
        padding: 0,
      ).showCursorOnHover,
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

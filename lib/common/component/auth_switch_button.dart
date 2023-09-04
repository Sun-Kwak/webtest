import 'package:flutter/material.dart';
import 'package:web_test2/common/component/hoverText.dart';
import 'package:web_test2/common/component/side_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';

class AutoSwitchButton extends StatelessWidget {
  final bool showSignIn;
  final VoidCallback onTap;

  const AutoSwitchButton({
    required this.onTap,
    required this.showSignIn,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // width: 200,
          // height: 100,
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: HoverText(
            isUp: true,
            builder: (hovering) {
              final color = hovering ? CONSTRAINT_PRIMARY_COLOR : PRIMARY_COLOR;
              return SlideFadeSwitcher(
                child: Text(
                  showSignIn ? '간편 회원가입' : '로그인 페이지',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: color,
                    decoration: TextDecoration.none,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

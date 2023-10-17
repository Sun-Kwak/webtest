import 'package:flutter/material.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';

class MemberVOCForm extends StatelessWidget {
  const MemberVOCForm({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double formWidth = screenWidth >= 712 ? 580 : screenWidth >= 640 ? screenWidth *0.82 : screenWidth -20;
    return CustomBoxRadiusForm(
      width: formWidth,
      title: '회원상담',
      height: 820,
      child: const Column(
        children: [],
      ),
    );
  }
}

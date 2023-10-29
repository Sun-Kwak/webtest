import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';

class MemberInforForm extends ConsumerWidget {
  final Member member;
  const MemberInforForm({
    required this.member,
    super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double formWidth = screenWidth >= 650 ? 535 : screenWidth >= 640 ? screenWidth *0.82 : screenWidth-20;
    final double widgetGap = screenWidth >= 650 ?  20 : 8;
    final double textBoxWidth = screenWidth >= 650 ?  170 : formWidth * 0.33;
    final double labelBoxWidth = screenWidth >= 650 ?  50 : formWidth * 0.1;
    return CustomBoxRadiusForm(
      width: formWidth,
      height: 290,
      title: '생성정보',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30,),
          Row(
            children: [
              const SizedBox(width: 20,),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                label: '회원번호',
                outputText: member.id == 0 ? '' :member.id.toString(),
                textBoxWidth: textBoxWidth,
              ),
              SizedBox(
                width: widgetGap,
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const SizedBox(width: 20,),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                label: '계약상태',
                outputText: member.id == 0 ? '' :member.contractStatus!,
                textBoxWidth: textBoxWidth,
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                label: '추천인수',
                outputText: member.id == 0 ? '' :member.referralCount.toString(),
                textBoxWidth: textBoxWidth,
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const SizedBox(width: 20,),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                label: '첫수강일',
                outputText: member.firstDate ?? '',
                textBoxWidth: textBoxWidth,
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                label: '종료예정',
                outputText: member.expiryDate ?? '',
                textBoxWidth: textBoxWidth,
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const SizedBox(width: 20,),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                label: '총납부금',
                outputText: member.id == 0 ? '' : member.totalFee.toString(),
                textBoxWidth: textBoxWidth,
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                label: '총출석일',
                outputText: member.id == 0 ? '' : member.totalAttendanceDays.toString(),
                textBoxWidth: textBoxWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

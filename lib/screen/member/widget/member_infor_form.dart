import 'package:flutter/material.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';

class MemberInforForm extends StatelessWidget {
  const MemberInforForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomBoxRadiusForm(
      height: 290,
      title: '계약정보',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Row(
            children: [
              CustomTextOutputWidget(
                label: '회원번호',
                outputText: '',
              ),
              SizedBox(
                width: 35,
              ),
              CustomTextOutputWidget(
                label: '계약상태',
                outputText: '',
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              CustomTextOutputWidget(
                label: '나이',
                outputText: '',
              ),
              SizedBox(
                width: 35,
              ),
              CustomTextOutputWidget(
                label: '추천인수',
                outputText: '',
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              CustomTextOutputWidget(
                label: '첫 수강일',
                outputText: '',
              ),
              SizedBox(
                width: 35,
              ),
              CustomTextOutputWidget(
                label: '수강종료일',
                outputText: '',
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              CustomTextOutputWidget(
                label: '총 납부금액',
                outputText: '',
              ),
              SizedBox(
                width: 35,
              ),
              CustomTextOutputWidget(
                label: '총 출석일',
                outputText: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

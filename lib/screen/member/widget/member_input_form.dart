import 'package:flutter/material.dart';
import 'package:web_test2/common/component/input_widget/custom_dateSelection_input_widget.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/input_widget/custom_dropdown_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_genderSelection_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_text_input_widget.dart';
import 'package:web_test2/common/const/colors.dart';

class MemberInputForm extends StatefulWidget {
  const MemberInputForm({super.key});

  @override
  State<MemberInputForm> createState() => _MemberInputFormState();
}

class _MemberInputFormState extends State<MemberInputForm> {
  final double height = 40;
  String selectedValue = '지인소개';
  final List<String> dropdownItems = [
    '지인소개',
    '신문광고',
    '전단지',
    '배너',
    'SNS',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBoxRadiusForm(
      title: '회원가입',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '필수정보',
                style: TextStyle(fontSize: 14),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.refresh),
                tooltip: '새로고침',
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              CustomTextInputWidget(
                label: '성함',
                hintText: '2글자 이상',
                onChanged: (v) {},
                isRequired: true,
              ),
              SizedBox(
                width: 35,
              ),
              CustomGenderSelectionInputWidget(),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              CustomDateSelectionInputWidget(
                label: '생년월일',
                isRequired: true,
              ),
              CustomTextInputWidget(
                label: '전화번호',
                hintText: '숫자만 입력',
                onChanged: (v) {},
                isRequired: true,
              ),
            ],
          ),

          SizedBox(
            height: 20,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Text(
            '추가정보',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              CustomTextInputWidget(
                label: '행정동',
                hintText: '자유기입',
                onChanged: (v) {},
              ),
              SizedBox(
                width: 35,
              ),
              CustomDropdownInputWidget(
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
                label: '등록경위',
                dropdownItems: dropdownItems,
                selectedValue: selectedValue,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CustomTextInputWidget(
                label: '추천인',
                hintText: '검색',
                onChanged: (v) {},
              ),
              SizedBox(
                width: 35,
              ),
              CustomTextInputWidget(
                label: '계정연결',
                hintText: '검색',
                onChanged: (v) {},
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          LargeTextInputWidget(
            label: '메모',
            hintText: '덮어쓰기',
            onChanged: (v) {},
          ),
          //
          // SizedBox(height: 10,),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 100,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  onPressed: () {},
                  child: Text('저장'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
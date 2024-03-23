//
//
// import 'package:flutter/material.dart';
// import 'package:web_test2/common/const/colors.dart';
// import 'package:web_test2/screen/member/member_view.dart';
//
// class MemberInputFormTest extends StatefulWidget {
//   const MemberInputFormTest({super.key});
//
//   @override
//   State<MemberInputFormTest> createState() => _MemberInputFormTestState();
// }
//
// class _MemberInputFormTestState extends State<MemberInputFormTest> {
//   final double height = 40;
//   String selectedValue = '지인소개';
//   final List<String> dropdownItems = [
//     '지인소개',
//     '신문광고',
//     '전단지',
//     '배너',
//     'SNS',
//     '기타',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       width: 550,
//       height: 650,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '필수정보',
//                   style: TextStyle(fontSize: 15),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.refresh),
//                   tooltip: '새로고침',
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             GeneralTextInputWidget(
//               label: '성함',
//               hintText: '2글자 이상',
//               onChanged: (v) {},
//               isRequired: true,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             GenderSelectionForm(),
//             SizedBox(
//               height: 10,
//             ),
//             DateSelectionForm(
//               lable: '생년월일',
//               isRequired: true,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             GeneralTextInputWidget(
//               label: '전화번호',
//               hintText: '숫자만 입력',
//               onChanged: (v) {},
//               isRequired: true,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Divider(),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               '추가정보',
//               style: TextStyle(fontSize: 15),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             GeneralTextInputWidget(
//               label: '행정동',
//               hintText: '자유기입',
//               onChanged: (v) {},
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             GeneralDropdownInputWidget(
//               onChanged: (String? value) {
//                 setState(() {
//                   selectedValue = value!;
//                 });
//               },
//               label: '등록경위',
//               dropdownItems: dropdownItems,
//               selectedValue: selectedValue,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 GeneralTextInputWidget(
//                   label: '추천인',
//                   hintText: '검색',
//                   onChanged: (v) {},
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             LargeTextInputWidget(
//               label: '메모',
//               hintText: '덮어쓰기',
//               onChanged: (v) {},
//             ),
//             SizedBox(height: 20,),
//             Center(
//               child: SizedBox(
//                 width: 100,
//                 height: 30,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: PRIMARY_COLOR,
//                   ),
//                   onPressed: (){},
//                   child: Text('저장'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

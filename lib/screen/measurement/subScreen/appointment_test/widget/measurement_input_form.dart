import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validators.dart';
import 'package:web_test2/common/component/custom_message_screen.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/error_dialog.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/input_widget/custom_dateSelection_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_dropdown_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_genderSelection_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_seachable_dropdown_input_widget.dart';
import 'package:web_test2/common/component/input_widget/memberinput_member_search_dropdown_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_search_text_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_text_input_widget.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:authentication_repository/src/signedIn_user_provider.dart';
import 'package:web_test2/screen/member/controller/member_input_controller.dart';
import 'package:web_test2/screen/member/controller/member_input_state.dart';

class MeasurementInputForm extends ConsumerStatefulWidget {
  const MeasurementInputForm({
    super.key,
  });

  @override
  ConsumerState<MeasurementInputForm> createState() =>
      MeasurementInputFormState();
}

class MeasurementInputFormState extends ConsumerState<MeasurementInputForm> {

  DateTime today = DateTime.now();
  DateTime? selectedDate;
  late List<Employee> employees;
  String? searchSelectedValue;
  String? selectedMember;

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime threeYearsLater =
    now.add(const Duration(days: 3 * 365)); // 3 years later from now

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2023),
      lastDate: threeYearsLater,
    );

    if (pickedDate != null) {
      // String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {
        selectedDate = pickedDate;
      });
    //   // memberInputController.onDateChange(formattedDate);
    // }  else{
    //   // memberInputController.onDateChange('날짜 선택');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employees =[];
  }


  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeeProvider);
    final members = ref.watch(membersProvider);
    final selectedPIC = ref.watch(selectedPICProvider);
    final memberFromInput = ref.watch(selectedMemberProvider);
    final selectedMemberIDController = ref.watch(selectedMemberIdProvider.notifier);
    final selectedPICController = ref.watch(selectedPICIdProvider.notifier);
    final selectedDropdownData = ref.watch(selectedDropdownIDProvider);
    DateTime today = DateTime.now();
    DateTime birthDate = memberFromInput.id != 0 ? DateFormat('yyyy-MM-dd').parse(memberFromInput.birthDay) : DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    // ref.listen<MemberInputState>(
    //   memberInputProvider,
    //       (previous, current) {
    //     if (current.status.isSubmissionInProgress) {
    //       LoadingSheet.show(context);
    //     } else if (current.status.isSubmissionFailure) {
    //       CustomMessageScreen.showMessage(context, '${current.errorMessage}',
    //           Colors.red, Icons.dangerous_outlined);
    //       // ErrorDialog.show(context, '${current.errorMessage}');
    //     } else if (current.status.isSubmissionSuccess) {
    //       Navigator.of(context).pop();
    //       CustomMessageScreen.showMessage(
    //           context, '저장', Colors.white, Icons.check);
    //     }
    //   },
    // );
   final screenWidth = MediaQuery.of(context).size.width;
    final double widgetGap = screenWidth >= 650 ? 20 : 8;
    const double textBoxWidth = 170;
    const double labelBoxWidth = 50;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      width: 1150,
      height: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Expanded(
                child: Text(
                  '기본정보',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              CustomRefreshIcon(onPressed: () {
                // widget.inputButtonsOnPressed();
              }),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              // CustomTextOutputWidget(
              //     labelBoxWidth: labelBoxWidth,
              //     textBoxWidth: textBoxWidth,
              //     outputText: '', label: '측정날짜'),
              // SizedBox(
              //   width: widgetGap,
              // ),
              CustomSearchDropdownWidget(
                idSelector: (employee) => employee.id,
                labelBoxWidth: labelBoxWidth,
                selectedValue: selectedPIC.displayName,
                label: '담당자',
                textBoxWidth: textBoxWidth,
                list: employees,
                titleSelector: (employee) => employee.displayName,
                subtitleSelector: (employee) => employee.email,
                onTap: (){
                  // selectedPICController.setSelectedRow(newValue)
                },
                color: CUSTOM_BLUE.withOpacity(0.1),
                // exclusiveId: 0,
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomDateSelectionInputWidget(
                color: CUSTOM_BLUE.withOpacity(0.1),
                textBoxWidth: textBoxWidth,
                  errorText: null,
                  onTap: (){
                    _selectDate(context);
                  },
                  selectedDate: selectedDate ?? today,
                  labelBoxWidth: labelBoxWidth,
                  label: '날짜선택',
              ),

            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                '회원정보',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              CustomSearchDropdownWidget(
                showId: true,
                labelBoxWidth: labelBoxWidth,
                selectedValue: selectedDropdownData.title,
                idSelector: (member) => member.id,
                label: '회원',
                textBoxWidth: textBoxWidth,
                list: members,
                titleSelector: (member) => member.displayName,
                subtitleSelector: (member) => member.phoneNumber,
                onTap: (){
                  // selectedMemberIDController.setSelectedRow();
                  // setState(() {
                  //   selectedMember.
                  // });
                },
                color: CUSTOM_BLUE.withOpacity(0.1),
                // exclusiveId: 0,
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 20,),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: memberFromInput.id == 0 ? '' : memberFromInput.gender, label: '성별'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: memberFromInput.phoneNumber, label: '전화번호'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: memberFromInput.birthDay, label: '생년월일'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: age.toString(), label: '나이'),
            ],

          ),
          ElevatedButton(onPressed: (){
            print(selectedDropdownData.id);
            print(selectedDropdownData.title);
          }, child: Text('버튼'))
        ],
      ),
    );
  }
}

//----------------------------------------------------------------------------
class _AddMemberButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final Member member;

  const _AddMemberButton({
    required this.onPressed,
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberInputState = ref.watch(memberInputProvider);
    final bool isValidated = memberInputState.status.isValidated;
    final memberInputController = ref.read(memberInputProvider.notifier);
    final membersController = ref.read(membersProvider.notifier);

    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: isValidated
            ? () {

                memberInputController.addMember(member, membersController);
                onPressed();
              }
            : () {
                CustomMessageScreen.showMessage(
                    context, '필수값 확인', Colors.amber, Icons.info_outline);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          padding: EdgeInsets.zero,
        ),
        child: const Text('등록'),
      ),
    );
  }
}

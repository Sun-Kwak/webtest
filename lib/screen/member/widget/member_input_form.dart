import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validators.dart';
import 'package:web_test2/common/component/custom_message_screen.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/error_dialog.dart';
import 'package:web_test2/common/component/input_widget/custom_dateSelection_input_widget.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/input_widget/custom_dropdown_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_genderSelection_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_phone_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_seachable_dropdown_input_widget.dart';
import 'package:web_test2/common/component/input_widget/memberinput_member_search_dropdown_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_search_text_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_text_input_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/member/controller/member_input_controller.dart';
import 'package:web_test2/screen/member/controller/member_input_state.dart';
import 'package:authentication_repository/src/members_repository.dart';

// final memberInputFormStateProvider = StateProvider<MemberInputFormState>((ref) {
//   return MemberInputFormState();
// });

class MemberInputForm extends ConsumerStatefulWidget {
  final Member member;
  final bool isEditing;
  final VoidCallback onSavePressed;
  final VoidCallback onRefreshPressed;

  const MemberInputForm({
    required this.onSavePressed,
    required this.onRefreshPressed,
    required this.isEditing,
    required this.member,
    super.key,
  });

  @override
  ConsumerState<MemberInputForm> createState() => MemberInputFormState();
}

class MemberInputFormState extends ConsumerState<MemberInputForm> {
  late Member updatingMember;
  String? errorText;
  final double height = 40;
  DateTime? selectedDate;
  String selectedValue = '기타';
  String? selectedGender;
  String? searchSelectedValue;
  String formattedDate ="${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  final List<String> dropdownItems = [
    '기타',
    '지인소개',
    '신문광고',
    '전단지',
    '배너',
    'SNS',
  ];
  @override
  void initState() {
    // member = widget.member;
    // selectedGender = member.gender;
    super.initState();
    updatingMember = widget.member;
    nameController.text = widget.member.displayName;
    phoneNumberController.text = widget.member.phoneNumber;
    addressController.text = widget.member.address ?? '';
    memoController.text = widget.member.memo ?? '';
    selectedDate = widget.member.birthDay != '' ? DateFormat('yyyy-MM-dd').parse(widget.member.birthDay) : null;
    selectedValue = widget.member.signUpPath;
    searchSelectedValue = widget.member.referralName;
  }

  final List<String> referralDropdownItems = [];

  void resetFields() {
    final selectedRowController = ref.watch(selectedMemberIdProvider.notifier);
    final isEditingController = ref.watch(memberEditingProvider.notifier);
    final memberInputController = ref.watch(memberInputProvider.notifier);
    // final selectedReferralController =
    //     ref.watch(selectedReferralIDProvider.notifier);

    setState(() {
      selectedRowController.setSelectedRow(0);
      // selectedReferralController.setSelectedReferralID(null, null);
      isEditingController.toggleStatus(false);
      memberInputController.resetAll();
      updatingMember = Member.empty();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final selectedMember = ref.watch(selectedMemberProvider);
    final selectedRow = ref.watch(selectedMemberIdProvider);
    DateTime birthDay = selectedRow != 0
        ? DateFormat('yyyy-MM-dd').parse(selectedMember.birthDay)
        : DateTime.now();
    final memberInputController = ref.read(memberInputProvider.notifier);
    DateTime now = DateTime.now();
    DateTime threeYearsLater =
        now.add(const Duration(days: 3 * 365)); // 3 years later from now

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: birthDay,
      firstDate: DateTime(1900),
      lastDate: threeYearsLater,
    );

    if (pickedDate != null) {
      setState(() {
        setState(() {
          selectedDate = pickedDate;
          formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        });
      });
      memberInputController.onDateChange(formattedDate);
    } else {
      memberInputController.onDateChange('날짜 선택');
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    // final selectedReferral = ref.watch(selectedReferralIDProvider);
    // final selectedReferralController =
    //     ref.watch(selectedReferralIDProvider.notifier);
    final selectedDropdownData = ref.watch(selectedDropdownIDProvider);
    ref.listen<MemberInputState>(
      memberInputProvider,
      (previous, current) {
        if (current.status.isSubmissionInProgress) {
          LoadingSheet.show(context);
        } else if (current.status.isSubmissionFailure) {
          CustomMessageScreen.showMessage(context, '${current.errorMessage}',
              Colors.red, Icons.dangerous_outlined);
          // ErrorDialog.show(context, '${current.errorMessage}');
        } else if (current.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
          CustomMessageScreen.showMessage(
              context, '저장', Colors.white, Icons.check);
        }
      },
    );

    final double screenWidth = MediaQuery.of(context).size.width;
    final double formWidth = screenWidth >= 650
        ? 535
        : screenWidth >= 640
            ? screenWidth * 0.82
            : screenWidth - 20;
    final double widgetGap = screenWidth >= 650 ? 20 : 8;
    final double textBoxWidth = screenWidth >= 650 ? 170 : formWidth * 0.33;
    final double labelBoxWidth = screenWidth >= 650 ? 50 : formWidth * 0.1;
    final double largeTextBoxWidth =
        (textBoxWidth * 2) + labelBoxWidth + 10 + widgetGap;

    return CustomBoxRadiusForm(
      width: formWidth,
      title: '회원가입',
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
                  '필수정보',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              CustomRefreshIcon(onPressed: () {
                resetFields();
                widget.onRefreshPressed();
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
              _NameField(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                controller: nameController,
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomGenderSelectionInputWidget(
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                onChanged: (String? value) {
                  setState(() {
                    updatingMember = updatingMember.copyWith(gender: value);
                  });
                },
                selectedGender: updatingMember.gender,
              ),
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
              _BirthDayField(
                onTap: () {
                  _selectDate(context);
                },
                selectedDate: selectedDate,
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
              ),
              SizedBox(
                width: widgetGap,
              ),
              _PhoneField(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                controller: phoneNumberController,
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
                '추가정보',
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
              CustomTextInputWidget(
                controller: addressController,
                labelBoxWidth: labelBoxWidth,
                label: '행정동',
                hintText: '자유기입',
                onChanged: (v) {
                  setState(() {
                    updatingMember = updatingMember.copyWith(
                      address: v,
                    );
                  });
                },
                textBoxWidth: textBoxWidth,
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomDropdownInputWidget(
                labelBoxWidth: labelBoxWidth,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value!;
                    updatingMember = updatingMember.copyWith(
                      signUpPath: value,
                    );
                  });
                },
                label: '등록경위',
                dropdownItems: dropdownItems,
                selectedValue: selectedValue,
                textBoxWidth: textBoxWidth,
              ),
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
              CustomSearchDropdownWidget(
                idSelector: (member) => member.id,
                labelBoxWidth: labelBoxWidth,
                selectedValue: searchSelectedValue,
                label: '추천인',
                textBoxWidth: textBoxWidth,
                list: members,
                titleSelector: (member) => member.displayName,
                subtitleSelector: (member) => member.phoneNumber,
                onTap: () {
                  searchSelectedValue = selectedDropdownData.selectedTitle!;
                  setState(() {
                    updatingMember = updatingMember.copyWith(
                      referralID: selectedDropdownData.selectedId,
                      referralName: selectedDropdownData.selectedTitle,
                    );
                  });
                  // selectedReferralController.setSelectedReferralID(
                  //     selectedDropdownData.selectedId,
                  //     selectedDropdownData.selectedTitle);
                },
                // color: CUSTOM_BLUE.withOpacity(0.1),
                errorText: null,
                exclusiveId: updatingMember.id,
                // exclusiveId: 0,
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomSearchTextInputWidget(
                labelBoxWidth: labelBoxWidth,
                child: const Center(),
                dropdownItems: [],
                selectedValue: '',
                onChanged: (v) {
                  setState(() {
                    updatingMember = updatingMember.copyWith(
                      accountLinkID: v,
                    );
                  });
                },
                label: '계정연결',
                textBoxWidth: textBoxWidth,
              ),
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
              LargeTextInputWidget(
                labelBoxWidth: labelBoxWidth,
                controller: memoController,
                label: '메모',
                hintText: '덮어쓰기',
                onChanged: (v) {
                  setState(() {
                    updatingMember = updatingMember.copyWith(
                      memo: v,
                    );
                  });
                },
                textBoxWidth: largeTextBoxWidth,
              ),
            ],
          ),
          //
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 100,
                child: _AddMemberButton(
                  onPressed: () {

                    widget.onSavePressed();
                    // resetFields();
                    // updatingMember = Member.empty();
                  },
                  member: updatingMember,
                ),
              ),
            ),
          ),
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
    final selectedMeasurementController = ref.watch(selectedMeasurementProvider.notifier);

    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: isValidated
            ? () {
                memberInputController.addMember(member, membersController);
                selectedMeasurementController.removeState();
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

//------------------------------------------------------------------------------------------
class _NameField extends ConsumerWidget {
  // final FocusNode nameFieldFocusNode;
  // final FocusNode onFieldSubmitted;
  final double labelBoxWidth;
  final double textBoxWidth;

  final TextEditingController controller;

  const _NameField({
    required this.labelBoxWidth,
    required this.textBoxWidth,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberInputState = ref.watch(memberInputProvider);
    final showError = memberInputState.name.invalid;
    final memberInputController = ref.read(memberInputProvider.notifier);

    return CustomTextInputWidget(
      onChanged: (name) => memberInputController.onNameChange(name),
      labelBoxWidth: labelBoxWidth,
      controller: controller,
      label: '성함',
      hintText: '2글자 이상',
      isRequired: true,
      textBoxWidth: textBoxWidth,
      errorText: showError
          ? Name.showNameErrorMessage(memberInputState.name.error)
          : null,
    );
  }
}

//---------------------------------------------------------------------------------------------
class _BirthDayField extends ConsumerWidget {
  final double labelBoxWidth;
  final double textBoxWidth;
  final DateTime? selectedDate;
  final GestureTapCallback onTap;

  const _BirthDayField({
    required this.selectedDate,
    required this.onTap,
    required this.labelBoxWidth,
    required this.textBoxWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberInputState = ref.watch(memberInputProvider);
    final showError = memberInputState.date.invalid;

    return CustomDateSelectionInputWidget(
      onTap: onTap,
      selectedDate: selectedDate,
      labelBoxWidth: labelBoxWidth,
      // onTap: onTap,
      label: '생년월일',
      isRequired: true,
      textBoxWidth: textBoxWidth,
      errorText: showError
          ? Date.showDateErrorMessage(memberInputState.date.error)
          : null,
    );
  }
}

//---------------------------------------------------------------------------------------------
class _PhoneField extends ConsumerStatefulWidget {
  final double labelBoxWidth;
  final double textBoxWidth;
  final TextEditingController controller;

  const _PhoneField({
    required this.labelBoxWidth,
    required this.textBoxWidth,
    required this.controller,
  });

  @override
  ConsumerState<_PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends ConsumerState<_PhoneField> {
  Stream<bool> _verifyPhoneNumber(String phone) async* {


    if (phone.length == 13) {
      final memberRepository = ref.read(memberRepositoryProvider);
      bool isPhoneNumberDuplicate =
          await memberRepository.checkPhoneNumber(phone);
      yield !isPhoneNumberDuplicate;
    } else {
      yield false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberInputState = ref.watch(memberInputProvider);
    final showError = memberInputState.phone.invalid;
    final memberInputController = ref.read(memberInputProvider.notifier);
    bool showIcon = widget.controller.text.length == 13;

    return Row(
      children: [
        CustomPhoneInputWidget(
          onChanged: (phone) {
            memberInputController.onPhoneChange(phone);
          },
          labelBoxWidth: widget.labelBoxWidth,
          controller: widget.controller,
          label: '전화번호',
          isRequired: true,
          textBoxWidth: widget.textBoxWidth,
          errorText: showError
              ? Phone.showPhoneErrorMessages(memberInputState.phone.error)
              : null,
        ),
        const SizedBox(
          width: 5,
        ),
        StreamBuilder<bool>(
          stream: _verifyPhoneNumber(widget.controller.text),
          initialData: false, // 초기값 설정
          builder: (context, snapshot) {
            if (!showIcon) {
              return const SizedBox();
            } else {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else {
                if (snapshot.data == true) {
                  return const Tooltip(
                      message: '확인',
                      child: Icon(
                        Icons.verified_outlined,
                        color: Colors.blueGrey,
                      ));
                } else if (snapshot.data == false) {
                  return Tooltip(
                    message: '중복',
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showIcon = false;
                        });
                        widget.controller.text = '010-';
                      },
                      child: const Icon(Icons.dangerous_outlined,
                          color: Colors.redAccent),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
            }
          },
        ),
      ],
    );
  }
}

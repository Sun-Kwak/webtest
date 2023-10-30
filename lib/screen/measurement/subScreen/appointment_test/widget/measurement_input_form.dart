import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validators.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/input_widget/custom_dateSelection_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_number_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_seachable_dropdown_input_widget.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/utils/time_utils.dart';
import 'package:web_test2/common/utils/vo2_max_utils.dart';
import 'package:web_test2/screen/measurement/subScreen/appointment_test/provider/appointment_provider.dart';
import 'package:web_test2/screen/measurement/subScreen/appointment_test/widget/intensity_setting.dart';
import 'package:web_test2/screen/member/controller/member_input_controller.dart';

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
  String? selectedValue = 'Karvonen';
  double userHeight = 0;
  double userWeight = 0;
  double? bMI;
  String exhaustionTime ='';
  int? exhaustionSeconds =0;
  int? bpmMax = 0;
  int? bpm1m = 0;
  int? bpm2m = 0;
  int? bpm3m = 0;
  int? hrr1 = 0;
  int? hrr2 = 0;
  int? hrr3 = 0;
  double? Vo2Max = 0;




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

  void _onHeightChanged(String value) {
    setState(() {
      userHeight = double.tryParse(value) ?? 0;
    });
    calculateBMI();
  }

  void _onWeightChanged(String value) {
    setState(() {
      userWeight = double.tryParse(value) ?? 0;
    });
    calculateBMI();
  }

  void _onBpmMaxChanged(String value) {
    try {
      setState(() {
        bpmMax = int.parse(value);
        if (bpm1m != 0) {
          hrr1 = bpmMax! - bpm1m!;
        }
        if (bpm2m != 0) {
          hrr2 = bpmMax! - bpm2m!;
        }
        if (bpm3m != 0) {
          hrr3 = bpmMax! - bpm3m!;
        }
      });
    } catch (e) {
      setState(() {
        hrr1 = 0;
        hrr2 = 0;
        hrr3 = 0;
      });
    }
  }





  void _onBpm1mChanged(String value) {
    try {
      int parsedValue = int.parse(value);
      setState(() {
        bpm1m = parsedValue;
        if (bpmMax == 0 || bpm1m == 0) {
          hrr1 = 0;
        } else {
          hrr1 = bpmMax! - bpm1m!;
        }
      });
    } catch (e) {
      setState(() {
        bpm1m = null;
        hrr1 = 0;
      });
    }
  }

  void _onBpm2mChanged(String value) {
    try {
      int parsedValue = int.parse(value);
      setState(() {
        bpm2m = parsedValue;
        if (bpmMax == 0 || bpm2m == 0) {
          hrr2 = 0;
        } else {
          hrr2 = bpmMax! - bpm2m!;
        }
      });
    } catch (e) {
      setState(() {
        bpm2m = null;
        hrr2 = 0;
      });
    }
  }

  void _onBpm3mChanged(String value) {
    try {
      int parsedValue = int.parse(value);
      setState(() {
        bpm3m = parsedValue;
        if (bpmMax == 0 || bpm3m == 0) {
          hrr3 = 0;
        } else {
          hrr3 = bpmMax! - bpm3m!;
        }
      });
    } catch (e) {
      setState(() {
        bpm3m = null;
        hrr3 = 0;
      });
    }
  }

  void calculateBMI() {
    double heightInMeter = userHeight / 100;
    double bmi = userWeight / (heightInMeter * heightInMeter);
    setState(() {
      bMI = double.parse(bmi.toStringAsFixed(2));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employees = [];
  }

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeeProvider);
    final members = ref.watch(membersProvider);
    final selectedPIC = ref.watch(selectedPICProvider);
    final memberFromInput = ref.watch(selectedMemberProvider);
    final selectedMemberIdController = ref.watch(selectedMemberIdProvider.notifier);
    final selectedMemberIDController =
        ref.watch(selectedMemberIdProvider.notifier);
    final selectedPICController = ref.watch(selectedPICIdProvider.notifier);
    final selectedDropdownData = ref.watch(selectedDropdownIDProvider);
    final intensityController = ref.watch(intensitySelectionProvider.notifier);
    final intensityState = ref.watch(intensitySelectionProvider);

    DateTime today = DateTime.now();
    DateTime birthDate = memberFromInput.id != 0
        ? DateFormat('yyyy-MM-dd').parse(memberFromInput.birthDay)
        : DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    double? karMax = (220 - age) as double?;
    double kar90 = karMax! * 0.9;
    double tanMax = 208 - (0.7*age);
    double tan90 = tanMax * 0.9;
    double bpm =0;
    double intensityMax = 0;
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
      width: 1040,
      height: 1350,
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
                showId: true,
                labelBoxWidth: labelBoxWidth,
                selectedValue: memberFromInput.displayName,
                // selectedValue: selectedDropdownData.title,
                idSelector: (member) => member.id,
                label: '회원',
                textBoxWidth: textBoxWidth,
                list: members,
                titleSelector: (member) => member.displayName,
                subtitleSelector: (member) => member.phoneNumber,
                onTap: () {
                  selectedMemberIdController.setSelectedRow(selectedDropdownData.selectedId);
                  setState(() {
                    selectedValue = 'Karvonen';
                      intensityMax = karMax;
                    intensityController.setSelectedIntensityValue(intensityMax, bpm);
                  });

                },
                color: CUSTOM_BLUE.withOpacity(0.1),
                // exclusiveId: 0,
              ),

              SizedBox(
                width: labelBoxWidth + textBoxWidth + (widgetGap * 2) + 10,
              ),
              CustomSearchDropdownWidget(
                idSelector: (employee) => employee.id,
                labelBoxWidth: labelBoxWidth,
                selectedValue: selectedPIC.displayName,
                label: '담당자',
                textBoxWidth: textBoxWidth,
                list: employees,
                titleSelector: (employee) => employee.displayName,
                subtitleSelector: (employee) => employee.email,
                onTap: () {
                  selectedPICController.setSelectedPIC(selectedDropdownData.selectedId);
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
                onTap: () {
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
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText:
                      memberFromInput.id == 0 ? '' : memberFromInput.gender,
                  label: '성별'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: memberFromInput.phoneNumber,
                  label: '전화번호'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: memberFromInput.birthDay,
                  label: '생년월일'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: age == 0 ? '' : age.toString(),
                  label: '나이'),
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
                '운동전 검사',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  _onHeightChanged(v);
                },
                label: '신장',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'cm',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  _onWeightChanged(v);
                },
                label: '체중',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kg',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: (bMI == null || bMI == 0) ? '' : bMI.toString(),
                label: 'BMI\nkg/m²',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '골근격량',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kg',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '체지방량',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kg',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '체지방률',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: '%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  bpm = double.parse(v);
                },
                label: '안정시\n심박수',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'bpm',
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
                '운동부하 검사',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '0 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '1 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '2 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '3 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '4 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '5 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '6 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '7 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {},
                label: '8 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
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
                '운동반응 검사',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  _onBpmMaxChanged(v);
                },
                label: '최고\n심박수',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'bpm',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  _onBpm1mChanged(v);
                },
                label: '1분후\n심박수',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'bpm',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  _onBpm2mChanged(v);
                },
                label: '2분후\n심박수',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'bpm',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  _onBpm3mChanged(v);
                },
                label: '3분후\n심박수',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'bpm',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              SizedBox(
                width: labelBoxWidth + textBoxWidth + 10 + widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: hrr1! <= 0 ? '' : hrr1.toString(),
                label: 'HRR1',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: hrr2! <= 0 ? '' : hrr2.toString(),
                label: 'HRR2',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: hrr3! <= 0 ? '' : hrr3.toString(),
                label: 'HRR3',
              )
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
                '최대심박수 추정식',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id == 0 ? '' : karMax.toString(),
                label: '카르보넨\n최대',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id == 0 ? '' :kar90.toString(),
                label: '카르보넨\90%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id == 0 ? '' :tanMax.toString(),
                label: '다나카\n최대',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id == 0 ? '' :tan90.toString(),
                label: '다나카\90%',
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
                '최대산소 섭취량',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  String formattedTime = secondsToMinutes(v);
                  double calculatedValue = calculateVo2Max(memberFromInput.gender, v);
                  setState(() {
                    Vo2Max = calculatedValue;
                    exhaustionSeconds = int.parse(v);
                    exhaustionTime = formattedTime;
                  });
                },
                label: '탈진시간',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: '초',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: exhaustionTime,
                label: '탈진시간\n분 환산',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id == 0 ? '' : Vo2Max.toString(),
                label: 'VO₂ max',
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
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                '운동강도 설정',
                style: TextStyle(fontSize: 14),
              ),
              Spacer(),
              IntensitySettingInputWidget(
                onChanged: (v) {
                  setState(() {
                    selectedValue = v;
                    if(v == 'Karvonen') {
                      intensityMax = karMax;
                    } else if(v == 'Tanaka') {
                      intensityMax = tanMax;
                    } else {
                      intensityMax = bpmMax as double;
                    }
                    intensityController.setSelectedIntensityValue(intensityMax, bpm);
                  });
                },
                selectedValue: selectedValue,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id ==0 ? '': intensityState.intensityState.percent40.toString(),
                label: '40%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id ==0 ? '': intensityState.intensityState.percent50.toString(),
                label: '50%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id ==0 ? '': intensityState.intensityState.percent60.toString(),
                label: '60%',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id ==0 ? '': intensityState.intensityState.percent70.toString(),
                label: '70%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id ==0 ? '': intensityState.intensityState.percent80.toString(),
                label: '80%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id ==0 ? '': intensityState.intensityState.percent90.toString(),
                label: '90%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: memberFromInput.id ==0 ? '': intensityState.intensityState.percent100.toString(),
                label: '100%',
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 100,
                child: _AddMeasurementButton(
                  onPressed: () {
                    intensityController.setSelectedIntensityValue(100, 20);
                    print(intensityState.intensityState.percent40);
                  },
                  // member: member,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//----------------------------------------------------------------------------
class _AddMeasurementButton extends ConsumerWidget {
  final VoidCallback onPressed;

  // final Member member;

  const _AddMeasurementButton({
    required this.onPressed,
    // required this.member,
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
        onPressed: () {
          onPressed();
        },
        // isValidated
        //     ? () {
        //
        //         // memberInputController.addMember(member, membersController);
        //         onPressed();
        //       }
        //     : () {
        //         CustomMessageScreen.showMessage(
        //             context, '필수값 확인', Colors.amber, Icons.info_outline);
        //       },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          padding: EdgeInsets.zero,
        ),
        child: const Text('등록'),
      ),
    );
  }
}

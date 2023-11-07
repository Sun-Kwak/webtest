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
import 'package:web_test2/common/component/input_widget/custom_number_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_seachable_dropdown_input_widget.dart';
import 'package:web_test2/common/component/input_widget/custom_text_input_widget.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/appointment_provider.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/measurement_input_controller.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/measurement_input_state.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/intensity_setting.dart';
import 'package:web_test2/screen/measurement/utils/time_utils.dart';
import 'package:web_test2/screen/measurement/utils/vo2_max_utils.dart';
import 'package:web_test2/screen/member/controller/member_input_controller.dart';


class MeasurementInputForm extends ConsumerStatefulWidget {
  final Measurement measurement;
  final VoidCallback onSavePressed;
  final VoidCallback onRefreshPressed;
  const MeasurementInputForm({
    required this.onSavePressed,
    required this.onRefreshPressed,
    required this.measurement,
    super.key,
  });

  @override
  ConsumerState<MeasurementInputForm> createState() =>
      MeasurementInputFormState();
}

class MeasurementInputFormState extends ConsumerState<MeasurementInputForm> {
  late Measurement updatingMeasurement;
  TextEditingController nameController = TextEditingController();
  DateTime today = DateTime.now();
  DateTime? selectedDate;
  String formattedDate ="${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
  String? searchSelectedValue;
  // String? selectedMember;
  String? selectedValue = 'Karvonen';
  double userHeight = 0;
  double userWeight = 0;
  double? bMI;
  String exhaustionTime = '';
  int? exhaustionSeconds = 0;
  int? bpmMax = 0;
  int? bpm1m = 0;
  int? bpm2m = 0;
  int? bpm3m = 0;
  int? hrr1 = 0;
  int? hrr2 = 0;
  int? hrr3 = 0;
  double? Vo2Max = 0;



  @override
  void initState() {

    super.initState();
    updatingMeasurement = widget.measurement;
  }


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

      setState(() {
        selectedDate = pickedDate;
        formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
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
  void resetFields() {
    final selectedPICController = ref.watch(selectedPICIdProvider.notifier);
    final String signedInUser = ref.watch(signedInUserProvider).value!.id;

    selectedPICController.setSelectedPIC(signedInUser);
    final selectedMemberIdController =
    ref.watch(selectedMemberIdProvider.notifier);
    selectedMemberIdController.setSelectedRow(0);
    selectedDate = null;
  }

  void _showConfirmationDialog(BuildContext context) {
    final measurementController = ref.watch(measurementProvider.notifier);
    final measurementState = ref.watch(measurementProvider);
    final selectedMeasurementController = ref.watch(selectedMeasurementProvider.notifier);
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final intensitySelectionController = ref.watch(intensitySelectionProvider.notifier);
    final selectedMember = ref.watch(selectedMemberProvider);
    final measurementCalculateController = ref.watch(measurementCalculatedStateProvider.notifier);

    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(

          title: const Icon(
            Icons.info_outline,
            color: Colors.amber,
            size: 50,
          ),
          content: const Text(
            '저장! 보고서로 이동 하시겠습니까?',
            style: TextStyle(color: PRIMARY_COLOR),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '취소',
                style: TextStyle(color: CUSTOM_RED),
              ),
              onPressed: () {
                intensitySelectionController.setSelectedIntensityValue(0, 0);
                selectedMeasurementController.removeState();
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(color: PRIMARY_COLOR),
              ),
              onPressed: () {
                widget.onSavePressed();
                measurementController.getMeasurements();
                selectedMeasurementController.getLatestMeasurement(selectedMember.id,measurementState);
                measurementCalculateController.selectedMeasurement(measurement: updatingMeasurement, member: selectedMember);
                // selectedRow.setSelectedRow(0);
                // memberRepository.disableMember(member, controller);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final measurementInputController = ref.read(measurementInputProvider.notifier);


    final employees = ref.watch(employeeProvider);
    final members = ref.watch(membersProvider);
    final selectedPIC = ref.watch(selectedPICProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    final selectedMemberIdController =
        ref.watch(selectedMemberIdProvider.notifier);
    final selectedPICController = ref.watch(selectedPICIdProvider.notifier);
    final selectedDropdownData = ref.watch(selectedDropdownIDProvider);
    final intensityController = ref.watch(intensitySelectionProvider.notifier);
    final intensityState = ref.watch(intensitySelectionProvider);
    final measurementState = ref.watch(measurementProvider);
    final measurementCalculated = ref.watch(measurementCalculatedStateProvider).measurementCalculatedState;

    DateTime today = DateTime.now();
    DateTime birthDate = selectedMember.id != 0
        ? DateFormat('yyyy-MM-dd').parse(selectedMember.birthDay)
        : DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    double karMax = (220 - age) as double;
    double kar90 = double.parse((karMax * 0.9).toStringAsFixed(2));
    double tanMax = 208 - (0.7 * age);
    double tan90 = double.parse((tanMax * 0.9).toStringAsFixed(2));
    int bpm = 0;
    double intensityMax = 0;
    ref.listen<MeasurementInputState>(
      measurementInputProvider,
          (previous, current) {
        if (current.status.isSubmissionInProgress) {
          LoadingSheet.show(context);
        } else if (current.status.isSubmissionFailure) {
          CustomMessageScreen.showMessage(context, '${current.errorMessage}',
              Colors.red, Icons.dangerous_outlined);
          // ErrorDialog.show(context, '${current.errorMessage}');
        } else if (current.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
          _showConfirmationDialog(context);
          // CustomMessageScreen.showMessage(
          //     context, '저장', Colors.white, Icons.check);
        }
      },
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final double widgetGap = screenWidth >= 650 ? 20 : 8;
    const double textBoxWidth = 170;
    const double labelBoxWidth = 50;
    final selectedMeasurementController = ref.watch(selectedMeasurementProvider.notifier);
    final measurementCalculatedController = ref.watch(measurementCalculatedStateProvider.notifier);

    Member member = Member.empty();
    Measurement measurement = Measurement.empty();
    MeasurementCalculatedState measurementCalculatedState = MeasurementCalculatedState.empty();



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
                // print(exhaustionSeconds);
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
              // CustomTextOutputWidget(
              //     labelBoxWidth: labelBoxWidth,
              //     textBoxWidth: textBoxWidth,
              //     outputText: '', label: '측정날짜'),
              // SizedBox(
              //   width: widgetGap,
              // ),
              _NameField(
                controller: nameController,
                list: members,
                selectedValue: selectedMember.displayName,
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                idSelector: (member) => member.id,
                titleSelector: (member) => member.displayName,
                subtitleSelector: (member) => member.phoneNumber,
                onTap: () {
                  selectedMemberIdController
                      .setSelectedRow(selectedDropdownData.selectedId);
                  member = ref.watch(selectedMemberProvider);
                  selectedMeasurementController.getLatestMeasurement(selectedDropdownData.selectedId,measurementState);
                  measurement = ref.watch(selectedMeasurementProvider);
                  measurementCalculatedController.selectedMeasurement(measurement: measurement, member: member);
                  measurementCalculatedState = ref.watch(measurementCalculatedStateProvider).measurementCalculatedState;
                  intensityController.setSelectedIntensityValue(
                      measurementCalculatedState.karMax, bpm);
                  // measurementCalculatedStateController.selectedMeasurement(measurement: updatingMeasurement, member: selectedMember);
                  setState(() {
                    selectedValue = 'Karvonen';
                  });
                  measurementInputController.onNameChange(selectedDropdownData.selectedTitle);
                },
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
                  selectedPICController
                      .setSelectedPIC(selectedDropdownData.selectedId);
                },
                color: CUSTOM_BLUE.withOpacity(0.1),
                errorText: null,
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
                      selectedMember.id == 0 ? '' : selectedMember.gender,
                  label: '성별'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: selectedMember.phoneNumber,
                  label: '전화번호'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: selectedMember.birthDay,
                  label: '생년월일'),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                  labelBoxWidth: labelBoxWidth,
                  textBoxWidth: textBoxWidth,
                  outputText: age.toString(),
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
                isDouble: true,
                onChanged: (v) {
                  _onHeightChanged(v);
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                      userHeight: double.parse(v)
                    );
                  });
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
                isDouble: true,
                onChanged: (v) {
                  _onWeightChanged(v);
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        userWeight: double.parse(v)
                    );
                  });
                  print(updatingMeasurement.userHeight);
                  print(updatingMeasurement.userWeight);
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
                isDouble: true,
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        smm: double.parse(v)
                    );
                  });
                },
                label: '골근격량',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kg',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                isDouble: true,
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        bfm: double.parse(v)
                    );
                  });
                },
                label: '체지방량',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kg',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                isDouble: true,
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        bfp: double.parse(v)
                    );
                  });
                },
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
                  bpm = int.parse(v);
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        bpm: int.parse(v)
                    );
                  });
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
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage0: int.parse(v)
                    );
                  });
                },
                label: '0 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage1: int.parse(v)
                    );
                  });
                },
                label: '1 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage2: int.parse(v)
                    );
                  });
                },
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
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage3: int.parse(v)
                    );
                  });
                },
                label: '3 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage4: int.parse(v)
                    );
                  });
                },
                label: '4 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage5: int.parse(v)
                    );
                  });
                },
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
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage6: int.parse(v)
                    );
                  });
                },
                label: '6 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage7: int.parse(v)
                    );
                  });
                },
                label: '7 Stage',
                textBoxWidth: textBoxWidth,
                labelBoxWidth: labelBoxWidth,
                hintText: 'kpd',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomNumberInputWidget(
                onChanged: (v) {
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        stage8: int.parse(v)
                    );
                  });
                },
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
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        bpmMax: int.parse(v)
                    );
                  });
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
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        bpm1m: int.parse(v)
                    );
                  });
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
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        bpm2m: int.parse(v)
                    );
                  });
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
                  setState(() {
                    updatingMeasurement = updatingMeasurement.copyWith(
                        bpm3m: int.parse(v)
                    );
                  });
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
                outputText: selectedMember.id == 0 ? '' : karMax.toString(),
                label: '카르보넨\n최대',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: selectedMember.id == 0 ? '' : kar90.toString(),
                label: '카르보넨\90%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: selectedMember.id == 0 ? '' : tanMax.toString(),
                label: '다나카\n최대',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: selectedMember.id == 0 ? '' : tan90.toString(),
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
                  double calculatedValue =
                      calculateVo2Max(selectedMember.gender, v);
                  setState(() {
                    Vo2Max = calculatedValue;
                    exhaustionSeconds = int.parse(v);
                    exhaustionTime = formattedTime;
                    updatingMeasurement = updatingMeasurement.copyWith(
                        exhaustionSeconds: int.parse(v)
                    );
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
                outputText: selectedMember.id == 0 ? '' : Vo2Max.toString(),
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
                    if (v == 'Karvonen') {
                      intensityMax = karMax;
                    } else if (v == 'Tanaka') {
                      intensityMax = tanMax;
                    } else {
                      intensityMax = bpmMax as double;
                    }
                    intensityController.setSelectedIntensityValue(
                        intensityMax, bpm);
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
                outputText: selectedMember.id == 0
                    ? ''
                    : intensityState.intensityState.percent40.toString(),
                label: '40%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: selectedMember.id == 0
                    ? ''
                    : intensityState.intensityState.percent50.toString(),
                label: '50%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: selectedMember.id == 0
                    ? ''
                    : intensityState.intensityState.percent60.toString(),
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
                outputText: selectedMember.id == 0
                    ? ''
                    : intensityState.intensityState.percent70.toString(),
                label: '70%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: selectedMember.id == 0
                    ? ''
                    : intensityState.intensityState.percent80.toString(),
                label: '80%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: selectedMember.id == 0
                    ? ''
                    : intensityState.intensityState.percent90.toString(),
                label: '90%',
              ),
              SizedBox(
                width: widgetGap,
              ),
              CustomTextOutputWidget(
                labelBoxWidth: labelBoxWidth,
                textBoxWidth: textBoxWidth,
                outputText: selectedMember.id == 0
                    ? ''
                    : intensityState.intensityState.percent100.toString(),
                label: '100%',
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 100,
                child: _AddMeasurementButton(
                  onPressed: (){
                    // print(exhaustionSeconds);
                    // resetFields();
                    // widget.onSavePressed();
                  },
                  measurement: updatingMeasurement,
                  memberId: selectedMember.id,
                  PICId: selectedPIC.id,
                  date: formattedDate,
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
  final Measurement measurement;
  final int memberId;
  final String PICId;
  final String date;


  const _AddMeasurementButton({
    required this.onPressed,
    required this.date,
    required this.measurement,
    required this.memberId,
    required this.PICId,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final measurementInputState = ref.watch(measurementInputProvider);
    final bool isValidated = measurementInputState.status.isValidated;
    final measurementInputController = ref.read(measurementInputProvider.notifier);


    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: isValidated
            ? () {

          measurementInputController.addMeasurement(measurement, memberId, PICId,date);

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

class _NameField<T, U> extends ConsumerWidget {
  // final FocusNode nameFieldFocusNode;
  // final FocusNode onFieldSubmitted;
  final double labelBoxWidth;
  final double textBoxWidth;
  final TextEditingController controller;
  final GestureTapCallback onTap;
  final String selectedValue;
  final U Function(T) idSelector;
  final String Function(T) titleSelector;
  final String Function(T) subtitleSelector;
  final List<T> list;

  const _NameField({
    required this.list,
    required this.idSelector,
    required this.titleSelector,
    required this.subtitleSelector,
    required this.selectedValue,
    required this.onTap,
    required this.labelBoxWidth,
    required this.textBoxWidth,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurementInputState = ref.watch(measurementInputProvider);
    final showError = measurementInputState.name.invalid;
    // final measurementInputController =
    //     ref.read(measurementInputProvider.notifier);

    return CustomSearchDropdownWidget(
      showId: true,
      labelBoxWidth: labelBoxWidth,
      selectedValue: selectedValue,
      idSelector: idSelector,
      label: '회원',
      textBoxWidth: textBoxWidth,
      list: list,
      titleSelector: titleSelector,
      subtitleSelector: subtitleSelector,
      onTap: () {
        // (name) => measurementInputController.onNameChange(name);
        onTap();
      },
      color: CUSTOM_BLUE.withOpacity(0.1),
      errorText: showError
          ? Name.showNameErrorMessage(measurementInputState.name.error)
          : null,
      // exclusiveId: 0,
    );
  }
}



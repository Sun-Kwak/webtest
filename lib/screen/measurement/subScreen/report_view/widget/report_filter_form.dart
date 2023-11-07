import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/animated_Object.dart';
import 'package:web_test2/common/component/input_widget/custom_seachable_dropdown_input_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/appointment_provider.dart';

import '../../measurement&appointment_view/widget/intensity_setting.dart';

class ReportFilterForm extends ConsumerStatefulWidget {
  const ReportFilterForm({super.key});

  @override
  ConsumerState<ReportFilterForm> createState() => _ReportFilterFormState();
}

class _ReportFilterFormState extends ConsumerState<ReportFilterForm> {
  String? selectedValue = 'Karvonen';
  double intensityMax = 0;
  @override
  Widget build(BuildContext context) {
    final intensityController = ref.watch(intensitySelectionProvider.notifier);
    final measurementState = ref.watch(measurementProvider);
    final filteredMeasurement = ref.watch(filteredMeasurementProvider);
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final selectedDropdownData = ref.watch(selectedDropdownIDProvider);
    final selectedMemberState = ref.watch(selectedMemberProvider);
    final selectedMemberIDController = ref.watch(selectedMemberIdProvider.notifier);
    final members = ref.watch(membersProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    final selectedMeasurementController = ref.watch(selectedMeasurementProvider.notifier);
    final measurementCalculatedController = ref.watch(measurementCalculatedStateProvider.notifier);
    final measurementCalculatedState = ref.watch(measurementCalculatedStateProvider);
    DateTime today = DateTime.now();
    DateTime birthDate = selectedMemberState.id != 0
        ? DateFormat('yyyy-MM-dd').parse(selectedMemberState.birthDay)
        : DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    int bpmMax = selectedMeasurementState.bpmMax ?? 0;
    int bpm = selectedMeasurementState.bpm ?? 0;
    double karMax = (220 - age) as double;
    double tanMax = 208 - (0.7 * age);
    // String? zone5 = '${intensityMax * 0.9}-$intensityMax';
    Member member = Member.empty();
    Measurement measurement = Measurement.empty();
    // int bpm = 0;


    // final selectedMeasurementId = ref.watch(selectedMeasurementIdProvider);

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        width: 350,
        height: 800,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedObject(
                    onTap: (){

                    },
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  // Text(selectedMeasurementState.docId)
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
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
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  CustomSearchDropdownWidget(
                    idSelector: (member) => member.id,
                    labelBoxWidth: 50,
                    selectedValue: selectedMember.displayName,
                    label: '회원선택',
                    textBoxWidth: 200,
                    list: members,
                    titleSelector: (member) => member.displayName,
                    subtitleSelector: (member) => member.phoneNumber,
                    onTap: () {
                      selectedMemberIDController.setSelectedRow(selectedDropdownData.selectedId);
                      member = ref.watch(selectedMemberProvider);
                      selectedMeasurementController.getLatestMeasurement(member.id, measurementState);
                      measurement = ref.watch(selectedMeasurementProvider);
                      measurementCalculatedController.selectedMeasurement(measurement: measurement, member: member);
                      intensityController.setSelectedIntensityValue(
                          measurementCalculatedState.measurementCalculatedState.karMax, bpm);

                    },
                    color: CUSTOM_BLUE.withOpacity(0.1),
                    errorText: null,
                    // exclusiveId: 0,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: CUSTOM_BLACK.withOpacity(0.3)),
                        ),
                        child: Center(child: Text('기준측정')),

                      ),
                      MeasurementBaselineCard(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 5),
                    child: Container(
                      width: 0.5,
                      height: 620,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: CUSTOM_BLACK.withOpacity(0.3)),
                        ),
                        child: Center(child: Text('비교측정')),
                      ),
                      MeasurementReferenceCard(),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}


class MeasurementBaselineCard extends ConsumerStatefulWidget {
  const MeasurementBaselineCard({super.key, });

  @override
  ConsumerState<MeasurementBaselineCard> createState() => _MeasurementBaselineCardState();
}

class _MeasurementBaselineCardState extends ConsumerState<MeasurementBaselineCard> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    final filteredMeasurements = ref.watch(filteredMeasurementProvider);
    final selectedMeasurementController = ref.watch(selectedMeasurementProvider.notifier);
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final measurementCalculatedStateController = ref.watch(measurementCalculatedStateProvider.notifier);
    final selectedMemberState = ref.watch(selectedMemberProvider);
    return Container(
      height: 630,
      width: 150,
      child: ListView.separated(
        padding: EdgeInsets.all(1),
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: const Divider(),
          );
        },
        itemCount: filteredMeasurements.length,
        itemBuilder: (BuildContext context, int index) {
          Measurement filteredMeasurement = filteredMeasurements[index];
          return Material(
            child: ListTile(
              tileColor: filteredMeasurements.indexOf(filteredMeasurement) == selectedIndex ? TABLE_SELECTION_COLOR : null,
              title: Text('${filteredMeasurement.docId}', style: TextStyle(fontSize: 12),),
              subtitle: Container(color: CUSTOM_GREEN.withOpacity(0.3), child: Text('Optimal Health', style: const TextStyle(fontSize: 9),)),
              onTap: () {
                measurementCalculatedStateController.selectedMeasurement(measurement: filteredMeasurement, member: selectedMemberState);
                setState(() {
                  selectedIndex = filteredMeasurements.indexOf(filteredMeasurement);
                  selectedMeasurementController.onSelectionChanged(filteredMeasurement);
                  print(filteredMeasurement.docId);
                  print(filteredMeasurement.bpmMax);
                  print(filteredMeasurement.bpm3m);
                  print(filteredMeasurement.stage0);

                });
                // Do something when ListTile is tapped
              },
            ),
          );
        },
      ),
    );
  }
}

class MeasurementReferenceCard extends ConsumerStatefulWidget {
  const MeasurementReferenceCard({super.key,});

  @override
  ConsumerState<MeasurementReferenceCard> createState() => _MeasurementReferenceCardState();
}

class _MeasurementReferenceCardState extends ConsumerState<MeasurementReferenceCard> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    final referenceMeasurementState = ref.watch(baselineFilteredMeasurementProvider);
    final selectedReferenceMeasurementController = ref.watch(selectedReferenceMeasurementProvider.notifier);
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    return Container(
      height: 630,
      width: 150,
      child: ListView.separated(
        padding: EdgeInsets.all(1),
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: const Divider(),
          );
        },
        itemCount: referenceMeasurementState.length,
        itemBuilder: (BuildContext context, int index) {
          Measurement filteredMeasurement = referenceMeasurementState[index];
          return Material(
            child: ListTile(
              tileColor: referenceMeasurementState.indexOf(filteredMeasurement) == selectedIndex ? TABLE_SELECTION_COLOR : null,
              title: Text('${filteredMeasurement.testDate}', style: TextStyle(fontSize: 12),),
              subtitle: Container(color: CUSTOM_GREEN.withOpacity(0.3), child: Text('Optimal Health', style: const TextStyle(fontSize: 9),)),
              onTap: () {
                setState(() {
                  selectedIndex = referenceMeasurementState.indexOf(filteredMeasurement);
                  selectedReferenceMeasurementController.onSelectionChanged(filteredMeasurement);

                });
                // Do something when ListTile is tapped
              },
            ),
          );
        },
      ),
    );
  }
}

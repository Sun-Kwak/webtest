

import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/animated_Object.dart';
import 'package:web_test2/common/component/input_widget/custom_seachable_dropdown_input_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/appointment_provider.dart';
import 'package:web_test2/screen/measurement/subScreen/report_view/widget/report_form.dart';

import '../../measurement&appointment_view/widget/intensity_setting.dart';

class ReportFilterForm extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  const ReportFilterForm({
    required this.onTap,
    super.key});

  @override
  ConsumerState<ReportFilterForm> createState() => _ReportFilterFormState();
}

class _ReportFilterFormState extends ConsumerState<ReportFilterForm> {
  // final GlobalKey _key = GlobalKey();

  String? selectedValue = 'Karvonen';
  double intensityMax = 0;
  int selectedIndex = -1;
  UniqueKey key = UniqueKey();

  // Future<void> handlePrint() async {
  //   // ReportForm 캡처
  //   Uint8List imageBytes = await captureWidget(ReportForm());
  //
  //   // 이미지를 웹 페이지에 추가
  //   displayImage(imageBytes!);
  //
  //   // 웹 브라우저 인쇄 기능 사용
  //   html.window.print();
  // }
  //
  // Future<Uint8List> captureWidget(ReportForm reportForm) async {
  //
  //   final RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
  //
  //   final ui.Image image = await boundary.toImage();
  //
  //   final ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //
  //   final Uint8List pngBytes = byteData.buffer.asUint8List();
  //
  //   return pngBytes;
  // }
  //
  // void displayImage(Uint8List imageBytes) {
  //   // 이미지를 웹 페이지에 추가
  //   html.ImageElement imageElement = html.ImageElement(src: 'data:image/png;base64,${base64.encode(imageBytes)}');
  //   html.document.body?.children.add(imageElement);
  // }


  @override
  Widget build(BuildContext context) {
    final intensityController = ref.watch(intensitySelectionProvider.notifier);
    final measurementState = ref.watch(measurementProvider);
    final filteredMeasurement = ref.watch(filteredMeasurementProvider);
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final selectedDropdownData = ref.watch(selectedDropdownIDProvider);
    final selectedMemberState = ref.watch(selectedMemberProvider);
    final selectedMemberIDController =
        ref.watch(selectedMemberIdProvider.notifier);
    final members = ref.watch(membersProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    final selectedMeasurementController =
        ref.watch(selectedMeasurementProvider.notifier);
    final measurementCalculatedController =
        ref.watch(measurementCalculatedStateProvider.notifier);
    final measurementCalculatedState =
        ref.watch(measurementCalculatedStateProvider);
    final selectedReferenceMeasurementController =
    ref.watch(selectedReferenceMeasurementProvider.notifier);
    final selectedReferenceMeasurementState =
    ref.watch(selectedReferenceMeasurementProvider);
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

    UniqueKey _key = UniqueKey();
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
                    onTap: () {
                      widget.onTap();
                      // handlePrint();
                    },
                    child: Icon(
                      Icons.print_outlined,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  Spacer(),

                  // Text(selectedMeasurementState.docId)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              Row(
                children: [

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
                  AnimatedObject(
                    onTap: () {},
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  CustomSearchDropdownWidget(
                    idSelector: (member) => member.id,
                    labelBoxWidth: 50,
                    selectedValue: selectedMember.displayName,
                    label: '회원선택',
                    textBoxWidth: 150,
                    list: members,
                    titleSelector: (member) => member.displayName,
                    subtitleSelector: (member) => member.phoneNumber,
                    onTap: () {
                      selectedMemberIDController
                          .setSelectedRow(selectedDropdownData.selectedId);
                      member = ref.watch(selectedMemberProvider);
                      selectedMeasurementController.getLatestMeasurement(
                          member.id, measurementState);
                      measurement = ref.watch(selectedMeasurementProvider);
                      measurementCalculatedController.selectedMeasurement(
                          measurement: measurement, member: member);
                      intensityController.setSelectedIntensityValue(
                          measurementCalculatedState
                              .measurementCalculatedState.karMax,
                          bpm);
                      selectedReferenceMeasurementController.onSelectionChanged(Measurement.empty());
                    },
                    color: CUSTOM_BLUE.withOpacity(0.1),
                    errorText: null,
                    // exclusiveId: 0,
                  ),
                  SizedBox(
                    width: 10,
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
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 155,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: CUSTOM_BLACK.withOpacity(0.3)),
                        ),
                        child: Center(child: Text('기준측정')),
                      ),
                      MeasurementBaselineCard(
                        onTap: () {
                          measurement = ref.watch(selectedMeasurementProvider);
                          if (measurement ==
                              selectedReferenceMeasurementState) {
                            selectedReferenceMeasurementController
                                .onSelectionChanged(Measurement.empty());

                            setState(() {
                              selectedIndex = -1;
                              key = UniqueKey();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 5),
                    child: Container(
                      width: 0.5,
                      height: 600,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 155,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: CUSTOM_BLACK.withOpacity(0.3)),
                        ),
                        child: Center(child: Text('비교측정')),
                      ),
                      MeasurementReferenceCard(
                      key: key,
                      ),
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
  final VoidCallback onTap;

  const MeasurementBaselineCard({
    super.key,
    required this.onTap,
  });

  @override
  ConsumerState<MeasurementBaselineCard> createState() =>
      _MeasurementBaselineCardState();
}

class _MeasurementBaselineCardState
    extends ConsumerState<MeasurementBaselineCard> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final filteredMeasurements = ref.watch(filteredMeasurementProvider);
    final selectedMeasurementController =
        ref.watch(selectedMeasurementProvider.notifier);

    final measurementCalculatedStateController =
        ref.watch(measurementCalculatedStateProvider.notifier);

    final referenceMeasurementState =
    ref.watch(selectedReferenceMeasurementProvider);

    final selectedReferenceMeasurementController =
    ref.watch(selectedReferenceMeasurementProvider.notifier);

    final selectedMemberState = ref.watch(selectedMemberProvider);
    return Container(
      height: 600,
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
              tileColor: filteredMeasurements.indexOf(filteredMeasurement) ==
                      selectedIndex
                  ? TABLE_SELECTION_COLOR
                  : null,
              title: Text(
                '${filteredMeasurement.startDate!.year}-${filteredMeasurement.startDate!.month.toString().padLeft(2,'0')}-${filteredMeasurement.startDate!.day.toString().padLeft(2,'0')}',
                style: TextStyle(fontSize: 12),
              ),
              subtitle: Row(
                children: [
                  Text('시작:'),
                  Text(
                    '${filteredMeasurement.startDate!.hour.toString().padLeft(2,'0')}:${filteredMeasurement.startDate!.minute.toString().padLeft(2,'0')}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text('/'),
                  Text('종료:'),
                  Text(
                    '${filteredMeasurement.endDate!.hour.toString().padLeft(2,'0')}:${filteredMeasurement.endDate!.minute.toString().padLeft(2,'0')}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
              onTap: () {
                measurementCalculatedStateController.selectedMeasurement(
                    measurement: filteredMeasurement,
                    member: selectedMemberState);
                setState(() {
                  selectedIndex =
                      filteredMeasurements.indexOf(filteredMeasurement);
                });
                selectedMeasurementController
                    .onSelectionChanged(filteredMeasurement);
                // if(filteredMeasurement.docId == referenceMeasurementState.docId){
                //   selectedReferenceMeasurementController.onSelectionChanged(Measurement.empty());
                // }
                widget.onTap();

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

  const MeasurementReferenceCard({

    super.key,
  });

  @override
  ConsumerState<MeasurementReferenceCard> createState() =>
      _MeasurementReferenceCardState();
}

class _MeasurementReferenceCardState
    extends ConsumerState<MeasurementReferenceCard> {
  int _selectedIndex =-1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final referenceMeasurementState =
        ref.watch(baselineFilteredMeasurementProvider);
    final selectedReferenceMeasurementController =
        ref.watch(selectedReferenceMeasurementProvider.notifier);
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    return Container(
      height: 600,
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
              tileColor:
                  referenceMeasurementState.indexOf(filteredMeasurement) ==
                      _selectedIndex
                      ? TABLE_SELECTION_COLOR
                      : null,
              title: Text(
                '${filteredMeasurement.startDate!.year}-${filteredMeasurement.startDate!.month.toString().padLeft(2,'0')}-${filteredMeasurement.startDate!.day.toString().padLeft(2,'0')}',
                style: TextStyle(fontSize: 12),
              ),
              subtitle: Row(
                children: [
                  Text('시작:'),
                  Text(
                    '${filteredMeasurement.startDate!.hour.toString().padLeft(2,'0')}:${filteredMeasurement.startDate!.minute.toString().padLeft(2,'0')}',
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text('/'),
                  Text('종료:'),
                  Text(
                    '${filteredMeasurement.endDate!.hour.toString().padLeft(2,'0')}:${filteredMeasurement.endDate!.minute.toString().padLeft(2,'0')}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex =
                      referenceMeasurementState.indexOf(filteredMeasurement);
                  selectedReferenceMeasurementController
                      .onSelectionChanged(filteredMeasurement);
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


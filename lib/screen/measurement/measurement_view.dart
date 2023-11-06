import 'package:authentication_repository/authentication_repository.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/empty_view.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/conditions_View.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/appointment_provider.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/measurement&appointment_view.dart';
import 'package:web_test2/screen/measurement/subScreen/report_view/report_view.dart';


class MeasurementView extends ConsumerStatefulWidget {

  const MeasurementView({super.key});

  @override
  ConsumerState<MeasurementView> createState() => _MeasurementViewState();
}



class _MeasurementViewState extends ConsumerState<MeasurementView> {
  void _onPressed(){
    setState(() {
      groupValue =1;
    });
  }
  final ScrollController scrollController = ScrollController();
  int groupValue = 0;


  @override
  Widget build(BuildContext context) {
    final measurementController = ref.watch(measurementProvider.notifier);

    final selectedMeasurementController = ref.watch(selectedMeasurementProvider.notifier);
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    final intensitySelectionController = ref.watch(intensitySelectionProvider.notifier);
    final measurementCalculatedStateController = ref.watch(measurementCalculatedStateProvider.notifier);
    final List<Widget> subContents = [
      MeasurementAndAppointmentView(
        onPressed: (){
          _onPressed();
        },
      ),
      const ReportView(),
      const ConditionsView(),
    ];

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          // controller: scrollController,
          // scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 6,),
              Container(
                width: 1750,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    CustomSlidingSegmentedControl<int>(
                      height: 45,
                      children: {
                        0: buildSegment('측정 & 예약', 0),
                        1: buildSegment('보고서', 1),
                        2: buildSegment('측정조건', 2),
                      },
                      onValueChanged: (v) {
                        setState(() {
                          groupValue = v;
                          if(v == 1){
                            // selectedMeasurementController.getLatestMeasurement(selectedMember.id);
                            // print(selectedMeasurementState.userWeight);
                            if(selectedMember.id !=0) {
                              measurementCalculatedStateController
                                  .selectedMeasurement(
                                  measurement: selectedMeasurementState,
                                  member: selectedMember);
                            }
                            print(selectedMeasurementState.createdAt);
                            // selectedMeasurementController.setSelectedRow(lastedSavedMeasurement.docId);
                          }
                          if(v == 0){
                            // intensitySelectionController.setSelectedIntensityValue(0, 0);
                            // selectedMeasurementController.removeState();
                          }

                        });
                      },
                      initialValue: groupValue,
                      decoration: BoxDecoration(
                        // border: Border(bottom: BorderSide(color: Colors.blue)),
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        // border: Border(bottom: BorderSide(color: Colors.white, width: 2.0))
                      ),
                      thumbDecoration: BoxDecoration(
                        // border: Border(bottom: BorderSide(color: Colors.red, width: 10.0)),
                        // color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(6),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(.3),
                        //     blurRadius: 4.0,
                        //     spreadRadius: 1.0,
                        //     offset: Offset(
                        //       0.0,
                        //       2.0,
                        //     ),
                        //   ),
                        // ],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.alarm),
                    SizedBox(width: 10,),
                    Text('다음 예약은 해린님입니다.'),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
              SizedBox(height: 10,),
              subContents[groupValue],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSegment(String text, int index) {
    final TextSpan textSpan = TextSpan(
      text: text,
      style: TextStyle(fontSize: 12,),
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: groupValue == index ? CUSTOM_BLUE : CUSTOM_BLACK,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: groupValue == index ? textPainter.width * 0.9 : 0,
          height: 3,
          curve: Curves.fastOutSlowIn,
          child: Container(
            decoration: BoxDecoration(
              color: CUSTOM_BLUE,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        )
      ],
    );
  }
}

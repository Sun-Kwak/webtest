import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:web_test2/common/component/animated_Icon.dart';
import 'package:web_test2/common/component/animated_Object.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/measurement_input_controller.dart';


class AppointmentInputForm extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  const AppointmentInputForm({
    required this.onPressed,
    super.key});

  @override
  ConsumerState<AppointmentInputForm> createState() => _AppointmentInputFormState();
}

class _AppointmentInputFormState extends ConsumerState<AppointmentInputForm> {
  List<Meeting> data = [];
  DateTime selectedDate = DateTime.now();
  String selectedSchedule ='';
  String formattedDate = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";



  @override
  Widget build(BuildContext context) {

    // final measurementState = ref.watch(measurementProvider);
    // for (var measurementItem in measurementState) {
    //   DateTime startDate = measurementItem.startDate;
    //   DateTime endDate = measurementItem.endDate;
    //   String name = '${measurementItem.memberName}/측정';
    //   String id = measurementItem.docId;
    //   // String displayName = measurementItem.displayName;
    //   Meeting newMeeting = Meeting(name, startDate, endDate, Colors.blue,id); // Colors.blue는 임의로 지정한 배경색
    //   data.add(newMeeting);
    // }
    DateTime now = DateTime.now();
    // // final DateTime today = DateTime.now();
    //   final DateTime startTime =
    //   DateTime(now.year, now.month, now.day, now.hour +1, 15, 20);
    //   final DateTime endTime = startTime.add(const Duration(hours: 2));
    // final DateTime startTime2 =
    // DateTime(now.year, now.month, now.day +1, now.hour +1, 15, 20);
    // final DateTime endTime2 = startTime.add(const Duration(hours: 2));
    // data.add(Meeting(
    //       '해린님/유추', startTime, endTime, CUSTOM_RED,'NA'));
    // data.add(Meeting(
    //       '민지님/PT', startTime2, endTime2, CUSTOM_RED,'NA'));
    // List<Meeting> _getDataSource() {
    //   final List<Meeting> meetings = <Meeting>[];
    //   final DateTime today = DateTime.now();
    //   final DateTime startTime =
    //   DateTime(today.year, today.month, today.day, 9, 15, 20);
    //   final DateTime endTime = startTime.add(const Duration(hours: 2));
    //   meetings.add(Meeting(
    //       '해린님/유추', startTime, endTime, CUSTOM_RED));
    //   meetings.add(Meeting(
    //       '민지님/PT', startTime, endTime, CUSTOM_RED));
    //   return meetings;
    // }
    //

    final measurementScheduleState = ref.watch(measurementScheduleProvider);
    final selectedScheduleMeasurementIdController  = ref.watch(selectedScheduleMeasurementIdProvider.notifier);
    final selectedScheduleMeasurementState  = ref.watch(selectedScheduleMeasurementProvider);
    final measurementInputController = ref.read(measurementInputProvider.notifier);
    final editing = ref.watch(measurementEditingProvider.notifier);
    final selectedMemberIdController = ref.watch(selectedMemberIdProvider.notifier);
    final selectedMeasurementController = ref.watch(selectedMeasurementProvider.notifier);
    final measurementState = ref.watch(measurementProvider);
    data = measurementScheduleState;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      width: 700,
      height: 1350,
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Column(
          children: [
            // const SizedBox(
            //   height: 190,
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: Row(
                children: [
                  CustomTextOutputWidget(
                    border: false,
                    textColor: Colors.white,
                    color: CUSTOM_BLACK,
                    label: '선택날짜',
                    height: 28,
                    textBoxWidth: 130,
                    labelBoxWidth: 50,
                    outputText: formattedDate,
                  ),
                  SizedBox(width: 10,),
                  CustomTextOutputWidget(
                    border: false,
                    textColor: Colors.white,
                    color: CUSTOM_BLACK,
                    label: '선택일정',
                    height: 28,
                    textBoxWidth: 130,
                    labelBoxWidth: 50,
                    outputText: selectedSchedule,
                  ),
                  SizedBox(width: 10,),
                  Tooltip(
                    message: '선택 수정',
                    child: AnimatedObject(
                      onTap: (){
                        if (selectedScheduleMeasurementState.docId != '') {
                          editing.toggleStatus(true);
                          measurementInputController.recall(selectedScheduleMeasurementState.memberName);
                          Measurement measurement = ref.watch(selectedScheduleMeasurementProvider);
                          print(selectedScheduleMeasurementState.PICName);
                          // selectedScheduleMeasurementIdController.setSelectedRow(newValue);
                          selectedMemberIdController.setSelectedRow(measurement.memberId);
                          selectedMeasurementController.getLatestMeasurement(selectedScheduleMeasurementState.memberId,measurementState);

                          widget.onPressed();
                        }

                      },
                        child: Icon(Icons.edit_calendar,color: PRIMARY_COLOR,)),
                  ),
                  SizedBox(width: 10,),
                  Tooltip(
                    message: '예약 추가',
                    child: AnimatedObject(
                        onTap: (){
                        },
                        child: Icon(Icons.add_alarm,color: PRIMARY_COLOR,)),
                  ),
                  Spacer(),
                  CustomRefreshIcon(onPressed: () {
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Divider(),
            ),
            Container(
              height: 1200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: INPUT_BORDER_COLOR,width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCalendar(
                  onTap: (CalendarTapDetails details){
                    setState(() {
                      selectedDate = details.date!;

                      formattedDate = "${details.date!.year}-${details.date!.month.toString().padLeft(2, '0')}-${details.date!.day.toString().padLeft(2, '0')}";
                      if(details.appointments != null && details.appointments!.isNotEmpty){

                      String selectedStartTime =  DateFormat('hh:mm').format(details.appointments![0].from);
                      selectedSchedule = details.appointments![0].eventName + ' ' +selectedStartTime;
                        selectedScheduleMeasurementIdController.setSelectedRow(details.appointments![0].id);
                      // Measurement measurement = ref.watch(selectedScheduleMeasurementProvider);
                      // selectedMemberIdController.setSelectedRow(measurement.memberId);
                      }
                      // selectedScheduleMeasurementIdController.setSelectedRow(details.appointments![0].id);
                    });
                    // final DateTime? date = details.date;
                    // final Appointment? occurrenceAppointment =
                    // MeetingDataSource(data).getOccurrenceAppointment('', date!, '');
                    // print(occurrenceAppointment);
                    // print(details.targetElement.name);
                    // print(MeetingDataSource(data).getOccurrenceAppointment(null, details.date!, ''));
                    // print(details.appointments![0].id);
                  },
                  viewHeaderHeight: 40,
                  viewHeaderStyle: ViewHeaderStyle(
                    backgroundColor: TABLE_HEADER_COLOR
                  ),
                  allowedViews: const <CalendarView>[
                    CalendarView.day,
                    CalendarView.week,
                    CalendarView.workWeek,
                    CalendarView.month,
                    CalendarView.schedule
                  ],
                  // allowViewNavigation: true,
                  headerHeight: 40,
                  appointmentTextStyle: TextStyle(letterSpacing: 2),
                  headerStyle: const CalendarHeaderStyle(
                    textAlign: TextAlign.end,
                    // backgroundColor: CUSTOM_BLACK,
                    textStyle: TextStyle(color: CUSTOM_BLACK),
                  ),
                  showNavigationArrow: true,
                  showCurrentTimeIndicator: true,
                  dataSource: MeetingDataSource(measurementScheduleState),
                  monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment,
                      dayFormat: 'EEE',
                      showAgenda: true,
                      appointmentDisplayCount: 5,
                      monthCellStyle: MonthCellStyle(
                        leadingDatesBackgroundColor: TABLE_COLOR,
                        trailingDatesBackgroundColor: TABLE_COLOR,
                      )),
                  firstDayOfWeek: 1,
                  initialSelectedDate: DateTime.now(),
                  // cellEndPadding: 50,
                  backgroundColor: Colors.white,
                  view: CalendarView.month,
                  showDatePickerButton: true,
                  cellBorderColor: PRIMARY_COLOR,
                  todayHighlightColor: CUSTOM_RED,
                  todayTextStyle: const TextStyle(color: Colors.white),
                  showTodayButton: true,
                  selectionDecoration: BoxDecoration(
                    color: TABLE_SELECTION_COLOR.withOpacity(0.2),
                    // border: Border.all(color: CUSTOM_BLUE,width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    shape: BoxShape.rectangle,
                  ),
                  timeSlotViewSettings: const TimeSlotViewSettings(
                      dateFormat: 'dd',
                      dayFormat: 'EEE',
                      minimumAppointmentDuration: Duration(minutes: 30),
                      startHour: 9,
                      endHour: 18,
                      nonWorkingDays: <int>[
                        DateTime.sunday,
                        DateTime.saturday
                      ]),
                  scheduleViewSettings:  ScheduleViewSettings(
                    hideEmptyScheduleWeek: true,
                    monthHeaderSettings: MonthHeaderSettings(
                      height: 70,
                      textAlign: TextAlign.center,
                      backgroundColor: CUSTOM_BLACK,
                      monthTextStyle: TextStyle(fontSize: 20)
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }
//
//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].from;
//   }
//
//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to;
//   }
//
//   @override
//   String getSubject(int index) {
//     return appointments![index].eventName;
//   }
//
//   @override
//   Color getColor(int index) {
//     return appointments![index].background;
//   }
//
//   @override
//   String getNotes(int index) {
//     return appointments![index].id;
//   }
//
//
//
//   // @override
//   // bool isAllDay(int index) {
//   //   return appointments![index].isAllDay;
//   // }
// }
//
// class Meeting {
//   Meeting(this.eventName, this.from, this.to, this.background, this.id);
//
//   String eventName;
//   DateTime from;
//   DateTime to;
//   Color background;
//   String id;
//   // bool isAllDay;
// }

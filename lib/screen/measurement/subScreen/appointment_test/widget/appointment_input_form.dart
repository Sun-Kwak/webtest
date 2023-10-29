import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:web_test2/common/component/animated_Icon.dart';
import 'package:web_test2/common/component/animated_Object.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';
import 'package:web_test2/common/const/colors.dart';


class AppointmentInputForm extends StatefulWidget {
  const AppointmentInputForm({super.key});

  @override
  State<AppointmentInputForm> createState() => _AppointmentInputFormState();
}

class _AppointmentInputFormState extends State<AppointmentInputForm> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      width: 590,
      height: 800,
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
                  CustomAnimatedIcon(
                    onTap: (){},
                    iconData: AnimatedIcons.add_event,
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
              height: 730,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: INPUT_BORDER_COLOR,width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCalendar(
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
                  appointmentTextStyle: TextStyle(letterSpacing: 10),
                  headerStyle: const CalendarHeaderStyle(
                    textAlign: TextAlign.end,
                    // backgroundColor: CUSTOM_BLACK,
                    textStyle: TextStyle(color: CUSTOM_BLACK),
                  ),
                  showNavigationArrow: true,
                  showCurrentTimeIndicator: true,
                  dataSource: MeetingDataSource(_getDataSource()),
                  monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment,
                      dayFormat: 'EEE',
                      showAgenda: true,
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

List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 15, 20);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting(
      '해린님/유추', startTime, endTime, const Color(0xFFF6A52D), false));
  meetings.add(Meeting(
      '민지님/PT', startTime, endTime, const Color(0xFF8AF1A2), false));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/employees_view.dart';
import 'package:web_test2/screen/empty_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  int groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomSlidingSegmentedControl<int>(

              children: {
                0: buildSegment('기초정보', 0),
                1: buildSegment('회원관련', 1),
                2: buildSegment('직원등록', 2),
                3: buildSegment('강의등록', 3),
              },
              onValueChanged: (v) {
                setState(() {
                  groupValue = v;
                });
              },
              initialValue: groupValue,
              decoration: BoxDecoration(
                // border: Border(bottom: BorderSide(color: Colors.blue)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                // border: Border(bottom: BorderSide(color: Colors.white, width: 2.0))
              ),
              thumbDecoration: BoxDecoration(
                // border: Border(bottom: BorderSide(color: Colors.red, width: 10.0)),
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
         Expanded(child: groupValue == 2 ? EmployeesView() : EmptyView()),
      ],
    );
  }

  Widget buildSegment(String text, int index) => Container(
        padding: EdgeInsets.all(12),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: groupValue == index ? Colors.white : Colors.black,
            // decoration: TextDecoration.underline,
            // decorationColor: Colors.white,
            // decorationStyle: TextDecorationStyle.dotted,
          ),
        ),
      );
}

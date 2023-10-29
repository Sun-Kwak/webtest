import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:web_test2/common/component/animated_Icon.dart';
import 'package:web_test2/common/component/animated_Object.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/measurement/subScreen/appointment_test/widget/appointment_input_form.dart';
import 'package:web_test2/screen/measurement/subScreen/appointment_test/widget/measurement_input_form.dart';


class AppointmentTestForm extends StatefulWidget {
  const AppointmentTestForm({super.key});

  @override
  State<AppointmentTestForm> createState() => _AppointmentTestFormState();
}

class _AppointmentTestFormState extends State<AppointmentTestForm> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MeasurementInputForm(),
        SizedBox(width: 10,),
        AppointmentInputForm(),
      ],
    );
  }
}


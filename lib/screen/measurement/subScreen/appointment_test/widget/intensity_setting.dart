import 'package:flutter/material.dart';
import 'package:web_test2/common/const/colors.dart';


class IntensitySettingInputWidget extends StatefulWidget {

  final String? selectedValue;
  final ValueChanged<String?> onChanged;


  const IntensitySettingInputWidget({
    required this.onChanged,
    this.selectedValue = 'Karvonen',


    super.key,
  });

  @override
  IntensitySettingInputWidgetState createState() => IntensitySettingInputWidgetState();
}

class IntensitySettingInputWidgetState extends State<IntensitySettingInputWidget> {

  @override
  Widget build(BuildContext context) {
    double width = 100;
    return Row(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              child: Row(
                children: [
                  Radio<String>(
                    value: 'Karvonen',
                    groupValue: widget.selectedValue,
                    onChanged: widget.onChanged,
                    activeColor: CUSTOM_BLUE,
                  ),
                  const Text('Karvonen',
                    // style: TextStyle(fontSize: 40 * 0.35),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: width,
              child: Row(
                children: [
                  Radio<String>(
                    value: 'Tanaka',
                    groupValue: widget.selectedValue,
                    onChanged: widget.onChanged,
                    activeColor: CUSTOM_BLUE,
                  ),
                  const Text('Tanaka',
                    // style: TextStyle(fontSize: 40 * 0.35),
                  ),

                ],
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: width,
              child: Row(
                children: [
                  Radio<String>(
                    value: 'Max',
                    groupValue: widget.selectedValue,
                    onChanged: widget.onChanged,
                    activeColor: CUSTOM_BLUE,
                  ),
                  const Text('최고심박수',
                    // style: TextStyle(fontSize: 40 * 0.35),
                  ),
                ],
              ),
            ),
            SizedBox(width: 30,),
            // const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}

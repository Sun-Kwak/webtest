import 'package:flutter/material.dart';
import 'package:web_test2/common/const/colors.dart';


class CustomGenderSelectionInputWidget extends StatefulWidget {
  final double? labelBoxWidth;
  final String? selectedGender;
  final ValueChanged<String?> onChanged;
  final double? textBoxWidth;

   const CustomGenderSelectionInputWidget({
    required this.onChanged,
    this.selectedGender = '여성',
    this.labelBoxWidth = 50,
     this.textBoxWidth = 170,
    super.key,
  });

  @override
  CustomGenderSelectionInputWidgetState createState() => CustomGenderSelectionInputWidgetState();
}

class CustomGenderSelectionInputWidgetState extends State<CustomGenderSelectionInputWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
            width: widget.labelBoxWidth,
            height: 37,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '성별',
                  // style: TextStyle(fontSize: 40 * 0.35),
                ),
              ],
            )),
        const SizedBox(
          width: 10,
          height: 37,
          child: Center(
            child: Text('*',style: TextStyle(color: CUSTOM_RED)),
          ),
        ),
        Container(
          width: widget.textBoxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: '여성',
                    groupValue: widget.selectedGender,
                    onChanged: widget.onChanged,
                    activeColor: CUSTOM_BLUE,
                  ),
                  const Text('여성',
                    // style: TextStyle(fontSize: 40 * 0.35),
                  ),
                ],
              ),
              SizedBox(width: widget.textBoxWidth! * 0.2,),
              Row(
                children: [
                  Radio<String>(
                    value: '남성',
                    groupValue: widget.selectedGender,
                    onChanged: widget.onChanged,
                    activeColor: CUSTOM_BLUE,
                  ),
                  const Text('남성',
                    // style: TextStyle(fontSize: 40 * 0.35),
                  ),
                ],
              )
              // const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomTextOutputWidget extends StatelessWidget {
  final double? height;
  final bool? isRequired;
  final String label;
  final String outputText;
  final double? labelBoxWidth;
  final double? textBoxWidth;

  const CustomTextOutputWidget({
    this.labelBoxWidth = 60,
    this.textBoxWidth = 170,
    required this.outputText,
    required this.label,
    this.isRequired = false,
    this.height = 37,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: labelBoxWidth,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                ),
              ],
            )),
        SizedBox(
          width: 3,
          height: height,
          child: Center(
            child: isRequired == true
                ? const Text('*', style: TextStyle(color: Colors.redAccent))
                : null,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          width:  textBoxWidth,
          height: height,

          decoration: BoxDecoration(
            color: TABLE_COLOR,
            border: Border.all(color: INPUT_BORDER_COLOR),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(outputText),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';

class CustomTextInputWidget extends StatelessWidget {
  final double? height;
  final bool? isRequired;
  final String label;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const CustomTextInputWidget(
      {this.hintText,
        required this.label,
        this.isRequired = false,
        required this.onChanged,
        this.height = 40,
        super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 70,
            height: height,
            child: Center(
                child: Text(
                  label,
                ))),
        SizedBox(
          width: 10,
          height: height,
          child: Center(
            child: isRequired == true
                ? const Text('*', style: TextStyle(color: Colors.redAccent))
                : null,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        CustomInputFormField(
            hintText: hintText,
            width: 170,
            height: height,
            onChanged: onChanged),
      ],
    );
  }
}

class LargeTextInputWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final double? textHeight;
  final bool? isRequired;
  final String label;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const LargeTextInputWidget(
      {this.hintText,
        required this.label,
        this.isRequired = false,
        required this.onChanged,
        this.height = 70,
        this.width = 465,
        this.textHeight = 40,
        super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            height: textHeight,
            child: Center(
              child: Text(
                label,
                // style: TextStyle(fontSize: textHeight! * 0.35),
              ),
            ),
          ),
          SizedBox(
            width: 10,
            height: height,
            child: Center(
              child: isRequired == true
                  ? const Text('\*', style: TextStyle(color: Colors.redAccent))
                  : null,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CustomInputFormField(
              maxLines: 3,
              hintText: hintText,
              width: width,
              height: height,
              onChanged: onChanged),
        ],
      ),
    );
  }
}


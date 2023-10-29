import 'package:flutter/material.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomTextInputWidget extends StatelessWidget {
  final double? height;
  final bool? isRequired;
  final String label;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final double? labelBoxWidth;
  final double? textBoxWidth;
  final TextEditingController? controller;
  final String? errorText;

  const CustomTextInputWidget({
    this.errorText,
    this.controller,
    this.labelBoxWidth = 50,
    this.textBoxWidth = 170,
    this.hintText,
    required this.label,
    this.isRequired = false,
    required this.onChanged,
    this.height = 37,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
              width: 10,
              height: height,
              child: Center(
                child: isRequired == true
                    ? const Text('*', style: TextStyle(color: Colors.redAccent))
                    : null,
              ),
            ),

            CustomInputFormField(
              controller: controller,
              hintText: hintText,
              width: textBoxWidth,
              height: height,
              onChanged: onChanged,
              errorText: errorText,
            ),
          ],
        ),
        SizeFadeSwitcher(
          child: errorText != null
              ? Padding(
            padding: EdgeInsets.fromLTRB(labelBoxWidth! + 15, 3, 0, 0),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          )
              : const SizedBox.shrink(),
        )

      ],
    );
  }
}

class LargeTextInputWidget extends StatelessWidget {
  final double? height;
  final double? textHeight;
  final bool? isRequired;
  final String label;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final double? labelBoxWidth;
  final double? textBoxWidth;
  final TextEditingController? controller;

  const LargeTextInputWidget({
    this.controller,
    this.labelBoxWidth = 50,
    this.textBoxWidth = 440,
    this.hintText,
    required this.label,
    this.isRequired = false,
    required this.onChanged,
    this.height = 75,
    this.textHeight = 40,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelBoxWidth,
          height: textHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,

                // style: TextStyle(fontSize: textHeight! * 0.35),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height,
          width: 10,
          child: Center(
            child: isRequired == true
                ? const Text('*', style: TextStyle(color: CUSTOM_RED))
                : null,
          ),
        ),
        CustomInputFormField(
            controller: controller,
            maxLines: 4,
            hintText: hintText,
            width: textBoxWidth,
            height: height,
            onChanged: onChanged
        ),
      ],
    );
  }
}

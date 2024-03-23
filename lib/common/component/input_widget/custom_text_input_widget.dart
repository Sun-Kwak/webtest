import 'package:flutter/material.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';

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
  final bool? isLarge;

  const CustomTextInputWidget({
    this.isLarge  = false,
    this.errorText,
    this.controller,
    this.labelBoxWidth = 50,
    this.textBoxWidth,
    this.hintText,
    required this.label,
    this.isRequired = false,
    required this.onChanged,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double _height = height ?? (isLarge == true ? 75 : 37);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: labelBoxWidth,
                height: _height,
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
              height: _height,
              child: Center(
                child: isRequired == true
                    ? const Text('*', style: TextStyle(color: Colors.redAccent))
                    : null,
              ),
            ),

            CustomInputFormField(
              // initialValue: initialValue,
              controller: controller,
              hintText: hintText,
              width: textBoxWidth ?? (isLarge == true ? 440 : 170) ,
              height: _height,
              onChanged: onChanged,
              errorText: errorText,
              maxLines: isLarge == true ? 4 : 1,
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


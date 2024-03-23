import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_test2/common/component/custom_text_fromfield.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomPhoneInputWidget extends StatelessWidget {
  final double? height;
  final bool? isRequired;
  final String label;
  final ValueChanged<String>? onChanged;
  final double? labelBoxWidth;
  final double? textBoxWidth;
  final TextEditingController? controller;
  final String? errorText;
  // final String initialValue;

  const CustomPhoneInputWidget({
    // required this.initialValue,
    this.errorText,
    this.controller,
    this.labelBoxWidth = 50,
    this.textBoxWidth = 170,
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
                    ? const Text('*', style: TextStyle(color: CUSTOM_RED))
                    : null,
              ),
            ),

            CustomInputFormField(
              // initialValue: initialValue,
              controller: controller,
              hintText: '숫자만 입력 (010 제외)',
              width: textBoxWidth,
              height: height,
              onChanged: onChanged,
              errorText: errorText,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                PhoneInputFormatter(),
              ],
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
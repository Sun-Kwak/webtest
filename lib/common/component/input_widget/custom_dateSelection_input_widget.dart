import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validators.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';

import '../../../screen/member/controller/member_input_controller.dart';

class CustomDateSelectionInputWidget extends StatelessWidget {
  final double? height;
  final String label;
  final bool? isRequired;
  final double labelBoxWidth;
  final double? textBoxWidth;
  final DateTime? selectedDate;
  final GestureTapCallback onTap;
  final String? errorText;

  const CustomDateSelectionInputWidget({
    required this.errorText,
    required this.onTap,
    required this.selectedDate,
    required this.labelBoxWidth,
    this.textBoxWidth,
    this.isRequired = false,
    required this.label,
    this.height = 37,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: INPUT_BORDER_COLOR,
      width: 1.0,
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            SizedBox(
                width: labelBoxWidth,
                child: Center(
                    child: Text(
                  label,
                  style: const TextStyle(fontSize: 12),
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
            SizedBox(
              width: textBoxWidth,
              height: height,
              child: InkWell(
                onTap: onTap,
                child: InputDecorator(
                  decoration: InputDecoration(
                    suffixIcon: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(Icons.date_range_outlined,color: CONSTRAINT_PRIMARY_COLOR,),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: height! * 0.1, top: height! * 0.1),
                    filled: true,
                    fillColor: INPUT_BG_COLOR,
                    //errorText: errorText,
                    border: baseBorder,
                    enabledBorder: baseBorder,
                    focusedBorder: baseBorder.copyWith(
                      borderSide: const BorderSide(
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                  child: selectedDate != null
                      ? Text(
                          '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
                        )
                      : const Text(
                          '날짜 선택',
                          style: TextStyle(
                            color: CONSTRAINT_PRIMARY_COLOR,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
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
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomTimeSelectionInputWidget extends StatelessWidget {
  final double? height;
  final String label;
  final bool? isRequired;
  final double labelBoxWidth;
  final double? textBoxWidth;
  final TimeOfDay? selectedTime;
  final GestureTapCallback onTap;
  final String? errorText;
  final Color? color;

  const CustomTimeSelectionInputWidget({
    required this.errorText,
    required this.onTap,
    required this.selectedTime,
    required this.labelBoxWidth,
    this.color,
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
                    ? const Text('*', style: TextStyle(color: CUSTOM_RED))
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
                      child: Icon(Icons.access_time,color: CONSTRAINT_PRIMARY_COLOR,),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: height! * 0.1, top: height! * 0.1),
                    filled: true,
                    fillColor: color ?? INPUT_BG_COLOR,
                    //errorText: errorText,
                    border: baseBorder,
                    enabledBorder: baseBorder,
                    focusedBorder: baseBorder.copyWith(
                      borderSide: const BorderSide(
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                  child: selectedTime != null
                      ? Text(
                    '${selectedTime!.hour.toString().padLeft(2,'0')}:${selectedTime!.minute.toString().padLeft(2,'0')}'
                  )
                      : const Text(
                    '시간 선택',
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
            padding: EdgeInsets.fromLTRB(labelBoxWidth + 15, 3, 0, 0),
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

import 'package:flutter/material.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomDateSelectionInputWidget extends StatefulWidget {
final double? height;
final String label;
final bool? isRequired;

  const CustomDateSelectionInputWidget({
    this.isRequired = false,
    required this.label,
    this.height = 40,
    super.key});

  @override
  CustomDateSelectionInputWidgetState createState() => CustomDateSelectionInputWidgetState();
}

class CustomDateSelectionInputWidgetState extends State<CustomDateSelectionInputWidget> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime threeYearsLater = now.add(const Duration(days: 3 * 365)); // 3 years later from now

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: threeYearsLater,

    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
          color: INPUT_BORDER_COLOR,
          width: 1.0,
        ));
    return Row(
      children: <Widget>[
        Container(
            width: 70,
            height: widget.height,
            child: Center(
                child: Text(
                  widget.label,
                  style: const TextStyle(fontSize: 12),
                ))),
        SizedBox(
          width: 10,
          height:widget.height,
          child: Center(
            child: widget.isRequired == true ? const Text('\*',style: TextStyle(color: Colors.redAccent)) : null,
          ),
        ),
        const SizedBox(width: 10,),
        InkWell(
          onTap: () {
            _selectDate(context);
          },
          child: Row(
            children: [
              Container(
                width: 170,
                height: 40,
                child: InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: widget.height! * 0.1, top: widget.height! * 0.1),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _selectedDate != null
                          ? Text(
                        '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                      )
                          : const Text('날짜 선택',style: TextStyle(
                        color: CONSTRAINT_PRIMARY_COLOR,
                        fontSize: 12,
                      ),),

                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              const Icon(Icons.calendar_today,color: PRIMARY_COLOR,),
            ],
          ),
        ),
      ],
    );
  }
}

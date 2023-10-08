import 'package:flutter/material.dart';


enum Gender { male, female }

class CustomGenderSelectionInputWidget extends StatefulWidget {
  const CustomGenderSelectionInputWidget({super.key});

  @override
  CustomGenderSelectionInputWidgetState createState() => CustomGenderSelectionInputWidgetState();
}

class CustomGenderSelectionInputWidgetState extends State<CustomGenderSelectionInputWidget> {
  Gender? _selectedGender = Gender.female;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            width: 70,
            height: 40,
            child: const Center(
                child: Text(
                  '성별',
                  // style: TextStyle(fontSize: 40 * 0.35),
                ))),
        const SizedBox(
          width: 10,
          height: 40,
          child: Center(
            child: Text('\*',style: TextStyle(color: Colors.redAccent)),
          ),
        ),
        const SizedBox(width: 10,),
        Radio<Gender>(
          value: Gender.female,
          groupValue: _selectedGender,
          onChanged: (Gender? value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
        const Text('여자',
          // style: TextStyle(fontSize: 40 * 0.35),
        ),
        const SizedBox(width: 20),
        Radio<Gender>(
          value: Gender.male,
          groupValue: _selectedGender,
          onChanged: (Gender? value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
        const Text('남자',
          // style: TextStyle(fontSize: 40 * 0.35),
        ),
      ],
    );
  }
}

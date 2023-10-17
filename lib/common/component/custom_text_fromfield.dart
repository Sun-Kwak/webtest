import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final IconButton? suffixIcon;
  final FocusNode? focusNode;
  final FocusNode? onFieldSubmitted;



  const CustomTextFormField({
    this.focusNode,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    this.hintText,
    this.errorText,
    super.key});

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
          color: INPUT_BORDER_COLOR,
          width: 1.0,
        ));

    return Column(
      //mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 55,
          child: TextFormField(
            style: TextStyle(
              fontFamily: obscureText == true ?'NotoSans' : 'SebangGothic',
            ),
            focusNode: focusNode,
            onFieldSubmitted: (value) {
              FocusScope.of(context)
                  .requestFocus(onFieldSubmitted);
            },
            cursorColor: PRIMARY_COLOR,
            obscureText: obscureText,
            autofocus: autofocus,
            onChanged: onChanged,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.all(5),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: CONSTRAINT_PRIMARY_COLOR,
                fontFamily: 'SebangGothic',
              ),
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
          ),
        ),
        SizeFadeSwitcher(
          child: errorText != null ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ): const SizedBox.shrink(),
        ) ,
      ],
    );
  }
}

class CustomInputFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final IconButton? suffixIcon;
  final FocusNode? focusNode;
  final FocusNode? onFieldSubmitted;
  final double? height;
  final double? width;
  final int? maxLines;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;


  const CustomInputFormField({
    this.controller,
    this.maxLines = 1,
    this.width =250,
    this.height =60,
    this.focusNode,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    this.hintText,
    this.errorText,
    this.inputFormatters,
    this.keyboardType,
    super.key});

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
          color: INPUT_BORDER_COLOR,
          width: 1.0,
        ));

    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 12,
        ),
        focusNode: focusNode,
        onFieldSubmitted: (value) {
          FocusScope.of(context)
              .requestFocus(onFieldSubmitted);
        },
        cursorColor: PRIMARY_COLOR,
        obscureText: obscureText,
        autofocus: autofocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.only(left: height! * 0.1 , top: height! * 0.1 * maxLines!),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: CONSTRAINT_PRIMARY_COLOR,
            fontSize: 12,
          ),
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
      ),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = _getFormattedPhoneNumber(newValue.text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
  String _getFormattedPhoneNumber(String value) {
    value = value.replaceAll("-", "").replaceAll(" ", "");
    if (value.length == 1) {
      value = '010-' + value.substring(0, value.length);
    } else if (value.length < 4) {
      value = '010-';
    } else if (value.length >= 8) {
      value = '010-' + value.substring(3,7) + '-' +value.substring(7,value.length);
    } else  {
      value = '010-' + value.substring(3,value.length);
    }
    // else {
    //   value = '010-' + value.substring(0, value.length);
    // }
    return value;
  }
}





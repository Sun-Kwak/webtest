import 'package:flutter/material.dart';
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
        TextFormField(
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
            contentPadding: const EdgeInsets.all(20),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: CONSTRAINT_PRIMARY_COLOR,
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


  const CustomInputFormField({
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
          width: width,
          height: height,
          child: TextFormField(
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 13,
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
                fontSize: 13,
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
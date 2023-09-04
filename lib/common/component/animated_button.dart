import 'package:flutter/material.dart';
import 'package:web_test2/common/component/animated_Object.dart';

class AnimatedButton extends StatelessWidget {
  final FocusNode? focusNode;
  final VoidCallback onPressed;
  final String buttonText;
  final Color backgroundColor;
  final double columnWidth;
  final VoidCallback? onTap;

  const AnimatedButton({
    this.onTap,
    this.focusNode,
    required this.onPressed,
    required this.backgroundColor,
    required this.buttonText,
    required this.columnWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedObject(
      onTap: onTap,
      child: Container(
        height: 50,
        child: ElevatedButton(
          focusNode: focusNode,
          onPressed: onPressed,
          child: Text(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            minimumSize: Size(columnWidth + 10, 65),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

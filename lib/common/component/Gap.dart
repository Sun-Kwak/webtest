import 'package:flutter/material.dart';

class WidthGap extends StatelessWidget {
  final double screenWidth;
  final double? defaultWidth;
  const WidthGap({
    this.defaultWidth,
    required this.screenWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * (defaultWidth ?? 0.01),
    );
  }
}

class HeightGap extends StatelessWidget {
  final double? defaultHeight;
  const HeightGap({
    this.defaultHeight,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: defaultHeight ?? 5,
    );
  }
}

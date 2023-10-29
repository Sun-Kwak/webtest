import 'package:flutter/material.dart';

class CustomBoxRadiusForm extends StatelessWidget {
  final double? width;
  final double? height;
  final double? titleHeight;
  final Widget child;
  final String title;

  const CustomBoxRadiusForm({
    this.titleHeight = 33,
    this.height = 510,
    this.width = 580,
    required this.child,
    required this.title,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      width: width,
      height: height,
      child: Column(

        children: [
          Container(
            decoration:  const BoxDecoration(

              borderRadius: BorderRadius.only( topLeft: Radius.circular(8), // 왼쪽 위 모서리 둥글기
                  topRight: Radius.circular(8)),
              color: Colors.black38,
            ),
            width: double.maxFinite,
            height: titleHeight,
            child: Center(child: Text(title,style: const TextStyle(color: Colors.white,fontSize: 14),)),
          ),
          SizedBox(
            height: height! - titleHeight! - 10,
            child: child,
          )
        ],
      ),
    );
  }
}

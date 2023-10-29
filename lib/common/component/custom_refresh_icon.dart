import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomRefreshIcon extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomRefreshIcon({Key? key,required this.onPressed}) : super(key: key);

  @override
  CustomRefreshIconState createState() => CustomRefreshIconState();
}

class CustomRefreshIconState extends State<CustomRefreshIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // 애니메이션 지속 시간 설정
    );
    _animation =
    Tween<double>(begin: 0, end: 2 * pi).animate(_controller)
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value,
            child: IconButton(
              tooltip: '새로고침',
              icon: const Icon(Icons.refresh, color: PRIMARY_COLOR,),
              onPressed: () {
                _controller.forward(from: 0.0);

                  widget.onPressed(); // 외부에서 전달된 onPressed 콜백을 호출

              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

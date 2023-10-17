import 'package:flutter/material.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomAnimatedIcon extends StatefulWidget {
  final AnimatedIconData iconData;
  final double? size;
  final VoidCallback onTap;

  const CustomAnimatedIcon({
        required this.onTap,
        this.size = 30, required this.iconData, super.key,});

  @override
  State<CustomAnimatedIcon> createState() => _CustomAnimatedIconState();
}

class _CustomAnimatedIconState extends State<CustomAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        {
          widget.onTap();
        }
      },
      child: AnimatedIcon(
        color: PRIMARY_COLOR,
        size:widget.size,
        icon: widget.iconData,
        progress: _animationController,
      ),
    );
  }
}

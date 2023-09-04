import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

class HoverText extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  final bool? isUp;

  const HoverText({
    this.isUp = false, // 수정: isUp
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverTransform = Matrix4.identity()..translate(0, -10, 0);
    final transform = (widget.isUp == true && isHovered == true) ? hoverTransform : Matrix4.identity();


    return MouseRegion(
      onEnter: (e) => mouseEnter(true),
      onExit: (e) => mouseEnter(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        curve: Sprung.overDamped,
        duration: const Duration(milliseconds: 200),
        transform: transform,
        child: widget.builder(isHovered),
      ),
    );
  }

  void mouseEnter(bool hovering) {
    setState(() {
      isHovered = hovering;
    });
  }
}



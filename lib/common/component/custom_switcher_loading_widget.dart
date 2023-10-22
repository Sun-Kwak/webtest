import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomSwitcherLoadingWidget extends StatefulWidget {
  final Duration? duration;
  final Widget? startWidget;
  final Widget? endWidget;

  const CustomSwitcherLoadingWidget({
    super.key,
    this.duration = const Duration(seconds: 2),
    this.startWidget,
    this.endWidget,
  });

  @override
  CustomSwitcherLoadingWidgetState createState() => CustomSwitcherLoadingWidgetState();
}


class CustomSwitcherLoadingWidgetState extends State<CustomSwitcherLoadingWidget> {
  bool _showStartWidget = true;
  Timer? _timer;


  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration!, () {
      if (mounted) {
        setState(() {
          _showStartWidget = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머를 취소하여 메모리 누수를 방지합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration!,
      key: ValueKey<bool>(_showStartWidget),
      child: _showStartWidget ? widget.startWidget ?? startWidget() : widget.endWidget ?? endWidget(),
    );
  }
  Widget startWidget(){
    return SizedBox(
      height: 50,
      child: Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: PRIMARY_COLOR,
          rightDotColor: CONSTRAINT_PRIMARY_COLOR,
          size: 50,
        ),
      ),
    );
  }

  Widget endWidget(){
    return const Center(
      child: Text('데이터가 없습니다.'),
    );
  }
}

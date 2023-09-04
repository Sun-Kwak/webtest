import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final double defaultWidth;
  final double minWidth;

  const DefaultLayout(
      {this.defaultWidth = 0.9,
      this.minWidth = 400,
      this.floatingActionButton,
      this.bottomNavigationBar,
      this.backgroundColor,
      required this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor ?? Colors.white,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double screenWidth = constraints.maxWidth;
          double defaultWidth = screenWidth * this.defaultWidth;
          double minWidth = this.minWidth;

          double columnWidth = defaultWidth;
          if (defaultWidth <= minWidth) {
            columnWidth = minWidth - 30;
          }
          return Center(
              child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              //height: screenHeight,
              width: columnWidth,
              child: child,
            ),
          ));
        }),
      ),
    );
  }
}

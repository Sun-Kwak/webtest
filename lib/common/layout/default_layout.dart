import 'package:flutter/material.dart';

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

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor ?? Colors.white,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double screenWidth = constraints.maxWidth;
          final double calculatedDefaultWidth = screenWidth * defaultWidth;
          final double effectiveMinWidth = minWidth;

          double columnWidth = calculatedDefaultWidth;
          if (calculatedDefaultWidth <= effectiveMinWidth) {
            columnWidth = effectiveMinWidth - 30;
          }

          return Center(
              child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              width: columnWidth,
              child: child,
            ),
          ));
        }),
      ),
    );
  }
}

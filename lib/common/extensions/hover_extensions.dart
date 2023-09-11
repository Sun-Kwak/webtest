import 'package:flutter/material.dart';

extension HoverExtensions on Widget {
  Widget get showCursorOnHover {
    return MouseRegion(
      child: this,
      cursor: SystemMouseCursors.click,
    );
  }
}
//---------------------------------------------------------------------------

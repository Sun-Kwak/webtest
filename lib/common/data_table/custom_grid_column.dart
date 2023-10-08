import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomGridColumn extends GridColumn {
  CustomGridColumn({
    required String columnName,
    required double width,
    required String label,
    bool allowEditing = false,
    bool visible = true,
  }) : super(
    allowEditing: allowEditing,
    visible: visible,
          columnName: columnName,
          width: width,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
          ),
        );
}


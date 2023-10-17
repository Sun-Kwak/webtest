import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart' as Sf;
import 'package:web_test2/common/const/colors.dart';

class CustomSfDataGrid extends StatefulWidget {
  final List<Sf.GridColumn> columns;
  final Map<String, double> columnWidths;
  final Sf.DataGridController dataGridController;
  final Sf.DataGridSource dataGridSource;
  final Sf.ColumnResizeStartCallback? onColumnResizeStart;
  final Sf.ColumnResizeUpdateCallback? onColumnResizeUpdate;
  final int? rowsPerPage;
  final bool allowEditing;


  const CustomSfDataGrid({
    required this.allowEditing,
    required this.rowsPerPage,
    required this.dataGridSource,
    required this.dataGridController,
    required this.columnWidths,
    required this.columns,
    this.onColumnResizeStart,
    this.onColumnResizeUpdate,
    super.key,
  });

  @override
  State<CustomSfDataGrid> createState() => _CustomSfDataGridState();
}

class _CustomSfDataGridState extends State<CustomSfDataGrid> {
  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          selectionColor: TABLE_SELECTION_COLOR,
          rowHoverColor: Colors.black12,
          headerColor: TABLE_HEADER_COLOR,
          headerHoverColor: INPUT_BORDER_COLOR,

      ),
      child: Sf.SfDataGrid(

        // highlightRowOnHover: true,
        gridLinesVisibility: Sf.GridLinesVisibility.none,
        controller: widget.dataGridController,
        onQueryRowHeight: (details) {
          return details.rowIndex == 0 ? 35.0 : 33.0;
        },
        // showCheckboxColumn: true,
        // checkboxShape: CircleBorder(),
        source: widget.dataGridSource,
        columnWidthMode: Sf.ColumnWidthMode.fill,
        // frozenColumnsCount: 3,
        frozenRowsCount: 0,
        headerGridLinesVisibility: Sf.GridLinesVisibility.none,
        columnResizeMode: Sf.ColumnResizeMode.onResize,
        selectionMode: Sf.SelectionMode.single,
        allowColumnsResizing: true,
        allowSorting: true,
        allowFiltering: true,
        showColumnHeaderIconOnHover: true,
        onColumnResizeStart: widget.onColumnResizeStart,
        onColumnResizeUpdate: widget.onColumnResizeUpdate,
        columns: widget.columns,
        showFilterIconOnHover: true,
        rowsPerPage: widget.rowsPerPage,
        allowEditing: widget.allowEditing,
        // navigationMode: Sf.GridNavigationMode.cell,
        // selectionManager: widget.selectionManager,
      ),
    );
  }
}

// onColumnResizeStart: (ColumnResizeStartDetails details) {
// // Disable resizing for the `checkbox` column.
// if (details.columnIndex == 0) {
// return false;
// }
// return true;
// },
// onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
// setState(() {
// widget.columnWidths[details.column.columnName] = details.width;
// });
// return true;
// },
//
// class FirebaseDataSource<T, U> extends DataGridSource {
//   final DataGridController dataGridController;
//   final List<DataGridCell<U>> cells;
//
//   FirebaseDataSource({
//     required this.cells,
//     required this.dataGridController,
//     required List<T> dataList,
//   }) {
//     _dataList = EmployeeDataGridRow.fromDataModel(dataList) as List<DataGridRow>;
//   }
//
//   List<DataGridRow> _dataList = [];
//
//   @override
//   List<DataGridRow> get rows => _dataList;
//
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         // color: Colors.white,
//         cells: row.getCells().map<Widget>((e) {
//       final int index = effectiveRows.indexOf(row);
//       late String cellValue;
//       if (e.value.runtimeType == DateTime) {
//         cellValue = DateFormat('yyyy/MM/dd HH:mm').format(e.value);
//       } else {
//         cellValue = e.value.toString();
//       }
//       return Container(
//         color: (dataGridController.selectedIndex == index)
//             ? TABLE_SELECTION_COLOR
//             : (index % 2 != 0)
//                 ? TABLE_HEADER_COLOR
//                 : Colors.transparent,
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           cellValue,
//           style: TextStyle(
//               color: dataGridController.selectedRows.contains(row)
//                   ? Colors.white
//                   : null),
//         ),
//       );
//     }).toList());
//   }
// }

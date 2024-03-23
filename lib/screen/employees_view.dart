import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/data_table/custom_grid_column.dart';
import 'package:web_test2/common/data_table/custom_sfDataGrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DataGridController dataGridController = DataGridController();

class EmployeesTable extends ConsumerStatefulWidget {
  const EmployeesTable({super.key});

  @override
  ConsumerState<EmployeesTable> createState() => EmployeesTableState();
}

class EmployeesTableState extends ConsumerState<EmployeesTable> {
  late EmployeeDataSource employeeDataSource;
  late Future<List<Employee>> employeesFuture;
  late Map<String, double> columnWidths = {
    'id': double.nan,
    'displayName': double.nan,
    'email': double.nan,
    'level': double.nan,
    'createdAt': double.nan,
    'updatedAt': double.nan,
    'updatedBy': double.nan,
    'checkbox': double.nan,
    'actions': 100,
  };

  @override
  void initState() {
    super.initState();
    employeesFuture = getEmployeeData();
    employeesFuture.then((employees) {
      setState(() {
        employeeDataSource = EmployeeDataSource(employeeData: employees);
      });
    });
  }

  int _rowsPerPage = 10;
  final double _dataPagerHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Employee>>(
        future: employeesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingAnimationWidget.fallingDot(
                color: PRIMARY_COLOR, size: 50);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No data available.');
          } else {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: LayoutBuilder(
                builder: (context, constraint){
                  double containerWidth = screenWidth > 1200 ? 800 : screenWidth * 0.9;
                  double containerHeight = 700;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        color: Colors.white,
                        height: containerHeight -_dataPagerHeight,
                        // width: containerWidth,
                        child: SelectionArea(
                          child: CustomSfDataGrid(
                            onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows){

                            },

                            allowEditing: true,
                            rowsPerPage: _rowsPerPage,
                            onColumnResizeStart:
                                (ColumnResizeStartDetails details) {
                              if (details.columnIndex == 0) {
                                return false;
                              }
                              return true;
                            },
                            onColumnResizeUpdate:
                                (ColumnResizeUpdateDetails details) {
                              setState(() {
                                columnWidths[details.column.columnName] =
                                    details.width;
                              });
                              return true;
                            },
                            dataGridSource: employeeDataSource,
                            dataGridController: dataGridController,
                            columnWidths: columnWidths,
                            columns: <GridColumn>[
                              // CustomGridColumn(
                              //   width: columnWidths['actions']!,
                              //   label: '',
                              //   columnName: 'actions',
                              //   // visible: dataGridController.selectedIndex == ? true : false,
                              // ),
                              CustomGridColumn(
                                width: columnWidths['id']!,
                                label: '아이디',
                                columnName: 'id',
                                visible: false,
                              ),
                              CustomGridColumn(
                                width: columnWidths['displayName']!,
                                label: '이름',
                                columnName: 'displayName',
                              ),
                              CustomGridColumn(
                                width: columnWidths['email']!,
                                label: '이메일',
                                columnName: 'email',
                              ),
                              CustomGridColumn(
                                allowEditing: true,
                                width: columnWidths['level']!,
                                label: '권한',
                                columnName: 'level',
                              ),
                              CustomGridColumn(
                                  width: columnWidths['createdAt']!,
                                  label: '입력 날짜',
                                  columnName: 'createdAt',
                                  visible: screenWidth < 640 ? false : true
                              ),
                              CustomGridColumn(
                                  width: columnWidths['updatedAt']!,
                                  label: '수정 날짜',
                                  columnName: 'updatedAt',
                                  visible: screenWidth < 640 ? false : true
                              ),
                              CustomGridColumn(
                                  width: columnWidths['updatedBy']!,
                                  label: '최종 수정',
                                  columnName: 'updatedBy',
                                  visible: screenWidth < 640 ? false : true
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: containerWidth,
                        height: _dataPagerHeight,
                        child: SfDataPagerTheme(
                          data: SfDataPagerThemeData(
                            selectedItemColor: PRIMARY_COLOR,
                          ),
                          child: SfDataPager(
                            navigationItemWidth: 40,
                            navigationItemHeight: 40,
                            itemWidth: 40,
                            itemHeight: 40,

                            delegate: employeeDataSource,
                            availableRowsPerPage: const [10, 50, 100],
                            onRowsPerPageChanged: (int? rowsPerPage) {
                              setState(() {
                                _rowsPerPage = rowsPerPage!;
                              });
                            },
                            pageCount: ((snapshot.data!.length / _rowsPerPage)
                                .ceil()
                                .toDouble()),
                            // itemWidth: 50,
                          ),
                        ),
                      ),
                      // if (screenHeight > 750)

                      // ),
                      // TextButton(
                      //   child: Text('Get Selection Information'),
                      //   onPressed: () {
                      //     print(snapshot
                      //         .data?[dataGridController.selectedIndex].email);
                      //     // dataGridController.beginEdit(RowColumnIndex(3, 3));
                      //   },
                      // ),
                    ],
                  );
                },
              ),
            );
          }
        });
  }

  Future<List<Employee>> getEmployeeData() async {
    List<Employee> employees = [];
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('employees');

      QuerySnapshot querySnapshot = await collection
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate)
          .get();

      for (var document in querySnapshot.docs) {
        Employee employee = Employee.fromFirestore(document);
        employees.add(employee);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    return employees;
  }
  Widget _buildDataGrid(BoxConstraints constraints) {
    double screenWidth = MediaQuery.of(context).size.width;
    return CustomSfDataGrid(
      onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows){

      },

      allowEditing: true,
      rowsPerPage: _rowsPerPage,
      onColumnResizeStart:
          (ColumnResizeStartDetails details) {
        if (details.columnIndex == 0) {
          return false;
        }
        return true;
      },
      onColumnResizeUpdate:
          (ColumnResizeUpdateDetails details) {
        setState(() {
          columnWidths[details.column.columnName] =
              details.width;
        });
        return true;
      },
      dataGridSource: employeeDataSource,
      dataGridController: dataGridController,
      columnWidths: columnWidths,
      columns: <GridColumn>[
        // CustomGridColumn(
        //   width: columnWidths['actions']!,
        //   label: '',
        //   columnName: 'actions',
        //   // visible: dataGridController.selectedIndex == ? true : false,
        // ),
        CustomGridColumn(
          width: columnWidths['id']!,
          label: '아이디',
          columnName: 'id',
          visible: false,
        ),
        CustomGridColumn(
          width: columnWidths['displayName']!,
          label: '이름',
          columnName: 'displayName',
        ),
        CustomGridColumn(
          width: columnWidths['email']!,
          label: '이메일',
          columnName: 'email',
        ),
        CustomGridColumn(
          allowEditing: true,
          width: columnWidths['level']!,
          label: '권한',
          columnName: 'level',
        ),
        CustomGridColumn(
            width: columnWidths['createdAt']!,
            label: '입력 날짜',
            columnName: 'createdAt',
            visible: screenWidth < 640 ? false : true
        ),
        CustomGridColumn(
            width: columnWidths['updatedAt']!,
            label: '수정 날짜',
            columnName: 'updatedAt',
            visible: screenWidth < 640 ? false : true
        ),
        CustomGridColumn(
            width: columnWidths['updatedBy']!,
            label: '최종 수정',
            columnName: 'updatedBy',
            visible: screenWidth < 640 ? false : true
        )
      ],
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employeeData}) {
    // _paginatedOrders = _orders.getRange(0, 19).toList(growable: false);
    _employeeData = employeeData;
    // _paginatedRows = employeeData;
    buildPaginatedDataGridRows();
  }

  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  List<DataGridRow> _employeeDataGridRows = [];
  List<Employee> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeDataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        // color: Colors.white,
        cells: row.getCells().map<Widget>((e) {
      final int index = effectiveRows.indexOf(row);
      late String cellValue;
      if (e.value.runtimeType == DateTime) {
        cellValue = DateFormat('yyyy/MM/dd HH:mm').format(e.value);
      } else {
        cellValue = e.value.toString();
      }
      return Container(
        color:
        (dataGridController.selectedRows.contains(row))
            ? TABLE_SELECTION_COLOR :
        (index % 2 != 0)
                ? TABLE_COLOR
                : Colors.transparent,
        alignment: Alignment.center,
        // padding: const EdgeInsets.all(8.0),
        child: e.columnName == 'actions'
            ? dataGridController.selectedIndex == index
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        color: Colors.blueAccent,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    ],
                  )
                : null
            : Text(
                cellValue,
                // enableInteractiveSelection: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 12,
                    color: dataGridController.selectedRows.contains(row)
                        ? Colors.white
                        : Colors.black87),
              ),
      );
    }).toList());
  }

  void buildPaginatedDataGridRows() {
    _employeeDataGridRows = _employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              // DataGridCell<IconButton>(columnName: 'actions', value: null),
              DataGridCell<String>(columnName: 'id', value: e.id),
              DataGridCell<String>(
                  columnName: 'displayName', value: e.displayName),
              DataGridCell<String>(columnName: 'email', value: e.email),
              DataGridCell<int>(columnName: 'level', value: e.level),
              DataGridCell<DateTime>(
                  columnName: 'createdAt', value: e.createdAt),
              DataGridCell<DateTime>(
                  columnName: 'updatedAt', value: e.updatedAt),
              DataGridCell(columnName: 'updatedBy', value: e.updatedBy)
            ]))
        .toList();
  }
  //
  // @override
  // Future<void> onCellSubmit(DataGridRow dataGridRow,
  //     RowColumnIndex rowColumnIndex, GridColumn column) async {
  //   final dynamic oldValue = dataGridRow
  //           .getCells()
  //           .firstWhere((DataGridCell dataGridCell) =>
  //               dataGridCell.columnName == column.columnName)
  //           ?.value ??
  //       '';
  //
  //   final int dataRowIndex = _employeeDataGridRows.indexOf(dataGridRow);
  //
  //   if (newCellValue == null || oldValue == newCellValue) {
  //     return;
  //   }
  //
  //   if (column.columnName == 'level') {
  //     _employeeDataGridRows[dataRowIndex]
  //             .getCells()[rowColumnIndex.columnIndex] =
  //         DataGridCell<int>(columnName: 'level', value: newCellValue);
  //     _employeeData[dataRowIndex].level = newCellValue as int;
  //   }
  // }
  //
  // Future<bool> canSubmitCell(DataGridRow dataGridRow,
  //     RowColumnIndex rowColumnIndex, GridColumn column) async {
  //   if (newCellValue == null || newCellValue == '') {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
  //
  // Widget? buildEditWidget(DataGridRow dataGridRow,
  //     RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
  //   final String displayText = dataGridRow
  //           .getCells()
  //           .firstWhere((DataGridCell dataGridCell) =>
  //               dataGridCell.columnName == column.columnName)
  //           ?.value
  //           ?.toString() ??
  //       '';
  //   newCellValue = null;
  //
  //   final bool isNumericType = column.columnName == 'level';
  //
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
  //     child: TextField(
  //       autofocus: true,
  //       controller: editingController..text = displayText,
  //       textAlign: isNumericType ? TextAlign.right : TextAlign.left,
  //       autocorrect: false,
  //       decoration: InputDecoration(
  //         contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
  //       ),
  //       inputFormatters: <TextInputFormatter>[],
  //       keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
  //       onChanged: (String value) {
  //         if (value.isNotEmpty) {
  //           if (isNumericType) {
  //             newCellValue = int.parse(value);
  //           } else {
  //             newCellValue = value;
  //           }
  //         } else {
  //           newCellValue = null;
  //         }
  //       },
  //       onSubmitted: (String value) {
  //         /// Call [CellSubmit] callback to fire the canSubmitCell and
  //         /// onCellSubmit to commit the new value in single place.
  //         submitCell();
  //       },
  //     ),
  //   );
  // }
}

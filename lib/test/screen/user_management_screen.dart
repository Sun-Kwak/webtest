import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/data_table/custom_sfDataGrid.dart';
import 'package:web_test2/common/data_table/custom_grid_column.dart';
import 'package:web_test2/common/layout/default_layout.dart';
import 'package:authentication_repository/src/employee_model.dart';
import 'package:intl/intl.dart';
import 'package:web_test2/screen/auth/controller/authentication_controller.dart';


DataGridController dataGridController = DataGridController();

class UserManagementScreen extends ConsumerStatefulWidget {
  /// Creates the home page.
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  UserManagementScreenState createState() => UserManagementScreenState();
}

class UserManagementScreenState extends ConsumerState<UserManagementScreen> {
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

  // bool isAllowed = false;
  // final double _dataPagerHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    final authController = ref.read(userMeProvider.notifier);
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultLayout(
      defaultWidth: 0.5,
      // defaultHeight: screenHeight * 10,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          authController.onSignOut();
        },
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
        child: Tooltip(message: '로그아웃', child: Icon(Icons.logout_outlined)),
      ),
      child: FutureBuilder<List<Employee>>(
          future: employeesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAnimationWidget.fallingDot(
                  color: PRIMARY_COLOR, size: 50);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available.');
            } else {
              return Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (screenHeight > 200)
                    SizedBox(
                      height: screenHeight < 700 ? screenHeight - 100 : 600,
                      child: CustomSfDataGrid(
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
                          CustomGridColumn(
                            width: columnWidths['actions']!,
                            label: '',
                            columnName: 'actions',
                          ),
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
                          ),
                          CustomGridColumn(
                            width: columnWidths['updatedAt']!,
                            label: '수정 날짜',
                            columnName: 'updatedAt',
                          ),
                          CustomGridColumn(
                            width: columnWidths['updatedBy']!,
                            label: '최종 수정',
                            columnName: 'updatedBy',
                          )
                        ],
                      ),
                    ),
                  // if (screenHeight > 750)
                  SfDataPagerTheme(
                    data: SfDataPagerThemeData(
                      selectedItemColor: PRIMARY_COLOR,
                    ),
                    child: SfDataPager(
                      delegate: employeeDataSource,
                      availableRowsPerPage: const [10, 50, 100],
                      onRowsPerPageChanged: (int? rowsPerPage) {
                        setState(() {
                          _rowsPerPage = rowsPerPage!;
                          // employeeDataSource.updateDataGriDataSource();
                          // employeeDataSource =  EmployeeDataSource(employeeData: snapshot.data!);
                          // employeeDataSource.handlePageChange(oldPageIndex, newPageIndex);
                          // getEmployeeData();
                        });
                      },
                      pageCount: ((snapshot.data!.length / _rowsPerPage)
                          .ceil()
                          .toDouble()),
                      itemWidth: 50,
                    ),
                  ),
                  TextButton(
                      child: Text('Get Selection Information'),
                      onPressed: () {
                        print(snapshot.data?[dataGridController.selectedIndex].email);
                        // dataGridController.beginEdit(RowColumnIndex(3, 3));
                      }),
                  // Container(
                  //   height: screenHeight * 0.8,
                  //   child: ,
                  // ),
                ],
              );
            }
          }),
    );
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

// Widget _buildEmployeeDataGrid(BoxConstraints constraint) {
//   return CustomSfDataGrid(
//     selectionManager: _employeeSelectionManager,
//     onColumnResizeStart:
//         (ColumnResizeStartDetails details) {
//       if (details.columnIndex == 0) {
//         return false;
//       }
//       return true;
//     },
//     onColumnResizeUpdate:
//         (ColumnResizeUpdateDetails details) {
//       setState(() {
//         columnWidths[details.column.columnName] =
//             details.width;
//       });
//       return true;
//     },
//     dataGridSource: employeeDataSource,
//     dataGridController: dataGridController,
//     columnWidths: columnWidths,
//     columns: <GridColumn>[
//       CustomGridColumn(
//         width: columnWidths['id']!,
//         label: '아이디',
//         columnName: 'id',
//         visible: false,
//       ),
//       CustomGridColumn(
//         width: columnWidths['displayName']!,
//         label: '이름',
//         columnName: 'displayName',
//       ),
//       CustomGridColumn(
//         width: columnWidths['email']!,
//         label: '이메일',
//         columnName: 'email',
//       ),
//       CustomGridColumn(
//         width: columnWidths['level']!,
//         label: '권한',
//         columnName: 'level',
//       ),
//       CustomGridColumn(
//         width: columnWidths['createdAt']!,
//         label: '입력 날짜',
//         columnName: 'createdAt',
//       ),
//       CustomGridColumn(
//         width: columnWidths['updatedAt']!,
//         label: '수정 날짜',
//         columnName: 'updatedAt',
//       ),
//       CustomGridColumn(
//         width: columnWidths['updatedBy']!,
//         label: '최종 수정',
//         columnName: 'updatedBy',
//       )
//     ],
//   );
// }
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

  // List<Employee> _paginatedRows = [];
  List<Employee> _employeeData = [];

  //
  //
  // int _rowsPerPage = 10;

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
        color: (dataGridController.selectedRows.contains(row))
            ? TABLE_SELECTION_COLOR
            : (index % 2 != 0)
                ? TABLE_HEADER_COLOR
                : Colors.transparent,
        alignment: Alignment.center,
        // padding: const EdgeInsets.all(8.0),
        child: e.columnName == 'actions'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      dataGridController.selectedIndex = index;
                      dataGridController.beginEdit(RowColumnIndex(index, 4));
                      print(RowColumnIndex(index, 3));
                    },
                    icon: Icon(Icons.edit),
                    color: Colors.blueAccent,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                    color: Colors.redAccent,
                  ),
                ],
              )
            : Text(
                cellValue,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: dataGridController.selectedRows.contains(row)
                        ? Colors.white
                        : null),
              ),
      );
    }).toList());
  }

  //
  // @override
  // Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) {
  //   final int _startIndex = newPageIndex * _rowsPerPage;
  //   int _endIndex = _startIndex + _rowsPerPage;
  //   if (_endIndex > _employeeData.length) {
  //     _endIndex = _employeeData.length;
  //   }
  //
  //   /// Get a particular range from the sorted collection.
  //   if (_startIndex < _employeeData.length &&
  //       _endIndex <= _employeeData.length) {
  //     _paginatedRows = _employeeData.getRange(_startIndex, _endIndex).toList();
  //   } else {
  //     _paginatedRows = <Employee>[];
  //   }
  //   buildPaginatedDataGridRows();
  //   notifyListeners();
  //   return Future<bool>.value(true);
  //
  // }
  // //
  // void updateDataGriDataSource(){
  //   // _rowsPerPage = rowsPerPage;
  //   // print('2.${_rowsPerPage}');
  //   // // buildPaginatedDataGridRows();
  //   notifyListeners();
  // }

  void buildPaginatedDataGridRows() {
    // _employeeDataGridRows = _employeeData
    _employeeDataGridRows = _employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<IconButton>(columnName: 'actions', value: null),
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

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow
        .getCells()
        .firstWhere((DataGridCell dataGridCell) =>
    dataGridCell.columnName == column.columnName)
        ?.value ??
        '';

    final int dataRowIndex = _employeeDataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'level') {
      _employeeDataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'level', value: newCellValue);
      _employeeData[dataRowIndex].level = newCellValue as int;
    }
  }

  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    if (newCellValue == null || newCellValue == '') {
      // Editing widget will retain in view.
      // onCellSubmit method will not fire.
      return false;
    } else {
      // Allow to call the onCellSubmit.
      return true;
    }
  }

  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    final String displayText = dataGridRow
        .getCells()
        .firstWhere((DataGridCell dataGridCell) =>
    dataGridCell.columnName == column.columnName)
        ?.value
        ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType =
        column.columnName == 'level' ;

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        inputFormatters: <TextInputFormatter>[
        ],
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

}

// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:web_test2/common/const/colors.dart';
// import 'package:web_test2/common/data_table/custom_sfDataGrid.dart';
// import 'package:web_test2/common/data_table/custom_grid_column.dart';
// import 'package:web_test2/common/layout/default_layout.dart';
// import 'package:authentication_repository/src/employee_model.dart';
// import 'package:intl/intl.dart';
//
// import '../../auth/controller/authentication_controller.dart';
//
// DataGridController dataGridController = DataGridController();
//
// class UserManagementScreen extends ConsumerStatefulWidget {
//   /// Creates the home page.
//   const UserManagementScreen({Key? key}) : super(key: key);
//
//   @override
//   UserManagementScreenState createState() => UserManagementScreenState();
// }
//
// class UserManagementScreenState extends ConsumerState<UserManagementScreen> {
//   late EmployeeDataSource employeeDataSource;
//   late Future<List<Employee>> employeesFuture;
//   late Map<String, double> columnWidths = {
//     'id': double.nan,
//     'displayName': double.nan,
//     'email': double.nan,
//     'level': double.nan,
//     'createdAt': double.nan,
//     'updatedAt': double.nan,
//     'updatedBy': double.nan,
//     'checkbox': double.nan
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     employeesFuture = getEmployeeData();
//     employeesFuture.then((employees) {
//       setState(() {
//         employeeDataSource = EmployeeDataSource(employeeData: employees);
//       });
//     });
//   }
//
//   int _rowsPerPage = 10;
//   // final double _dataPagerHeight = 80.0;
//
//   @override
//   Widget build(BuildContext context) {
//     final authController = ref.read(userMeProvider.notifier);
//     double screenHeight = MediaQuery
//         .of(context)
//         .size
//         .height;
//
//     return DefaultLayout(
//       defaultWidth: 0.5,
//       // defaultHeight: screenHeight * 10,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           authController.onSignOut();
//         },
//         backgroundColor: PRIMARY_COLOR,
//         foregroundColor: Colors.white,
//         child: Tooltip(message: '로그아웃', child: Icon(Icons.logout_outlined)),
//       ),
//       child: FutureBuilder<List<Employee>>(
//           future: employeesFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return LoadingAnimationWidget.fallingDot(
//                   color: PRIMARY_COLOR, size: 50);
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Text('No data available.');
//             } else {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 // crossAxisAlignment: CrossAxisAlignment.stretch,
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (screenHeight > 200)
//                   SizedBox(
//                     height: screenHeight < 700 ? screenHeight -100 : 600,
//                     child: CustomSfDataGrid(
//                       onColumnResizeStart:
//                           (ColumnResizeStartDetails details) {
//                         if (details.columnIndex == 0) {
//                           return false;
//                         }
//                         return true;
//                       },
//                       onColumnResizeUpdate:
//                           (ColumnResizeUpdateDetails details) {
//                         setState(() {
//                           columnWidths[details.column.columnName] =
//                               details.width;
//                         });
//                         return true;
//                       },
//                       dataGridSource: employeeDataSource,
//                       dataGridController: dataGridController,
//                       columnWidths: columnWidths,
//                       columns: <GridColumn>[
//                         CustomGridColumn(
//                           width: columnWidths['addButton']!,
//                           label: 'addButton',
//                           columnName: 'addButton',
//                         ),
//                         CustomGridColumn(
//                           width: columnWidths['id']!,
//                           label: '아이디',
//                           columnName: 'id',
//                           visible: false,
//                         ),
//                         CustomGridColumn(
//                           width: columnWidths['displayName']!,
//                           label: '이름',
//                           columnName: 'displayName',
//                         ),
//                         CustomGridColumn(
//                           width: columnWidths['email']!,
//                           label: '이메일',
//                           columnName: 'email',
//                         ),
//                         CustomGridColumn(
//                           width: columnWidths['level']!,
//                           label: '권한',
//                           columnName: 'level',
//                         ),
//                         CustomGridColumn(
//                           width: columnWidths['createdAt']!,
//                           label: '입력 날짜',
//                           columnName: 'createdAt',
//                         ),
//                         CustomGridColumn(
//                           width: columnWidths['updatedAt']!,
//                           label: '수정 날짜',
//                           columnName: 'updatedAt',
//                         ),
//                         CustomGridColumn(
//                           width: columnWidths['updatedBy']!,
//                           label: '최종 수정',
//                           columnName: 'updatedBy',
//                         )
//                       ],
//                     ),
//                   ),
//                   // if (screenHeight > 750)
//                   SfDataPagerTheme(
//                     data: SfDataPagerThemeData(
//                       selectedItemColor: PRIMARY_COLOR,
//                     ),
//                     child: SfDataPager(
//                       delegate: employeeDataSource,
//                       availableRowsPerPage: const [10,50,100],
//                       onRowsPerPageChanged: (int? rowsPerPage){
//                         setState(() {
//                           _rowsPerPage = rowsPerPage!;
//                           employeeDataSource =  EmployeeDataSource(employeeData: snapshot.data!);
//                           // getEmployeeData();
//                           // employeeDataSource.updateDataGriDataSource();
//                         });
//                       },
//                       pageCount: ((snapshot.data!.length/_rowsPerPage).ceil().toDouble()),
//                       itemWidth: 50,
//
//                       // visibleItemsCount: 1,
//                       // pageCount: ((employeeDataSource.employeeData.length/_rowsPerPage).ceil().toDouble()),
//                     ),
//                   )
//                   // TextButton(
//                   //     child: Text('Get Selection Information'),
//                   //     onPressed: () {
//                   //       var _currentCell = dataGridController.currentCell;
//                   //       print(_currentCell);
//                   //     }),
//                   // Container(
//                   //   height: screenHeight * 0.8,
//                   //   child: ,
//                   // ),
//                 ],
//               );
//             }
//           }),
//     );
//   }
//
//   Future<List<Employee>> getEmployeeData() async {
//     List<Employee> employees = [];
//     final endDate = DateTime.now();
//     final startDate = endDate.subtract(Duration(days: 30));
//     try {
//       CollectionReference collection =
//       FirebaseFirestore.instance.collection('employees');
//
//       QuerySnapshot querySnapshot = await collection
//           .where('createdAt', isGreaterThanOrEqualTo: startDate)
//           .where('createdAt', isLessThanOrEqualTo: endDate)
//           .get();
//
//       for (var document in querySnapshot.docs) {
//         Employee employee = Employee.fromFirestore(document);
//         employees.add(employee);
//       }
//     } catch (e) {
//       print(e);
//       throw Exception(e);
//     }
//     return employees;
//   }
//
//   // Widget _buildEmployeeDataGrid(BoxConstraints constraint) {
//   //   return CustomSfDataGrid(
//   //     selectionManager: _employeeSelectionManager,
//   //     onColumnResizeStart:
//   //         (ColumnResizeStartDetails details) {
//   //       if (details.columnIndex == 0) {
//   //         return false;
//   //       }
//   //       return true;
//   //     },
//   //     onColumnResizeUpdate:
//   //         (ColumnResizeUpdateDetails details) {
//   //       setState(() {
//   //         columnWidths[details.column.columnName] =
//   //             details.width;
//   //       });
//   //       return true;
//   //     },
//   //     dataGridSource: employeeDataSource,
//   //     dataGridController: dataGridController,
//   //     columnWidths: columnWidths,
//   //     columns: <GridColumn>[
//   //       CustomGridColumn(
//   //         width: columnWidths['id']!,
//   //         label: '아이디',
//   //         columnName: 'id',
//   //         visible: false,
//   //       ),
//   //       CustomGridColumn(
//   //         width: columnWidths['displayName']!,
//   //         label: '이름',
//   //         columnName: 'displayName',
//   //       ),
//   //       CustomGridColumn(
//   //         width: columnWidths['email']!,
//   //         label: '이메일',
//   //         columnName: 'email',
//   //       ),
//   //       CustomGridColumn(
//   //         width: columnWidths['level']!,
//   //         label: '권한',
//   //         columnName: 'level',
//   //       ),
//   //       CustomGridColumn(
//   //         width: columnWidths['createdAt']!,
//   //         label: '입력 날짜',
//   //         columnName: 'createdAt',
//   //       ),
//   //       CustomGridColumn(
//   //         width: columnWidths['updatedAt']!,
//   //         label: '수정 날짜',
//   //         columnName: 'updatedAt',
//   //       ),
//   //       CustomGridColumn(
//   //         width: columnWidths['updatedBy']!,
//   //         label: '최종 수정',
//   //         columnName: 'updatedBy',
//   //       )
//   //     ],
//   //   );
//   // }
// }
//
// class EmployeeDataSource extends DataGridSource {
//   EmployeeDataSource({required List<Employee> employeeData}) {
//     // _paginatedOrders = _orders.getRange(0, 19).toList(growable: false);
//     _employeeData = employeeData;
//     // _paginatedRows = employeeData;
//     buildPaginatedDataGridRows();
//   }
//
//   List<DataGridRow> _employeeDataGridRows = [];
//   // List<Employee> _paginatedRows = [];
//   List<Employee> _employeeData = [];
//   //
//   //
//   // int _rowsPerPage = 10;
//
//   @override
//   List<DataGridRow> get rows => _employeeDataGridRows;
//
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//       // color: Colors.white,
//         cells: row.getCells().map<Widget>((e) {
//           final int index = effectiveRows.indexOf(row);
//           late String cellValue;
//           if (e.value.runtimeType == DateTime) {
//             cellValue = DateFormat('yyyy/MM/dd HH:mm').format(e.value);
//           } else {
//             cellValue = e.value.toString();
//           }
//           return Container(
//             color: (dataGridController.selectedRows.contains(row))
//                 ? TABLE_SELECTION_COLOR
//                 : (index % 2 != 0)
//                 ? TABLE_HEADER_COLOR
//                 : Colors.transparent,
//             alignment: Alignment.center,
//             padding: const EdgeInsets.all(8.0),
//             child: e.columnName == 'addButton' ? IconButton(onPressed: (){}, icon: Icon(Icons.add)) : Text(
//               cellValue,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                   color: dataGridController.selectedRows.contains(row)
//                       ? Colors.white
//                       : null),
//             ),
//           );
//         }).toList());
//   }
//
//   // // @override
//   // Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) {
//   //   final int _startIndex = newPageIndex * _rowsPerPage;
//   //   int _endIndex = _startIndex + _rowsPerPage;
//   //   if (_endIndex > _employeeData.length) {
//   //     _endIndex = _employeeData.length;
//   //   }
//   //
//   //   /// Get a particular range from the sorted collection.
//   //   if (_startIndex < _employeeData.length &&
//   //       _endIndex <= _employeeData.length) {
//   //     _paginatedRows = _employeeData.getRange(_startIndex, _endIndex).toList();
//   //   } else {
//   //     _paginatedRows = <Employee>[];
//   //   }
//   //   buildPaginatedDataGridRows();
//   //   notifyListeners();
//   //   return Future<bool>.value(true);
//   //
//   // }
//   //
//   // void updateDataGriDataSource(){
//   //   // _rowsPerPage = rowPerPage;
//   //   // print('2.${_rowsPerPage}');
//   //   // // buildPaginatedDataGridRows();
//   //   notifyListeners();
//   // }
//
// void buildPaginatedDataGridRows() {
//   _employeeDataGridRows = _employeeData
//       .map<DataGridRow>((e) => DataGridRow(cells: [
//             const DataGridCell<Widget>(columnName: 'addButton', value: null),
//             DataGridCell<String>(columnName: 'id', value: e.id),
//             DataGridCell<String>(
//                 columnName: 'displayName', value: e.displayName),
//             DataGridCell<String>(columnName: 'email', value: e.email),
//             DataGridCell<int>(columnName: 'level', value: e.level),
//             DataGridCell<DateTime>(
//                 columnName: 'createdAt', value: e.createdAt),
//             DataGridCell<DateTime>(
//                 columnName: 'updatedAt', value: e.updatedAt),
//             DataGridCell(columnName: 'updatedBy', value: e.updatedBy)
//           ]))
//       .toList();
// }}
//

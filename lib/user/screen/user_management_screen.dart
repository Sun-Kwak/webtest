import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_test2/common/layout/default_layout.dart';
import 'package:authentication_repository/src/employee_model.dart';

import '../../auth/controller/authentication_controller.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  /// Creates the home page.
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  UserManagementScreenState createState() => UserManagementScreenState();
}

class UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  late EmployeeDataSource employeeDataSource;
  late Future<List<Employee>> employeesFuture;

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

  @override
  Widget build(BuildContext context) {
    final authController = ref.read(userMeProvider.notifier);
    final authenticationState = ref.watch(userMeProvider);

    return DefaultLayout(
      child: FutureBuilder<List<Employee>>(
        future: employeesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터를 가져오는 중이면 로딩 표시
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // 에러 발생 시 처리
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // 데이터가 없을 때 처리
            return Text('No data available.');
          } else {
            // 데이터가 있을 때 데이터 그리드 표시
            return Column(
              children: [
                TextButton(
                  onPressed: () async {
                    //

                    authController.onSignOut();
                    //context.goNamed(AuthenticationView.routeName);
                    print(authenticationState.status);
                  },
                  child: const Text('로그아웃'),
                ),
                SfDataGrid(
                  source: employeeDataSource,
                  columnWidthMode: ColumnWidthMode.auto,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'id',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('아이디'))),
                    GridColumn(
                        columnName: 'displayName',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('이름'))),
                    GridColumn(
                        columnName: 'email',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('이매일',
                                overflow: TextOverflow.ellipsis))),
                    GridColumn(
                        columnName: 'level',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('권한'))),
                    GridColumn(
                        columnName: 'createdAt',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('입력날짜'))),
                    GridColumn(
                        columnName: 'updatedAt',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('수정날짜'))),
                    // 컬럼 정의 추가
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<Employee>> getEmployeeData() async {
    List<Employee> employees = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Firebase Firestore 컬렉션 이름을 여기에 넣어주세요.
          .get();

      print(querySnapshot);

      querySnapshot.docs.forEach((document) {
        String id = document.id;
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        print(data);
        // Firebase로부터 받아온 데이터로 Employee 객체 생성
        Employee employee = Employee(
          id: id, // id 값이 null이면 'N/A'로 대체
          displayName: data['displayName'] ?? '??', // displayName 값이 null이면 'N/A'로 대체
          email: data['email'] ?? '??', // email 값이 null이면 'N/A'로 대체
          level: data['level'] ?? 5,
          updatedBy: data['updatedBy'],
          createdAt: data['createdAt'],
          updatedAt: data['updatedAt'],// level 값이 null이면 0으로 대체
        );
        print(employee.id);
        employees.add(employee);
        print(employees.first.id);
      });
    } catch (e) {
      // 데이터 가져오기 중 에러 처리
      print("Error fetching data: $e");
    }

    return employees;
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'displayName', value: e.displayName),
      DataGridCell<String>(
          columnName: 'email', value: e.email),
      DataGridCell<int>(columnName: 'level', value: e.level),
      DataGridCell<DateTime>(columnName: 'createdAt', value: e.createdAt),
      DataGridCell<DateTime>(columnName: 'updatedAt', value: e.updatedAt),

    ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Employee {
  final String id; // Firestore 문서의 고유 ID
  final String displayName;
  final String email;
  late final int level;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final String? actions;

  Employee({
    // this.actions,
    required this.id, // Firestore 문서의 고유 ID
    required this.displayName,
    required this.email,
    required this.level,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Employee copyWith(
      {String? id, // Firestore 문서의 고유 ID
      String? displayName,
      String? email,
      int? level,
      String? updatedBy,
      DateTime? createdAt, // 생성 시간
      DateTime? updatedAt,
      // String? actions // 업데이트 시간
      }) {
    return Employee(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      level: level ?? 5,
      updatedBy: updatedBy ?? displayName ?? this.updatedBy,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      // actions: actions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'level': level,
      'updatedBy': updatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      // 'actions': actions,
    };
  }

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      level: map['level'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      // actions: null,
    );
  }

  factory Employee.empty() => Employee(
        id: '',
        displayName: '',
        email: '',
        level: 5,
        updatedBy: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // actions: null,
      );
}

// class EmployeeDataGridRow extends DataGridRow {
//   // final DataGridCell<String> displayName;
//   // final DataGridCell<String> email;
//   // final DataGridCell<int> level;
//   // final DataGridCell<String> updatedBy;
//   // final DataGridCell<DateTime> createdAt;
//   // final DataGridCell<DateTime> updatedAt;
//
//   EmployeeDataGridRow({
//     // required this.displayName,
//     // required this.email,
//     // required this.level,
//     // required this.updatedBy,
//     // required this.updatedAt,
//     // required this.createdAt,
//     required super.cells,
//   });
//
//   factory EmployeeDataGridRow.fromDataModel(List<Employee> employeeData) {
//     final map = employeeData as Map<String, dynamic>;
//     return EmployeeDataGridRow(cells: [
//       DataGridCell<String>(
//           columnName: 'displayName', value: map['displayName'] ?? ''),
//       DataGridCell<String>(columnName: 'email', value: map['email'] ?? ''),
//       DataGridCell<int>(columnName: 'level', value: map['level'] ?? ''),
//       DataGridCell<DateTime>(
//           columnName: 'createdAt', value: map['createdAt'].toDate()),
//       DataGridCell<DateTime>(
//           columnName: 'updatedAt', value: map['updatedAt'].toDate()),
//       DataGridCell(columnName: 'updatedBy', value: map['updatedBy'] ?? '')
//     ]);
//   }
// }

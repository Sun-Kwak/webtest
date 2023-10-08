import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'employee_model.dart';

final employeeProvider = StateNotifierProvider<EmployeeProvider, List<Employee>>((ref) {
  final repository = ref.watch(employeeRepositoryProvider);
  return EmployeeProvider(repository: repository);
});

class EmployeeProvider extends StateNotifier<List<Employee>> {
  final EmployeeRepository repository;
  
  EmployeeProvider({
    required this.repository,
}) : super([]);
  
  Future<void> getEmployee ({DateTime? startDate, DateTime? endDate}) async {
    endDate ??= DateTime.now();
    startDate ??= endDate.subtract(Duration(days: 30));
    await repository.getEmployeeData(
      endDate: endDate,
      startDate: startDate,
    );
  }
}

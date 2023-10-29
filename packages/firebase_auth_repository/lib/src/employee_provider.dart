import 'package:authentication_repository/authentication_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final employeeProvider = StateNotifierProvider<EmployeeProvider, List<Employee>>((ref) {
  final repository = ref.watch(employeeRepositoryProvider);
  return EmployeeProvider(repository: repository);
});

class EmployeeProvider extends StateNotifier<List<Employee>> {
  final EmployeeRepository repository;
  
  EmployeeProvider({
    required this.repository,
}) : super([]){getEmployee();}

  Future<void> getEmployee() async {
    try {
      List<Employee> employees = await repository.getEmployeesData();
      state = employees;
    } catch (e) {
      print('Error: $e');
    }
  }
  
  // Future<void> getEmployee (
  // // {// DateTime? startDate, DateTime? endDate}
  // ) async {
  //   // endDate ??= DateTime.now();
  //   // startDate ??= endDate.subtract(const Duration(days: 30));
  //   await repository.getEmployeeData(
  //     // endDate: endDate,
  //     // startDate: startDate,
  //   );
  // }
}
//-------------------------------------------------------------------------
class SelectedPICIDProvider extends StateNotifier<String> {
  SelectedPICIDProvider(String initialValue) : super(initialValue);

  void setSelectedRow(String newValue) {
    state = newValue;
  }
}

final selectedPICIdProvider =
StateNotifierProvider<SelectedPICIDProvider, String>((ref) {
  final String? signedInUser = ref.watch(signedInUserProvider).value?.id;
  return SelectedPICIDProvider(signedInUser!);
});
//------------------------------------------------------------------------------
final selectedPICProvider = Provider<Employee>((ref) {
  final employeeState = ref.watch(employeeProvider);
  final selectedID = ref.watch(selectedPICIdProvider);
  Employee selectedPIC;
  if (employeeState.isEmpty) {
    selectedPIC = Employee.empty();
  } else {
    selectedPIC =
        employeeState.firstWhere((element) => element.id == selectedID);
  }
  return selectedPIC;
});

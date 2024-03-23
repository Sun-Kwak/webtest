import 'package:authentication_repository/src/employee_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final employeeRepositoryProvider = Provider((ref) => EmployeeRepository());

class EmployeeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> signUpSetUserData(String email, String displayName) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   Employee employee = Employee.empty();
  //
  //   try {
  //     DocumentReference userDocRef = _firestore.collection('employees').doc(user!.uid);
  //
  //     DocumentSnapshot userDoc = await userDocRef.get();
  //     if (!userDoc.exists) {
  //       await _firestore.collection('employees').doc(user.uid).set(employee.copyWith(
  //         id: user.uid,
  //         email: email,
  //         displayName: displayName,
  //       ).toMap());
  //     }
  //   } catch (e) {
  //
  //     throw Exception(e);
  //   }
  // }

  Future<List<Employee>> getEmployeesData() async {
    List<Employee> employees = [];
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('employees');

      QuerySnapshot querySnapshot = await collection.get();

      for (var document in querySnapshot.docs) {
        Employee employee = Employee.fromFirestore(document);
        employees.add(employee);
      }
    } on FirebaseException catch (e) {

      throw EmployeeGetFailure(e.toString());
    }
    return employees;
  }
}

class EmployeeGetFailure implements Exception {
  final String code;

  const EmployeeGetFailure(this.code);
}

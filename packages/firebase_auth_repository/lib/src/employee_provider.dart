import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'employee_model.dart';

final employeeProvider = Provider((ref) => EmployeeRepository());

class EmployeeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpUpdateUserData(String email, String displayName) async {
    User? user = FirebaseAuth.instance.currentUser;
    Employee employee = Employee.empty();

    try {
      // 해당 문서의 참조 가져오기
      DocumentReference userDocRef = _firestore.collection('employees').doc(user!.uid);

      // 해당 문서가 존재하지 않을 때만 생성
      DocumentSnapshot userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        await _firestore.collection('employees').doc(user!.uid).set(employee.copyWith(
          id: user.uid,
          email: email,
          displayName: displayName,
        ).toMap());
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}

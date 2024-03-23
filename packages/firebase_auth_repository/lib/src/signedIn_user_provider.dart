import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:authentication_repository/src/employee_model.dart';

final signedInUserProvider = FutureProvider<Employee?>((ref) async {
  final authState = ref.watch(userMeProvider);
  final uid = authState.user.id;
  final data = await FirebaseFirestore.instance.collection('employees').doc(uid).get();

  if (data.exists) {
    final signedInUserData = Employee.fromFirestore(data);
    return signedInUserData;
  } else {
    return Employee.empty();
  }
});


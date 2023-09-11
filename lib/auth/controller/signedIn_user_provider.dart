import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:web_test2/auth/controller/authentication_controller.dart';
import 'package:authentication_repository/src/employee_model.dart';

final signedInUserProvider = FutureProvider<Employee>((ref) async {
  final authState = ref.watch(userMeProvider);
  final uid = authState.user.id;
  final data = await FirebaseFirestore.instance.collection('users').doc(uid).get();

  // final signedInUserData = Employee(
  //   id: uid,
  //   displayName: data['displayName'],
  //   email: data['email'],
  //   level: data['level'],
  //   updatedBy: data['updatedBy'],
  //   createdAt: data['createdAt'],
  //   updatedAt: data['updatedAt'],
  // );
  final signedInUserData = Employee.fromFirestore(data);
  return signedInUserData;
});

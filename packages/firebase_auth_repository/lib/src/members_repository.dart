import 'dart:js';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/employee_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class MemberAddFailure implements Exception {
  final String code;

  const MemberAddFailure(this.code);
}

class MemberGetFailure implements Exception {
  final String code;

  const MemberGetFailure(this.code);
}

class MemberCheckPhoneNumberFailure implements Exception {
  final String code;

  const MemberCheckPhoneNumberFailure(this.code);
}

final memberRepositoryProvider = Provider<MemberRepository>((_) => MemberRepository());

class MemberRepository {

  Future<void> addMember(Member member) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference members = firestore.collection('members');
      Map<String, dynamic> memberData = member.toMap();

      await firestore.runTransaction((transaction) async {
        QuerySnapshot querySnapshot = await members.orderBy('id', descending: true).limit(1).get();
        int maxId = 0;
        if (querySnapshot.docs.isNotEmpty) {
          maxId = querySnapshot.docs[0]['id'];
        }

        // 새로운 문서에 할당할 ID 값 계산
        int newId = maxId + 1;
        memberData['id'] = newId;
        memberData['updatedBy'] = user?.displayName;
        await members.add(memberData).then((_){

        });

      });
    } on FirebaseException catch (e){
      print('??$e');
      throw MemberAddFailure(e.toString());
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference members = firestore.collection('members');
      QuerySnapshot querySnapshot = await members.where('phoneNumber', isEqualTo: phoneNumber).get();

      // 중복된 번호가 있으면 true를 반환, 없으면 false를 반환
      return querySnapshot.docs.isNotEmpty;
    } on FirebaseException catch (e){
      print('??$e');
      throw MemberCheckPhoneNumberFailure(e.toString());
    }
  }

  Future<List<Member>> getMembersData() async {
    List<Member> members = [];
    try {
      CollectionReference collection =
      FirebaseFirestore.instance.collection('members');
      QuerySnapshot querySnapshot = await collection.get();

      for (var document in querySnapshot.docs) {
        Member member = Member.fromFirestore(document);
        members.add(member);
      }
    } on FirebaseException catch (e){
      print(e);
      throw MemberGetFailure(e.toString());
    }
    return members;
  }
}

Future<List<Member>> getMembersData() async {
  List<Member> members = [];
  try {
    CollectionReference collection =
    FirebaseFirestore.instance.collection('members');
    QuerySnapshot querySnapshot = await collection.get();

    for (var document in querySnapshot.docs) {
      Member member = Member.fromFirestore(document);
      members.add(member);
    }
  } on FirebaseException catch (e){
    print(e);
    throw MemberGetFailure(e.toString());
  }
  return members;
}


  // Future<void> getEmployeeData({required DateTime startDate,
  //   required DateTime endDate}) async {
  //
  //   List<Employee> employees = [];
  //   try {
  //     CollectionReference collection = FirebaseFirestore.instance.collection('employees');
  //
  //     QuerySnapshot querySnapshot = await collection
  //         .where('createdAt', isGreaterThanOrEqualTo: startDate)
  //         .where('createdAt', isLessThanOrEqualTo: endDate)
  //         .get();
  //
  //     for (var document in querySnapshot.docs) {
  //       Employee employee = Employee.fromFirestore(document);
  //       employees.add(employee);
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw Exception(e);
  //   }
  // }


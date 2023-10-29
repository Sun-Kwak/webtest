
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

final memberRepositoryProvider = Provider<MemberRepository>(
  (ref) => MemberRepository(ref.watch(selectedReferralIDProvider)),
);

class MemberRepository {
  SelectedReferralIDProvider selectedReferralIDProvider;

  MemberRepository(this.selectedReferralIDProvider);

  Future<void> addMember(Member member) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference members = firestore.collection('members');
      Map<String, dynamic> memberData = member.toMap();

      await firestore.runTransaction((transaction) async {
        QuerySnapshot querySnapshot =
        await members.orderBy('id', descending: true).limit(1).get();
        int maxId = 0;
        if (querySnapshot.docs.isNotEmpty) {
          maxId = querySnapshot.docs[0]['id'];
        }

        int newId = maxId + 1;
        memberData['id'] = newId;
        memberData['updatedBy'] = user?.displayName;
        memberData['referralID'] =
            selectedReferralIDProvider.selectedReferralId;
        memberData['referralName'] =
            selectedReferralIDProvider.selectedReferralName;
        await members.add(memberData).then((_) {
          selectedReferralIDProvider.setSelectedReferralID(null, null);
        });
      });
    } on FirebaseException catch (e) {
      throw MemberAddFailure(e.toString());
    }
  }

  Future<void> updateMember(Member member) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference members = firestore.collection('members');
      Map<String, dynamic> memberData = member.toMap();

      // 멤버의 ID 가져오기
      String memberId = member.docId;

      // 해당 ID를 가진 멤버를 찾아 업데이트
      DocumentReference memberRef = members.doc(memberId);
      memberData['updatedBy'] = user?.displayName;
      memberData['referralID'] = selectedReferralIDProvider.selectedReferralId;
      memberData['referralName'] =
          selectedReferralIDProvider.selectedReferralName;

      // 멤버 데이터 업데이트
      await memberRef.update(memberData).then((_) {
        selectedReferralIDProvider.setSelectedReferralID(null, null);
      });
    } on FirebaseException catch (e) {

      throw MemberAddFailure(e.toString());
    }
  }

  Future<void> disableMember(Member member, MembersProvider membersProvider) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference members = firestore.collection('members');
      Map<String, dynamic> memberData = member.toMap();

      // 멤버의 ID 가져오기
      String memberId = member.docId;

      // 해당 ID를 가진 멤버를 찾아 업데이트
      DocumentReference memberRef = members.doc(memberId);
      if (member.status == '활성') {
        memberData['status'] = '비활성';
      } else {
        memberData['status'] = '활성';
      }
      memberData['updatedBy'] = user?.displayName;

      // 멤버 데이터 업데이트
      await memberRef.update(memberData).then((_) {
        // selectedReferralIDProvider.setSelectedReferralID(null, null);
        membersProvider.getMembers();
      });
    } on FirebaseException catch (e) {

      throw MemberAddFailure(e.toString());
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference members = firestore.collection('members');
      QuerySnapshot querySnapshot =
      await members.where('phoneNumber', isEqualTo: phoneNumber).get();

      return querySnapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {

      throw MemberCheckPhoneNumberFailure(e.toString());
    }
  }

  Future<List<Member>> getMembersData() async {
    List<Member> members = [];
    try {
      CollectionReference collection =
      FirebaseFirestore.instance.collection('members');

      QuerySnapshot querySnapshot = await collection
          .where('status', isEqualTo: '활성')
          .orderBy('createdAt', descending: true)
          .get();

      for (var document in querySnapshot.docs) {
        Member member = Member.fromFirestore(document);
        members.add(member);
      }
    } on FirebaseException catch (e) {

      throw MemberGetFailure(e.toString());
    }
    return members;
  }


  Future<List<Member>> getDisabledMembersData() async {
    List<Member> members = [];
    try {
      CollectionReference collection =
      FirebaseFirestore.instance.collection('members');

      QuerySnapshot querySnapshot = await collection
          .where('status', isEqualTo: '비활성')
          .orderBy('createdAt', descending: true)
          .get();

      for (var document in querySnapshot.docs) {
        Member member = Member.fromFirestore(document);
        members.add(member);
      }
    } on FirebaseException catch (e) {

      throw MemberGetFailure(e.toString());
    }
    return members;
  }


  Future<List<int>> getMonthlyMemberCounts(List<Member> members) async {
    Map<String, int> monthlyCounts = {};

    // members 리스트의 각 멤버의 createdAt 필드를 이용하여 월별로 그룹화합니다.
    for (var member in members) {
      String monthYear = '${member.createdAt.month}-${member.createdAt.year}';
      monthlyCounts.update(monthYear, (value) => value + 1, ifAbsent: () => 1);
    }

    // 월별 멤버 수를 정수 리스트로 변환합니다.
    List<int> monthlyCountsList = monthlyCounts.values.toList();

    // 월별 멤버 수 리스트를 반환합니다.
    return monthlyCountsList;
  }
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


import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/measurement_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MeasurementAddFailure implements Exception {
  final String code;

  const MeasurementAddFailure(this.code);
}

class MeasurementGetFailure implements Exception {
  final String code;

  const MeasurementGetFailure(this.code);
}
final measurementRepositoryProvider = Provider<MeasurementRepository>(
      (ref) => MeasurementRepository(),
);

class MeasurementRepository {

  MeasurementRepository();

  Future<void> addMeasurement(Measurement measurement) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference measurements = firestore.collection('measurements');
      Map<String, dynamic> measurementData = measurement.toMap();

      // 문서를 추가하고 DocumentReference를 받아옴
      DocumentReference docRef = await measurements.add(measurementData);

      // 자동으로 생성된 문서 ID를 가져와 'docId' 필드에 업데이트
      await docRef.update({'docId': docRef.id, 'updatedBy': user?.displayName});

    } on FirebaseException catch (e) {
      throw MemberAddFailure(e.toString());
    }
  }

  Future<void> updateMeasurement(Measurement measurement) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference measurements = firestore.collection('measurements');
      Map<String, dynamic> measurementData = measurement.toMap();

      // 멤버의 ID 가져오기
      String measurementId = measurement.docId;

      // 해당 ID를 가진 멤버를 찾아 업데이트
      DocumentReference measurementRef = measurements.doc(measurementId);
      measurementData['updatedBy'] = user?.displayName;

      // 멤버 데이터 업데이트
      await measurementRef.update(measurementData).then((_) {

      });
    } on FirebaseException catch (e) {

      throw MeasurementAddFailure(e.toString());
    }
  }
  //
  // Future<void> disableMember(Member member, MembersProvider membersProvider) async {
  //   try {
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     User? user = FirebaseAuth.instance.currentUser;
  //     CollectionReference members = firestore.collection('members');
  //     Map<String, dynamic> memberData = member.toMap();
  //
  //     // 멤버의 ID 가져오기
  //     String memberId = member.docId;
  //
  //     // 해당 ID를 가진 멤버를 찾아 업데이트
  //     DocumentReference memberRef = members.doc(memberId);
  //     if (member.status == '활성') {
  //       memberData['status'] = '비활성';
  //     } else {
  //       memberData['status'] = '활성';
  //     }
  //     memberData['updatedBy'] = user?.displayName;
  //
  //     // 멤버 데이터 업데이트
  //     await memberRef.update(memberData).then((_) {
  //       // selectedReferralIDProvider.setSelectedReferralID(null, null);
  //       membersProvider.getMembers();
  //     });
  //   } on FirebaseException catch (e) {
  //
  //     throw MemberAddFailure(e.toString());
  //   }
  // }

  Future<List<Measurement>> getMeasurementData() async {
    List<Measurement> measurements = [];
    try {
      CollectionReference collection =
      FirebaseFirestore.instance.collection('measurements');

      QuerySnapshot querySnapshot = await collection
          .where('status', isEqualTo: '활성')
          .orderBy('createdAt', descending: true)
          .get();

      for (var document in querySnapshot.docs) {
        Measurement measurement = Measurement.fromFirestore(document);
        measurements.add(measurement);
      }
    } on FirebaseException catch (e) {
      throw MeasurementGetFailure(e.toString());
    }
    return measurements;
  }

  Future<Measurement> getLatestMeasurement(int memberId) async {
    Measurement latestMeasurement = Measurement.empty();
    try {
      CollectionReference collection =
      FirebaseFirestore.instance.collection('measurements');

      QuerySnapshot querySnapshot = await collection
          .where('memberId', isEqualTo: memberId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        latestMeasurement = Measurement.fromFirestore(querySnapshot.docs.first);
      }
    } on FirebaseException catch (e) {
      throw MeasurementGetFailure(e.toString());
    }
    return latestMeasurement;
  }

//
//   Future<List<Member>> getDisabledMembersData() async {
//     List<Member> members = [];
//     try {
//       CollectionReference collection =
//       FirebaseFirestore.instance.collection('members');
//
//       QuerySnapshot querySnapshot = await collection
//           .where('status', isEqualTo: '비활성')
//           .orderBy('createdAt', descending: true)
//           .get();
//
//       for (var document in querySnapshot.docs) {
//         Member member = Member.fromFirestore(document);
//         members.add(member);
//       }
//     } on FirebaseException catch (e) {
//
//       throw MemberGetFailure(e.toString());
//     }
//     return members;
//   }
//
//
//   Future<List<int>> getMonthlyMemberCounts(List<Member> members) async {
//     Map<String, int> monthlyCounts = {};
//
//     // members 리스트의 각 멤버의 createdAt 필드를 이용하여 월별로 그룹화합니다.
//     for (var member in members) {
//       String monthYear = '${member.createdAt.month}-${member.createdAt.year}';
//       monthlyCounts.update(monthYear, (value) => value + 1, ifAbsent: () => 1);
//     }
//
//     // 월별 멤버 수를 정수 리스트로 변환합니다.
//     List<int> monthlyCountsList = monthlyCounts.values.toList();
//
//     // 월별 멤버 수 리스트를 반환합니다.
//     return monthlyCountsList;
//   }
// }
}

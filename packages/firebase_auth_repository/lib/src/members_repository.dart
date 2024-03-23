import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final memberRepositoryProvider = Provider<MemberRepository>(
  (ref) {
    final firestore = ref.read(firestoreProvider);
    final auth = ref.read(firebaseAuthProvider);

    return MemberRepository(firestore, auth);
  },
);

class MemberRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  MemberRepository(this._firestore, this._auth);

  CollectionReference get _membersCollection =>
      _firestore.collection('members');

//---------------------CREATE------------------------------------------------------
  Future<void> createMember(Member member) async {
    try {
      final Map<String, dynamic> memberData = member.toMap();

      await _firestore.runTransaction((transaction) async {
        QuerySnapshot querySnapshot = await _membersCollection
            .orderBy('id', descending: true)
            .limit(1)
            .get();
        int maxId = 0;
        if (querySnapshot.docs.isNotEmpty) {
          maxId = querySnapshot.docs[0]['id'];
        }


        int newId = maxId + 1;
        memberData['id'] = newId;
        memberData['updatedBy'] = _auth.currentUser?.displayName;
        DocumentReference newMemberRef = await _membersCollection.add(memberData);
        // DocumentSnapshot snapshot = await transaction.get(newMemberRef);

        // transaction.update(snapshot.reference, {'id':maxId});
      });
    } on FirebaseException catch (e) {
      throw UpdateMemberFailure(e.code);
    }
  }

//---------------------READ------------------------------------------------------
  Future<List<Member>> readMembers() async {
    List<Member> members = [];
    try {
      QuerySnapshot querySnapshot = await _membersCollection
          .where('status', isEqualTo: '활성')
          .orderBy('createdAt', descending: true)
          .get();

      for (var document in querySnapshot.docs) {
        Member member = Member.fromFirestore(document);
        members.add(member);
      }
    } on FirebaseException catch (e) {
      throw ReadMemberFailure(e.code);
    }
    return members;
  }

  Future<List<Member>> readDisabledMembers() async {
    List<Member> members = [];
    try {
      QuerySnapshot querySnapshot = await _membersCollection
          .where('status', isEqualTo: '비활성')
          .orderBy('createdAt', descending: true)
          .get();

      for (var document in querySnapshot.docs) {
        Member member = Member.fromFirestore(document);
        members.add(member);
      }
    } on FirebaseException catch (e) {
      throw ReadMemberFailure(e.code);
    }
    return members;
  }

  //---------------------UPDATE------------------------------------------------------

  Future<void> updateMember(Member member) async {
    try {
      final Map<String, dynamic> memberData = member.toMap();

      String memberId = member.docId;

      DocumentReference memberRef = _membersCollection.doc(memberId);
      memberData['updatedBy'] = _auth.currentUser?.displayName;

      await memberRef.update(memberData);
    } on FirebaseException catch (e) {

      throw UpdateMemberFailure(e.code);

    }
  }

  //---------------------DELETE------------------------------------------------------

  Future<void> disableMember(
      Member member, MembersProvider membersProvider) async {
    try {
      final Map<String, dynamic> memberData = member.toMap();

      String memberId = member.docId;

      DocumentReference memberRef = _membersCollection.doc(memberId);
      if (member.status == '활성') {
        memberData['status'] = '비활성';
      } else {
        memberData['status'] = '활성';
      }
      memberData['updatedBy'] = _auth.currentUser?.displayName;

      await memberRef.update(memberData).then((_) {
        membersProvider.getMembers();
      });
    } on FirebaseException catch (e) {
      throw UpdateMemberFailure(e.code);
    }
  }

  //---------------------CHECK------------------------------------------------------
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await _membersCollection
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw CheckMemberPhoneNumberFailure(e.toString());
    }
  }

  //---------------------TO BE MOVED------------------------------------------------------
  // Future<List<int>> getMonthlyMemberCounts(List<Member> members) async {
  //   Map<String, int> monthlyCounts = {};
  //
  //   for (var member in members) {
  //     String monthYear = '${member.createdAt.month}-${member.createdAt.year}';
  //     monthlyCounts.update(monthYear, (value) => value + 1, ifAbsent: () => 1);
  //   }
  //   List<int> monthlyCountsList = monthlyCounts.values.toList();
  //   return monthlyCountsList;
  // }
}

//---------------------FAILURE------------------------------------------------------

class CreateMemberFailure implements Exception {
  final String code;

  const CreateMemberFailure(this.code);
}

class UpdateMemberFailure implements Exception {
  final String code;

  const UpdateMemberFailure(this.code);
}

class ReadMemberFailure implements Exception {
  final String code;

  const ReadMemberFailure(this.code);
}

class CheckMemberPhoneNumberFailure implements Exception {
  final String code;

  const CheckMemberPhoneNumberFailure(this.code);
}

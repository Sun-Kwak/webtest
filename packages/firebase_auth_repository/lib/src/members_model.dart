import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String docId; // Firestore 문서의 고유 ID
  final int id;
  final String displayName;
  final String? email;
  final int? level;
  final String gender;
  final String birthDay;
  final String phoneNumber;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? address;
  final String signUpPath;
  final int? referralID;
  final String? referralName;
  final String? accountLinkID;
  final String? memo;
  final String? status;
  final int? referralCount;
  final String? firstDate;
  final String? expiryDate;
  final int? totalFee;
  final int? totalAttendanceDays;
  final int? openVOC;
  final int? closeVOC;
  final int? unresolvedVOC;
  final String? contractStatus;
  final String? branch;

  // final String? actions;

  Member({
    this.branch,
    this.referralName,
    required this.docId,
    required this.id,
    required this.phoneNumber,
    required this.gender,
    required this.birthDay,
    this.address,
    required this.signUpPath,
    this.referralID,
    this.accountLinkID,
    this.memo,
    this.status,
    this.referralCount,
    this.firstDate,
    this.expiryDate,
    this.totalFee,
    this.totalAttendanceDays,
    required this.displayName,
    this.email,
    this.level,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.openVOC,
    this.closeVOC,
    this.unresolvedVOC,
    this.contractStatus,
  });

  Member copyWith({
    String? docId,
    int? id,
    String? displayName,
    String? email,
    int? level,
    String? updatedBy,
    DateTime? createdAt, // 생성 시간
    DateTime? updatedAt,
    String? gender,
    String? birthDay,
    String? phoneNumber,
    String? address,
    String? signUpPath,
    int? referralID,
    String? referralName,
    String? accountLinkID,
    String? memo,
    String? status,
    int? referralCount,
    String? firstDate,
    String? expiryDate,
    int? totalFee,
    int? totalAttendanceDays,
    int? openVOC,
    int? closeVOC,
    int? unresolvedVOC,
    String? contractStatus,
    String? branch,
    // String? actions // 업데이트 시간
  }) {
    return Member(
      memo: memo ?? this.memo,
      docId: docId ?? this.docId,
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDay: birthDay ?? this.birthDay,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      signUpPath: signUpPath ?? this.signUpPath,
      referralID: referralID ?? this.referralID,
      referralName: referralName ?? this.referralName,
      accountLinkID: accountLinkID ?? this.accountLinkID,
      status: status ?? this.status,
      referralCount: referralCount ?? this.referralCount,
      firstDate: firstDate ?? this.firstDate,
      expiryDate: expiryDate ?? this.expiryDate,
      totalFee: totalFee ?? this.totalFee,
      totalAttendanceDays: totalAttendanceDays ?? this.totalAttendanceDays,
      level: level ?? 5,
      updatedBy: updatedBy ?? displayName ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      openVOC: openVOC ?? this.openVOC,
      closeVOC: closeVOC ?? this.closeVOC,
      unresolvedVOC: unresolvedVOC ?? this.unresolvedVOC,
      contractStatus: contractStatus ?? this.contractStatus,
      branch: branch ?? this.branch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'level': level,
      'gender': gender,
      'birthDay': birthDay,
      'phoneNumber': phoneNumber,
      'address': address,
      'signUpPath':signUpPath,
      'referralID': referralID,
      'referralName': referralName,
      'accountLinkID': accountLinkID,
      'memo': memo,
      'status': status.toString(),
      'referralCount': referralCount,
      'firstDate': firstDate,
      'expiryDate': expiryDate,
      'totalFee': totalFee,
      'totalAttendanceDays': totalAttendanceDays,
      'updatedBy': updatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'openVOC': openVOC,
      'closeVOC': closeVOC,
      'unresolvedVOC': unresolvedVOC,
      'contractStatus': contractStatus,
      'branch': branch
      // 'actions': actions,
    };
  }



  factory Member.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Member(
      docId: doc.id,
      id: map['id'],
      displayName: map['displayName'],
      email: map['email'] ?? '',
      level: map['level'],
      gender: map['gender'],
      birthDay: map['birthDay'],
      phoneNumber: map['phoneNumber'],
      address: map['address'] ?? '',
      signUpPath: map['signUpPath'],
      referralID: map['referralID'],
      referralName: map['referralName'] ?? '',
      accountLinkID: map['accountLinkID'] ?? '',
      memo: map['memo'] ?? '',
      status: map['status'],
      referralCount: map['referralCount'],
      firstDate: map['firstDate'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      totalFee: map['totalFee'],
      totalAttendanceDays: map['totalAttendanceDays'],
      updatedBy: map['updatedBy'] ?? '',
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      openVOC: map['openVOC'] ?? '',
      closeVOC: map['closeVOC'] ?? '',
      unresolvedVOC: map['unresolvedVOC'] ?? '',
      contractStatus: map['contractStatus'] ?? '',
      branch: map['branch'] ?? '',
    );
  }

  factory Member.empty() =>
      Member(
        docId: '',
        id: 0,
        displayName: '',
        email: '',
        level: 5,
        updatedBy: '',
        gender: '여성',
        birthDay: '',
        phoneNumber: '',
        address: null,
        signUpPath: '기타',
        referralID: null,
        accountLinkID: null,
        memo: null,
        status: '활성',
        referralCount: 0,
        firstDate: null,
        expiryDate: null,
        totalFee: 0,
        totalAttendanceDays: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        openVOC: 0,
        closeVOC: 0,
        unresolvedVOC: 0,
        contractStatus: '신규',
        branch: '동천역'
        // actions: null,
      );
}

class MonthlyMemberModel {
  final int month;
  final int count;
  MonthlyMemberModel({
    required this.month,
    required this.count,
});
}

class MemberCountModel {
  final int totalCount;
  final int newCount;
  final int contractCount;
  final int expiredCount;
  MemberCountModel({
    required this.totalCount,
    required this.newCount,
    required this.contractCount,
    required this.expiredCount,
  });
}

enum MembersCountFilterState {
  totalCount,
  newCount,
  contractCount,
  expiredCount,
}


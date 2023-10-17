import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String id; // Firestore 문서의 고유 ID
  final String displayName;
  final String? email;
  final int? level;
  final String gender;
  final String birthDay;
  final String phoneNumber;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  late final String? address;
  late final String signUpPath;
  final String? referralID;
  final String? accountLinkID;
  final String? memo;
  final String? status;
  final int? referralCount;
  final DateTime? firstDate;
  final DateTime? expiryDate;
  final int? totalFee;
  final int? totalAttendanceDays;

  // final String? actions;

  Member({
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
    required this.id, // Firestore 문서의 고유 ID
    required this.displayName,
    this.email,
    this.level,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Member copyWith({
    String? id, // Firestore 문서의 고유 ID
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
    String? referralID,
    String? accountLinkID,
    String? memo,
    String? status,
    int? referralCount,
    DateTime? firstDate,
    DateTime? expiryDate,
    int? totalFee,
    int? totalAttendanceDays,
    // String? actions // 업데이트 시간
  }) {
    return Member(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDay: birthDay ?? this.birthDay,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      signUpPath: signUpPath ?? this.signUpPath,
      referralID: referralID ?? referralID,
      accountLinkID: accountLinkID ?? this.accountLinkID,
      status: status ?? this.status,
      referralCount: referralCount ?? this.referralCount,
      firstDate: firstDate ?? this.firstDate,
      expiryDate: expiryDate ?? this.expiryDate,
      totalFee: totalFee ?? this.totalFee,
      totalAttendanceDays: totalAttendanceDays ?? this.totalAttendanceDays,
      level: level ?? 5,
      updatedBy: updatedBy ?? displayName ?? this.updatedBy,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
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
      'accountLinkID': accountLinkID,
      'memo': memo,
      'status': status.toString(),
      'referralCount': referralCount,
      'firstDate': firstDate == null ? null : Timestamp.fromDate(firstDate!),
      'expiryDate': expiryDate == null ? null : Timestamp.fromDate(expiryDate!),
      'totalFee': totalFee,
      'totalAttendanceDays': totalAttendanceDays,
      'updatedBy': updatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      // 'actions': actions,
    };
  }

  factory Member.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Member(
      id: doc.id,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      level: map['level'],
      gender: map['gender'],
      birthDay: map['birthDay'],
      phoneNumber: map['phoneNumber'],
      address: map['address'] ?? '',
      signUpPath: map['signUpPath'],
      referralID: map['referralID'] ?? '',
      accountLinkID: map['accountLinkID'] ?? '',
      memo: map['memo'] ?? '',
      status: map['status'],
      referralCount: map['referralCount'],
      firstDate: map['firstDate'] == null ? null : map['firstDate'].toData(),
      expiryDate: map['expiryDate'] == null ? null : map['expiryDate'].toDate(),
      totalFee: map['totalFee'],
      totalAttendanceDays: map['totalAttendanceDays'],
      updatedBy: map['updatedBy'] ?? '',
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      // actions: null,
    );
  }

  factory Member.empty() =>
      Member(
        id: '',
        displayName: '',
        email: '',
        level: 5,
        updatedBy: '',
        gender: '여성',
        birthDay: '',
        phoneNumber: '',
        address: null,
        signUpPath: '',
        referralID: null,
        accountLinkID: null,
        memo: null,
        status: '신규',
        referralCount: 0,
        firstDate: null,
        expiryDate: null,
        totalFee: 0,
        totalAttendanceDays: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // actions: null,
      );
}

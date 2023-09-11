import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id; // Firestore 문서의 고유 ID
  final String displayName;
  final String email;
  final int level;
  final String updatedBy;
  final DateTime createdAt; // 생성 시간
  final DateTime updatedAt; // 업데이트 시간

  Employee({
    required this.id, // Firestore 문서의 고유 ID
    required this.displayName,
    required this.email,
    required this.level,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Employee copyWith({
    String? id, // Firestore 문서의 고유 ID
    String? displayName,
    String? email,
    int? level,
    String? updatedBy,
    DateTime? createdAt, // 생성 시간
    DateTime? updatedAt, // 업데이트 시간
  }) {
    return Employee(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      level: level ?? 5,
      updatedBy: updatedBy ?? displayName ?? '',
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
      'updatedBy': updatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      level: map['level'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
    );
  }

  factory Employee.empty() => Employee(
        id: '',
        displayName: '',
        email: '',
        level: 5,
        updatedBy: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

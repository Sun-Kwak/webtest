import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firestoreProvider =
    Provider<FirebaseFirestore>((ref)=>FirebaseFirestore.instance);

final storageProvider =
Provider<FirebaseStorage>((ref)=>FirebaseStorage.instance);
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

// final memberUpdateProvider = Provider<MemberUpdateRepository>((ref) {
//   return MemberUpdateRepository(isDoneSave: null);
// });
//
// class MemberUpdateRepository{
//   bool? isDoneSave;
//   MemberUpdateRepository({
//     required  this.isDoneSave,
//   });
//
//   void toggleStatus(bool action) {
//     isDoneSave = action;
//   }
// }


final memberEditingProvider = ChangeNotifierProvider<MemberEditingProvider>((ref) {
  return MemberEditingProvider(isEditing: false);
});

class MemberEditingProvider extends ChangeNotifier {
  bool isEditing;

  MemberEditingProvider({
    required  this.isEditing,
  });

  void toggleStatus(bool action) {
    isEditing = action;
    // notifyListeners();
  }
}
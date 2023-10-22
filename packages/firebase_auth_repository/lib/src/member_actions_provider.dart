import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

enum MemberUpdateStatus {
  on,
  off,
}
final memberUpdateProvider = ChangeNotifierProvider<MemberUpdateProvider>((ref) {
  return MemberUpdateProvider(ref: ref);
});

class MemberUpdateProvider extends ChangeNotifier {
  final Ref ref;
  MemberUpdateStatus _status = MemberUpdateStatus.off;

  MemberUpdateProvider({
    required this.ref,
  });

  MemberUpdateStatus get status => _status;

  void toggleStatus() {
    _status = _status == MemberUpdateStatus.on
        ? MemberUpdateStatus.off
        : MemberUpdateStatus.on;
    notifyListeners();
  }
}

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
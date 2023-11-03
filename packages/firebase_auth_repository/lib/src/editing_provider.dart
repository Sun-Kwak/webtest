import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

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

final measurementEditingProvider = ChangeNotifierProvider<MeasurementEditingProvider>((ref) {
  return MeasurementEditingProvider(isEditing: false);
});

class MeasurementEditingProvider extends ChangeNotifier {
  bool isEditing;

  MeasurementEditingProvider({
    required  this.isEditing,
  });

  void toggleStatus(bool action) {
    isEditing = action;
    // notifyListeners();
  }
}
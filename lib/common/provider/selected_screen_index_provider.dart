import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedScreenIndexProvider extends StateNotifier<int> {
  SelectedScreenIndexProvider(int initialValue) : super(initialValue);

  void setSelectedIndex(int newValue) {
    state = newValue;
  }
}

final selectedScreenIndexProvider =
StateNotifierProvider<SelectedScreenIndexProvider, int>((ref) {
  return SelectedScreenIndexProvider(0);
});
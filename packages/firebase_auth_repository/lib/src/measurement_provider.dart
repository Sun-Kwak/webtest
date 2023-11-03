import 'package:authentication_repository/authentication_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

final measurementProvider =
StateNotifierProvider<MeasurementProvider, List<Measurement>>((ref) {
  final repository = ref.watch(measurementRepositoryProvider);
  return MeasurementProvider(repository: repository);
});

class MeasurementProvider extends StateNotifier<List<Measurement>> {
  final MeasurementRepository repository;

  MeasurementProvider({
    required this.repository,
  }) : super([]) {
    getMeasurements();
  }

  Future<void> getMeasurements() async {
    try {
      List<Measurement> measurements = await repository.getMeasurementData();
      state = measurements;
    } catch (e) {
      print('Error: $e');
    }
  }
}

class SelectedMeasurementIDProvider extends StateNotifier<String?> {
  SelectedMeasurementIDProvider(String? initialValue) : super(initialValue);

  void setSelectedRow(String? newValue) {
    state = newValue;
  }
  notifyListeners() {
    // TODO: implement notifyListeners
    throw UnimplementedError();
  }
}

final selectedMeasurementIdProvider =
StateNotifierProvider<SelectedMeasurementIDProvider, String?>((ref) {
  return SelectedMeasurementIDProvider(null);
});
//------------------------------------------------------------------------------
final selectedMeasurementProvider = Provider<Measurement>((ref) {
  final measurementsState = ref.watch(measurementProvider);
  final selectedID = ref.watch(selectedMeasurementIdProvider);
  Measurement selectedMeasurement;
  if (selectedID == null || measurementsState.isEmpty) {
    selectedMeasurement = Measurement.empty();
  } else {
    selectedMeasurement =
        measurementsState.firstWhere((element) => element.docId == selectedID);
  }
  return selectedMeasurement;
});
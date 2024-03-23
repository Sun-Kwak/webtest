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

class SelectedScheduleMeasurementIDProvider extends StateNotifier<String?> {
  SelectedScheduleMeasurementIDProvider(String? initialValue) : super(initialValue);

  void setSelectedRow(String? newValue) {
    state = newValue;
  }
  notifyListeners() {
    // TODO: implement notifyListeners
    throw UnimplementedError();
  }
}

final selectedScheduleMeasurementIdProvider =
StateNotifierProvider<SelectedScheduleMeasurementIDProvider, String?>((ref) {
  return SelectedScheduleMeasurementIDProvider(null);
});
//------------------------------------------------------------------------------
final selectedScheduleMeasurementProvider = Provider.autoDispose<Measurement>((ref) {
  final measurementsState = ref.watch(measurementProvider);
  final selectedID = ref.watch(selectedScheduleMeasurementIdProvider);
  Measurement selectedMeasurement;
  if (selectedID == null || measurementsState.isEmpty) {
    selectedMeasurement = Measurement.empty();
  } else {
    selectedMeasurement =
        measurementsState.firstWhere((element) => element.docId == selectedID);
  }
  return selectedMeasurement;
});

// final filterMeasurement =
// StateProvider<String?>((ref) => null);

final filteredMeasurementProvider = Provider<List<Measurement>>(
      (ref) {
    final measurements = ref.watch(measurementProvider);
    final selectedMemberId = ref.watch(selectedMemberIdProvider);
    return measurements
        .where(
          (element) => selectedMemberId == element.memberId
    )
        .toList();
  },
);

final baselineFilteredMeasurementProvider = Provider<List<Measurement>>(
      (ref) {
    final measurements = ref.watch(filteredMeasurementProvider);
    final selectedMeasurement = ref.watch(selectedMeasurementProvider);

    // Initialize maxCreatedAt as null
    // DateTime? maxCreatedAt;
    //
    // // Find the element with the maximum createdAt value
    // measurements
    //     .where((element).forEach((measurement) {
    //   if (measurement.createdAt.isAfter(maxCreatedAt!)) {
    //     maxCreatedAt = measurement.createdAt;
    //   }
    // });

    // Exclude the element based on selectedMeasurementIdProvider
    return measurements
        .where((element) {
        return element.docId != selectedMeasurement.docId;
    })
        .toList();
  },
);

// final latestMeasurementProvider = Provider<String?>((ref) {
//   final measurementsState = ref.watch(measurementProvider);
//   final selectedMemberId = ref.watch(selectedMemberIdProvider);
//   String? latestMeasurementId;
//
//   // Find the latest measurement with matching memberId
//   Measurement? latestMeasurement;
//   for (var measurement in measurementsState) {
//     if (measurement.memberId == selectedMemberId) {
//       if (latestMeasurement == null || measurement.createdAt.isAfter(latestMeasurement.createdAt)) {
//         latestMeasurement = measurement;
//       }
//     }
//   }
//
//   // Assign the latest measurement's docId to latestMeasurementId
//   if (latestMeasurement != null) {
//     latestMeasurementId = latestMeasurement.docId;
//   }
//
//   return latestMeasurementId;
// });

final selectedMeasurementProvider =
StateNotifierProvider<SelectedMeasurementProvider, Measurement>((ref) {
  final repository = ref.watch(measurementRepositoryProvider);
  return SelectedMeasurementProvider(repository: repository,);
});

class SelectedMeasurementProvider extends StateNotifier<Measurement> {
  final MeasurementRepository repository;


  SelectedMeasurementProvider({
    required this.repository,

  }) : super(Measurement.empty()) {
    getLatestMeasurement(0,[]);
  }

  void onSelectionChanged(Measurement measurement) {
    state = measurement;
  }

  void removeState() {
    state = Measurement.empty();
  }
  // Future<void> getLatestMeasurement(int memberId) async {
  //
  //     Measurement measurement = await repository.getLatestMeasurement(memberId);
  //     state = measurement;
  // }

  void getLatestMeasurement(int memberId, List<Measurement> measurements) {

    List<Measurement> matchingMeasurements = measurements
        .where((element) => element.memberId == memberId)
        .toList();

    if (matchingMeasurements.isNotEmpty) {

      matchingMeasurements.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      Measurement latestMeasurement = matchingMeasurements.first;

      state = latestMeasurement;
    } else {
      state = Measurement.empty();
    }
  }


}

final selectedReferenceMeasurementProvider =
StateNotifierProvider.autoDispose<SelectedReferenceMeasurementProvider, Measurement>((ref) {

  return SelectedReferenceMeasurementProvider();
});

class SelectedReferenceMeasurementProvider extends StateNotifier<Measurement> {

  SelectedReferenceMeasurementProvider() : super(Measurement.empty()) {
    onSelectionChanged(Measurement.empty());
  }

  void onSelectionChanged(Measurement measurement) {
    state = measurement;
  }


}

final measurementScheduleProvider = Provider<List<Meeting>>(

      (ref) {
        List<Meeting> data = [];
        final measurementState = ref.watch(measurementProvider);
        for (var measurementItem in measurementState) {
          DateTime startDate = measurementItem.startDate!;
          DateTime endDate = measurementItem.endDate!;
          String name = '${measurementItem.memberName}님/측정';
          String id = measurementItem.docId;
          // String displayName = measurementItem.displayName;
          Meeting newMeeting = Meeting(name, startDate, endDate, Color(0xFF81B3FF).withOpacity(0.5),id); // Colors.blue는 임의로 지정한 배경색
          data.add(newMeeting);
        }
        DateTime now = DateTime.now();
        // final DateTime today = DateTime.now();
        final DateTime startTime =
        DateTime(now.year, now.month, now.day, now.hour +1, 15, 20);
        final DateTime endTime = startTime.add(const Duration(hours: 2));
        final DateTime startTime2 =
        DateTime(now.year, now.month, now.day +1, now.hour +1, 15, 20);
        final DateTime endTime2 = startTime.add(const Duration(hours: 2));
        data.add(Meeting(
            '해린님/유추', startTime, endTime, Color(0xFFFF8181).withOpacity(0.5),null));
        data.add(Meeting(
            '민지님/PT', startTime2, endTime2, Color(0xFFFF8181).withOpacity(0.5),null));
        return data;
  },
);







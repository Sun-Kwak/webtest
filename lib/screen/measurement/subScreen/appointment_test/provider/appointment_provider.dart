import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntensitySelectionProvider extends ChangeNotifier {
  IntensityState intensityState;

  IntensitySelectionProvider({required this.intensityState});

  double _roundToDecimals(double value, int decimalPlaces) {
    final multiplier = 10.0 * decimalPlaces;
    return (value * multiplier).roundToDouble() / multiplier;
  }

  void setSelectedIntensityValue(double intensityMax, double bpm) {
    intensityState = IntensityState(
      percent40: _roundToDecimals(((intensityMax - bpm) * 0.4 + bpm), 2),
      percent50: _roundToDecimals(((intensityMax - bpm) * 0.5 + bpm), 2),
      percent60: _roundToDecimals(((intensityMax - bpm) * 0.6 + bpm), 2),
      percent70: _roundToDecimals(((intensityMax - bpm) * 0.7 + bpm), 2),
      percent80: _roundToDecimals(((intensityMax - bpm) * 0.8 + bpm), 2),
      percent90: _roundToDecimals(((intensityMax - bpm) * 0.9 + bpm), 2),
      percent100: _roundToDecimals(((intensityMax - bpm) * 1 + bpm), 2),
    );

    notifyListeners(); // 리스너에게 상태 변경을 알림
  }
}


final intensitySelectionProvider =
ChangeNotifierProvider<IntensitySelectionProvider>((ref) {
  return IntensitySelectionProvider(intensityState: IntensityState.empty());
});

// final intensitySelectionProvider = StateNotifierProvider<IntensitySelectionProvider, IntensityState>((ref) {
//
//   return IntensitySelectionProvider();
// });
//
// class IntensitySelectionProvider extends StateNotifier<IntensityState> {
// final intensityMax;
// final bpm;
//   IntensitySelectionProvider(this.intensityMax, this.bpm, {
//   }) : super(IntensityState.empty()) {
// calculateIntensity(intensityMax,bpm );
//   }
//
//   void calculateIntensity(double intensityMax, double bpm) {
//     state = IntensityState(
//     percent40: ((intensityMax-bpm)* 0.4) + bpm,
//       percent50: ((intensityMax-bpm)* 0.5) + bpm,
//       percent60: ((intensityMax-bpm)* 0.6) + bpm,
//       percent70: ((intensityMax-bpm)* 0.7) + bpm,
//       percent80: ((intensityMax-bpm)* 0.8) + bpm,
//       percent90: ((intensityMax-bpm)* 0.9) + bpm,
//       percent100: ((intensityMax-bpm)* 1) + bpm,
//
//     );
// }
// }

class IntensityState {
  double? percent40;
  double? percent50;
  double? percent60;
  double? percent70;
  double? percent80;
  double? percent90;
  double? percent100;

  IntensityState({
    required this.percent40,
    required this.percent50,
    required this.percent60,
    required this.percent70,
    required this.percent80,
    required this.percent90,
    required this.percent100,
  });

  factory IntensityState.empty() =>
      IntensityState(
        percent40: null,
        percent50: null,
        percent60: null,
        percent100: null,
        percent90: null,
        percent80: null,
        percent70: null,
      );

}

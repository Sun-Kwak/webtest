import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntensitySelectionProvider extends ChangeNotifier {
  IntensityState intensityState;

  IntensitySelectionProvider({required this.intensityState});

  double _roundToDecimals(double value, int decimalPlaces) {
    final multiplier = 10.0 * decimalPlaces;
    return (value * multiplier).roundToDouble() / multiplier;
  }

  void setSelectedIntensityValue(double intensityMax, int bpm) {
    intensityState = IntensityState(
      percent40: _roundToDecimals(((intensityMax - bpm) * 0.4 + bpm), 2),
      percent50: _roundToDecimals(((intensityMax - bpm) * 0.5 + bpm), 2),
      percent60: _roundToDecimals(((intensityMax - bpm) * 0.6 + bpm), 2),
      percent70: _roundToDecimals(((intensityMax - bpm) * 0.7 + bpm), 2),
      percent80: _roundToDecimals(((intensityMax - bpm) * 0.8 + bpm), 2),
      percent90: _roundToDecimals(((intensityMax - bpm) * 0.9 + bpm), 2),
      percent100: _roundToDecimals(((intensityMax - bpm) * 1 + bpm), 2),
    );
    notifyListeners();
  }
}


final intensitySelectionProvider =
ChangeNotifierProvider<IntensitySelectionProvider>((ref) {
  return IntensitySelectionProvider(intensityState: IntensityState.empty());
});

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
        percent40: 0,
        percent50: 0,
        percent60: 0,
        percent100: 0,
        percent90: 0,
        percent80: 0,
        percent70: 0,
      );

}

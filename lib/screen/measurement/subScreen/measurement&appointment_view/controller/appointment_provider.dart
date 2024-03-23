import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/data_table/aerobic_power_table.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/HR_percentiles.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/aerobic_power.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/bmi.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/diabetes.dart';

import '../../conditions/data_table/HR_percentiles_table.dart';
import '../../conditions/data_table/bmi_table.dart';
import '../../conditions/data_table/diabetes_table.dart';

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
      intensityMax: intensityMax,
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
  double intensityMax;

  IntensityState({
    required this.intensityMax,
    required this.percent40,
    required this.percent50,
    required this.percent60,
    required this.percent70,
    required this.percent80,
    required this.percent90,
    required this.percent100,
  });

  factory IntensityState.empty() => IntensityState(
        percent40: 0,
        percent50: 0,
        percent60: 0,
        percent100: 0,
        percent90: 0,
        percent80: 0,
        percent70: 0,
        intensityMax: 0,
      );
}

class MeasurementCalculatedState {
  final int age;
  final double bmi;
  final double karMax;
  final double kar90;
  final double tanMax;
  final double tan90;
  final double Vo2Max;
  final String conditionField;
  final int percentage;
  final String healthStatus;
  final double minimumGauge;
  final double diseaseGauge;
  final double poorHealthGauge;
  final double neutralGauge;
  final double goodHealthGauge;
  final double optimalHealthGauge;
  final String bpmLevel;
  final String bmiCategory;
  final String diabetesLevel;

  MeasurementCalculatedState({
    required this.percentage,
    required this.bmi,
    required this.age,
    required this.karMax,
    required this.kar90,
    required this.tanMax,
    required this.tan90,
    required this.Vo2Max,
    required this.conditionField,
    required this.healthStatus,
    required this.minimumGauge,
    required this.diseaseGauge,
    required this.poorHealthGauge,
    required this.neutralGauge,
    required this.goodHealthGauge,
    required this.optimalHealthGauge,
    required this.bpmLevel,
    required this.bmiCategory,
    required this.diabetesLevel,
  });

  MeasurementCalculatedState copyWith({
    int? age,
    double? bmi,
    double? karMax,
    double? kar90,
    double? tanMax,
    double? tan90,
    double? Vo2Max,
    String? conditionField,
    int? percentage,
    String? healthStatus,
    double? minimumGauge,
    double? diseaseGauge,
    double? poorHealthGauge,
    double? neutralGauge,
    double? goodHealthGauge,
    double? optimalHealthGauge,
    String? bpmLevel,
    String? bmiCategory,
    String? diabetesLevel,
  }) {
    return MeasurementCalculatedState(
      bmi: bmi ?? this.bmi,
      age: age ?? this.age,
      karMax: karMax ?? this.karMax,
      kar90: kar90 ?? this.kar90,
      tanMax: tanMax ?? this.tanMax,
      tan90: tan90 ?? this.tan90,
      Vo2Max: Vo2Max ?? this.Vo2Max,
      conditionField: conditionField ?? this.conditionField,
      percentage: percentage ?? this.percentage,
      healthStatus: healthStatus ?? this.healthStatus,
      minimumGauge: minimumGauge ?? this.minimumGauge,
      poorHealthGauge: poorHealthGauge ?? this.poorHealthGauge,
      diseaseGauge: diseaseGauge ?? this.diseaseGauge,
      goodHealthGauge: goodHealthGauge ?? this.goodHealthGauge,
      neutralGauge: neutralGauge ?? this.neutralGauge,
      optimalHealthGauge: optimalHealthGauge ?? this.optimalHealthGauge,
      bpmLevel: bpmLevel ?? this.bpmLevel,
      bmiCategory: bmiCategory ?? this.bmiCategory,
      diabetesLevel: diabetesLevel ?? this.diabetesLevel,
    );
  }

  factory MeasurementCalculatedState.empty() => MeasurementCalculatedState(
        bmi: 0,
        age: 0,
        karMax: 0,
        kar90: 0,
        tanMax: 0,
        tan90: 0,
        Vo2Max: 0,
        conditionField: '',
        percentage: 0,
    healthStatus: '',
    minimumGauge: 0,
    optimalHealthGauge: 0,
    neutralGauge: 0,
    goodHealthGauge: 0,
    diseaseGauge: 0,
    poorHealthGauge: 0,
    bpmLevel: '',
    bmiCategory: '',
    diabetesLevel: '',
      );
}

final measurementCalculatedStateProvider =
    ChangeNotifierProvider.autoDispose<MeasurementCalculatedStateProvider>((ref) {
  return MeasurementCalculatedStateProvider(
      measurementCalculatedState: MeasurementCalculatedState.empty());
});

class MeasurementCalculatedStateProvider extends ChangeNotifier {
  MeasurementCalculatedState measurementCalculatedState;

  MeasurementCalculatedStateProvider(
      {required this.measurementCalculatedState});

  int calculateAge(String birthDay) {
    if (birthDay ==''){
      return 0;
    } else {
    DateTime today = DateTime.now();
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birthDay);

    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;}
  }

  // void setBMI(int userHeight, int userWeight) {
  //   double heightInMeter = userHeight / 100;
  //   double bmi = userWeight / (heightInMeter * heightInMeter);
  //
  //   measurementCalculatedState = measurementCalculatedState.copyWith(
  //     bmi: bmi,
  //   );
  // }

  double calculateBMI(double? userHeight, double? userWeight) {
    double heightInMeter = userHeight == null ? 0 : userHeight / 100;
    double bmi =
        userWeight == null ? 0 : userWeight / (heightInMeter * heightInMeter);

    return bmi = double.parse(bmi.toStringAsFixed(2));
  }

  double calculateVo2Max(String gender, int? exhaustionSecond) {
    if (exhaustionSecond == 0 || exhaustionSecond == null) {
      return 0;
    } else {
      double genderFactor = (gender == "남성")
          ? 2
          : (gender == "여성")
              ? 1
              : 0;
      double vo2Max = 6.7 - (2.82 * genderFactor) + (0.056 * exhaustionSecond);
      return vo2Max = double.parse(vo2Max.toStringAsFixed(2));
    }
  }

  String getBpmLevel(int age, int? bpmData, List<HrPercentilesModel> data){
    int bpm = bpmData ?? 0;
    if (age <19){
      return '';
    } else {
      HrPercentilesModel? matchingModel = data.firstWhere(
            (model) => model.age == age,
        // orElse: () => null,
      );
      if (matchingModel != null) {
        // Determine the field based on the point value
        if (bpm >= matchingModel.p95) {
          return 'p100';
        } else if (bpm >= matchingModel.p90) {
          return 'p95';
        } else if (bpm >= matchingModel.p75) {
          return 'p90';
        } else if (bpm >= matchingModel.p50) {
          return 'p75';
        } else if (bpm >= matchingModel.p25) {
          return 'p50';
        } else if (bpm >= matchingModel.p10) {
          return 'p25';
        } else if (bpm >= matchingModel.p5) {
          return 'p10';
        } else {
          return 'p5';
        }
      } else {
        return 'No Data';
      }
    }
  }

  AerobicPowerModel getEqualCondition(
      List<AerobicPowerModel> data, String fieldName, double point) {
    AerobicPowerModel aerobicPowerModel = AerobicPowerModel(
        healthStatus: '',
        percentage: 0,
        m30: 0,
        m40: 0,
        m50: 0,
        m60: 0,
        m70: 0,
        m80: 0,
        w30: 0,
        w40: 0,
        w50: 0,
        w60: 0,
        w70: 0,
        w80: 0);
    double maxComparisonPoint = 0;

    for (int i = 0; i < data.length; i++) {
      double comparisonPoint = 0;
      switch (fieldName) {
        case 'm30':
          comparisonPoint = data[i].m30;
          break;
        case 'm40':
          comparisonPoint = data[i].m40;
          break;
        case 'm50':
          comparisonPoint = data[i].m50;
          break;
        case 'm60':
          comparisonPoint = data[i].m60;
          break;
        case 'm70':
          comparisonPoint = data[i].m70;
          break;
        case 'm80':
          comparisonPoint = data[i].m80;
          break;
        case 'w30':
          comparisonPoint = data[i].w30;
          break;
        case 'w40':
          comparisonPoint = data[i].w40;
          break;
        case 'w50':
          comparisonPoint = data[i].w50;
          break;
        case 'w60':
          comparisonPoint = data[i].w60;
          break;
        case 'w70':
          comparisonPoint = data[i].w70;
          break;
        case 'w80':
          comparisonPoint = data[i].w80;
          break;
        default:
          // 예외 처리 혹은 기본값 설정
          break;
      }

      if (point >= comparisonPoint && comparisonPoint >= maxComparisonPoint) {
        aerobicPowerModel = data[i];
        maxComparisonPoint = comparisonPoint; // 추가: 새로운 최대 comparisonPoint 저장
      }
    }

    return aerobicPowerModel;
  }

  String getBmiCategory(double? bmiData, List<BmiModel> data) {
    double? bmi = bmiData ?? 0;
    String category = '정의되지 않음'; // 기본적으로 정의되지 않음으로 설정

    for (int i = 0; i < data.length; i++) {
      if (bmi >= data[i].range) {
        category = data[i].category;
      } else {
        break; // bmi가 현재 range보다 작으면 더 이상 비교할 필요 없으므로 반복문 종료
      }
    }

    return category;
  }

  String getDiabetesLevel(int hrr1, List<DiabetesModel> data) {
    String category = '정의되지 않음'; // 기본적으로 정의되지 않음으로 설정

    for (int i = 0; i < data.length; i++) {
      if (hrr1 >= data[i].range) {
        category = data[i].category;
      } else {
        break; // bmi가 현재 range보다 작으면 더 이상 비교할 필요 없으므로 반복문 종료
      }
    }

    return category;
  }



  void gaugeValue(
      List<AerobicPowerModel> data, String fieldName) {
 List<double> boundaryList = [];
    for (int i = 0; i < data.length; i++) {
      double value = 0;
      switch (fieldName) {
        case 'm30':
          value = data[i].m30;
          break;
        case 'm40':
          value = data[i].m40;
          break;
        case 'm50':
          value = data[i].m50;
          break;
        case 'm60':
          value = data[i].m60;
          break;
        case 'm70':
          value = data[i].m70;
          break;
        case 'm80':
          value = data[i].m80;
          break;
        case 'w30':
          value = data[i].w30;
          break;
        case 'w40':
          value = data[i].w40;
          break;
        case 'w50':
          value = data[i].w50;
          break;
        case 'w60':
          value = data[i].w60;
          break;
        case 'w70':
          value = data[i].w70;
          break;
        case 'w80':
          value = data[i].w80;
          break;
        default:
        // 예외 처리 혹은 기본값 설정
          break;
      }
      boundaryList.add(value);
    }
 measurementCalculatedState = measurementCalculatedState.copyWith(
   optimalHealthGauge: boundaryList[0],
   goodHealthGauge: boundaryList[1],
   neutralGauge: boundaryList[2],
   poorHealthGauge: boundaryList[3],
   diseaseGauge: boundaryList[4],
   minimumGauge: boundaryList[5],
 );
  }

  // void setVo2Max(String gender, String exhaustionSecond) {
  //   double genderFactor = (gender == "남성") ? 2 : (gender == "여성") ? 1 : 0;
  //   double vo2Max =
  //       6.7 - (2.82 * genderFactor) + (0.056 * int.parse(exhaustionSecond));
  //   measurementCalculatedState = measurementCalculatedState.copyWith(
  //       Vo2Max: double.parse(vo2Max.toStringAsFixed(2),)
  //   );
  // }

  void selectedMeasurement(
      {required Measurement measurement, required Member member}) {
    int age = calculateAge(member.birthDay);
    double bmi = calculateBMI(measurement.userHeight, measurement.userWeight);
    double Vo2Max =
        calculateVo2Max(member.gender, measurement.exhaustionSeconds);
    double karMax = (220 - age) as double;
    double kar90 = double.parse((karMax * 0.9).toStringAsFixed(2));
    double tanMax = 208 - (0.7 * age);
    double tan90 = double.parse((tanMax * 0.9).toStringAsFixed(2));
    String gender = member.gender == '남성' ? 'm' : 'w';
    String ageRoundDown = (age ~/ 10 * 10).toString();
    String conditionField = gender + ageRoundDown;
    int bpm = measurement.bpm ?? 0;

    int percentage =
        getEqualCondition(aerobicPowerData, conditionField, Vo2Max).percentage;
    String healthStatus =
        getEqualCondition(aerobicPowerData, conditionField, Vo2Max).healthStatus;
    int hrr1 = (measurement.bpmMax?? 0) - (measurement.bpm1m ?? 0);
    gaugeValue(aerobicPowerBoundary,conditionField);
    String bpmLevel = getBpmLevel(age, bpm, hrPercentilesData);
    String bpmCategory = getBmiCategory(bmi, bmiData);
    String diabetesLevel = getDiabetesLevel(hrr1, diabetesData);
    measurementCalculatedState = measurementCalculatedState.copyWith(
      bmi: bmi,
      age: age,
      karMax: karMax,
      kar90: kar90,
      tanMax: tanMax,
      tan90: tan90,
      Vo2Max: Vo2Max,
      conditionField: conditionField,
      percentage: percentage,
      healthStatus: healthStatus,
      bpmLevel: bpmLevel,
      bmiCategory: bpmCategory,
      diabetesLevel: diabetesLevel,
    );

    // notifyListeners();
  }
}

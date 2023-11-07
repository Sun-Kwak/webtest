import 'package:authentication_repository/authentication_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/appointment_provider.dart';

class ReportForm extends ConsumerStatefulWidget {
  const ReportForm({super.key});

  @override
  ConsumerState<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends ConsumerState<ReportForm> {
  @override
  Widget build(BuildContext context) {
    final selectedMemberId = ref.watch(selectedMemberIdProvider);
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        width: 1390,
        height: 800,
        child: selectedMemberId == 0
            ? Center(
                child: Text('선택 된 고객이 없습니다.'),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  leftSide(),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Container(
                      width: 0.5,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  rightSide(),
                ],
              ));
  }

  Widget leftSide() {
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final measurementCalculateState = ref
        .watch(measurementCalculatedStateProvider)
        .measurementCalculatedState;
    final selectedMember = ref.watch(selectedMemberProvider);
    double? userHeight = selectedMeasurementState.userHeight ?? 0;
    double? userWeight = selectedMeasurementState.userWeight ?? 0;
    // double? heightInMeter = userHeight != 0 ? userHeight/ 100 : 0;
    // double? bmi = heightInMeter != 0 ? userWeight / (heightInMeter * heightInMeter) : null;
    String? bMI = measurementCalculateState.bmi.toString();
    String? age = measurementCalculateState.age.toString();
    // DateTime today = DateTime.now();

    // DateTime birthDate = selectedMember.id != 0
    //     ? DateFormat('yyyy-MM-dd').parse(selectedMember.birthDay)
    //     : DateTime.now();
    // int age = today.year - birthDate.year;
    // if (today.month < birthDate.month ||
    //     (today.month == birthDate.month && today.day < birthDate.day)) {
    //   age--;
    // }
    final intensityMax =
        ref.watch(intensitySelectionProvider).intensityState.intensityMax;
    String zone5 =
        '${(intensityMax * 0.9).toStringAsFixed(0)}-${(intensityMax).toStringAsFixed(0)}';
    String zone4 =
        '${(intensityMax * 0.8).toStringAsFixed(0)}-${(intensityMax * 0.9).toStringAsFixed(0)}';
    String zone3 =
        '${(intensityMax * 0.7).toStringAsFixed(0)}-${(intensityMax * 0.8).toStringAsFixed(0)}';
    String zone2 =
        '${(intensityMax * 0.6).toStringAsFixed(0)}-${(intensityMax * 0.7).toStringAsFixed(0)}';
    String zone1 =
        '${(intensityMax * 0.5).toStringAsFixed(0)}-${(intensityMax * 0.6).toStringAsFixed(0)}';

    return SizedBox(
      width: 690,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                '${selectedMember.displayName}님',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(selectedMember.birthDay),
              Text(' ,$age세'),
              const SizedBox(
                width: 10,
              ),
              Text('${userHeight}cm,'),
              Text('${userWeight}kg,'),
              Text(' BMI : $bMI'),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  customContainer(null, '심박수 영역', null, null),
                  customContainer(
                      CUSTOM_RED.withOpacity(0.3), zone5, null, null),
                  customContainer(
                      CUSTOM_YELLOW.withOpacity(0.3), zone4, null, null),
                  customContainer(
                      CUSTOM_GREEN.withOpacity(0.3), zone3, null, null),
                  customContainer(
                      CUSTOM_BLUE.withOpacity(0.3), zone2, null, null),
                  customContainer(
                      CUSTOM_BLACK.withOpacity(0.3), zone1, null, null),
                ],
              ),
              Column(
                children: [
                  customContainer(null, '안정시 심박수 : 89 BPM, 상위 95P', 240, null),
                  Row(
                    children: [
                      Column(
                        children: [
                          customContainer(null, '90-100%', null, null),
                          customContainer(null, '80-90%', null, null),
                          customContainer(null, '70-80%', null, null),
                          customContainer(null, '60-70%', null, null),
                          customContainer(null, '50-60%', null, null),
                        ],
                      ),
                      Column(
                        children: [
                          customContainer(null, '신경계 강화', null, null),
                          customContainer(null, '체력 향상', null, null),
                          customContainer(null, '심폐 능력', null, null),
                          customContainer(null, '지방 연소', null, null),
                          customContainer(null, '회복 운동', null, null),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 65,
              ),
              SizedBox(
                  height: 250,
                  width: 250,
                  child: OverflowBox(
                      maxHeight: 350,
                      maxWidth: 350,
                      child: Lottie.asset('asset/lottie/heartbeat.json',
                          fit: BoxFit.fill))),
            ],
          ),
          Center(
              child: Text(
            '나의 심폐능력 수준은?',
            style: TextStyle(fontSize: 20),
          )),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              noticeText(),
              SizedBox(width: 50),
              Container(
                width: 200,
                height: 200,
                child: SfRadialGauge(
                    enableLoadingAnimation: true,
                    animationDuration: 2000,
                    axes: <RadialAxis>[
                      RadialAxis(
                          minimum: measurementCalculateState.minimumGauge,
                          maximum:
                              measurementCalculateState.optimalHealthGauge == 0
                                  ? 100
                                  : measurementCalculateState
                                      .optimalHealthGauge,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue:
                                  measurementCalculateState.minimumGauge,
                              endValue: measurementCalculateState.diseaseGauge,
                              color: CUSTOM_RED,
                            ),
                            // startWidth: (measurementCalculateState.diseaseGauge - measurementCalculateState.minimumGauge)/2,
                            // endWidth: (measurementCalculateState.diseaseGauge - measurementCalculateState.minimumGauge)/2),
                            GaugeRange(
                              startValue:
                                  measurementCalculateState.diseaseGauge,
                              endValue:
                                  measurementCalculateState.poorHealthGauge,
                              color: CUSTOM_RED.withOpacity(0.3),
                            ),
                            // startWidth: 10,
                            // endWidth: 10),
                            GaugeRange(
                              startValue:
                                  measurementCalculateState.poorHealthGauge,
                              endValue: measurementCalculateState.neutralGauge,
                              color: CUSTOM_YELLOW.withOpacity(0.3),
                            ),
                            // startWidth: 10,
                            // endWidth: 10),
                            GaugeRange(
                              startValue:
                                  measurementCalculateState.neutralGauge,
                              endValue:
                                  measurementCalculateState.goodHealthGauge,
                              color: CUSTOM_BLUE.withOpacity(0.3),
                            ),
                            // startWidth: 10,
                            // endWidth: 10),
                            GaugeRange(
                              startValue:
                                  measurementCalculateState.goodHealthGauge,
                              endValue:
                                  measurementCalculateState.optimalHealthGauge,
                              color: CUSTOM_GREEN.withOpacity(0.3),
                            ),
                            // startWidth: 10,
                            // endWidth: 10),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              enableAnimation: true,
                              value: measurementCalculateState.Vo2Max,
                              // needleColor: CUSTOM_BLACK,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text(
                                        '${measurementCalculateState.Vo2Max}',
                                        style: TextStyle(
                                            color: CUSTOM_BLACK,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))),
                                angle: 90,
                                positionFactor: 0.5)
                          ])
                    ]),
              ),
            ],
          ),
          Center(child: _buildMultipleRanges(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customContainer(CUSTOM_RED, 'Disease', 130, null),
              customContainer(
                  CUSTOM_RED.withOpacity(0.3), 'Poor Health', 130, null),
              customContainer(
                  CUSTOM_YELLOW.withOpacity(0.3), 'Neutral', 130, null),
              customContainer(
                  CUSTOM_BLUE.withOpacity(0.3), 'Good Health', 130, null),
              customContainer(
                  CUSTOM_GREEN.withOpacity(0.3), 'Optimal Health', 130, null),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customContainer(null, '대사질환, 심혈관계\n질환 발병률 증가', 130, 75),
              customContainer(null, '수축기 혈압\n암 발생률 증가', 130, 75),
              customContainer(null, '유지 및 개선 권장', 130, 75),
              customContainer(null, '산소 공급률 증가', 130, 75),
              customContainer(null, '모세혈관 밀도\n미토콘드리아 밀집능력', 130, 75),
            ],
          ),
        ],
      ),
    );
  }

  Widget rightSide() {
    final selectedMeasurementState =
        ref.watch(selectedMeasurementProvider).exhaustionSeconds;
    final selectedReferenceMeasurementState =
        ref.watch(selectedReferenceMeasurementProvider).exhaustionSeconds;
    int referenceSeconds = selectedReferenceMeasurementState ?? 0;
    int exhaustionSecondsDifference = selectedMeasurementState == null
        ? 0
        : (selectedMeasurementState - referenceSeconds);
    String growRate = selectedReferenceMeasurementState == null
        ? '0'
        : (exhaustionSecondsDifference / selectedReferenceMeasurementState)
            .toStringAsFixed(2);
    return SizedBox(
      width: 690,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              barChart(),
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '탈진시간 상승률',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          exhaustionSecondsDifference >= 0
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: exhaustionSecondsDifference >= 0
                              ? CUSTOM_RED
                              : CUSTOM_BLUE,
                        ),
                        Text(
                          '$growRate%',
                          style: TextStyle(
                              color: exhaustionSecondsDifference >= 0
                                  ? CUSTOM_RED
                                  : CUSTOM_BLUE),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          columnChart(),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                '대사증후군 발병률 지표',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          animatedPointRanges(),
          Row(
            children: [
              multipleBarChart(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("매우좋음"),
                  _buildThermometer(context),
                  Text('당뇨 위험률 48% 감소'),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Center(child: noticeText2()),
        ],
      ),
    );
  }

  Widget barChart() {
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final selectedReferenceMeasurementState =
        ref.watch(selectedReferenceMeasurementProvider);
    final List<ExhaustionModel> chartData = [
      ExhaustionModel(
          month: '기준 (${selectedMeasurementState.testDate})',
          seconds: selectedMeasurementState.exhaustionSeconds ?? 0,
          color: CUSTOM_BLUE),
      ExhaustionModel(
          month: '비교 (${selectedReferenceMeasurementState.testDate})',
          seconds: selectedReferenceMeasurementState.exhaustionSeconds ?? 0,
          color: CUSTOM_RED),
    ];
    return SizedBox(
      width: 400,
      height: 150,
      child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          title: ChartTitle(text: '탈진시간', alignment: ChartAlignment.near),
          primaryXAxis: CategoryAxis(),
          series: <CartesianSeries>[
            BarSeries<ExhaustionModel, String>(
                enableTooltip: true,

                // selectionBehavior: SelectionBehavior(),
                dataSource: chartData,
                xValueMapper: (ExhaustionModel data, _) => data.month,
                yValueMapper: (ExhaustionModel data, _) => data.seconds,
                sortingOrder: SortingOrder.descending,
                pointColorMapper: (ExhaustionModel data, _) => data.color,
                name: '탈진시간'
                // Sorting based on the specified field
                // sortFieldValueMapper: (ExhaustionModel data, _) => data.x
                )
          ]),
    );
  }

  Widget columnChart() {
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final selectedReferenceMeasurementState =
        ref.watch(selectedReferenceMeasurementProvider);
    int current0Stage = selectedMeasurementState.stage0 ?? 0;
    int current1Stage = selectedMeasurementState.stage1 ?? 0;
    int current2Stage = selectedMeasurementState.stage2 ?? 0;
    int current3Stage = selectedMeasurementState.stage3 ?? 0;
    int current4Stage = selectedMeasurementState.stage4 ?? 0;
    int current5Stage = selectedMeasurementState.stage5 ?? 0;
    int current6Stage = selectedMeasurementState.stage6 ?? 0;
    int current7Stage = selectedMeasurementState.stage7 ?? 0;
    int previous0Stage = selectedReferenceMeasurementState.stage0 ?? 0;
    int previous1Stage = selectedReferenceMeasurementState.stage1 ?? 0;
    int previous2Stage = selectedReferenceMeasurementState.stage2 ?? 0;
    int previous3Stage = selectedReferenceMeasurementState.stage3 ?? 0;
    int previous4Stage = selectedReferenceMeasurementState.stage4 ?? 0;
    int previous5Stage = selectedReferenceMeasurementState.stage5 ?? 0;
    int previous6Stage = selectedReferenceMeasurementState.stage6 ?? 0;
    int previous7Stage = selectedReferenceMeasurementState.stage7 ?? 0;
    final List<StageModel> list = [
      StageModel(
          stage: '0Stage',
          previousValue: previous0Stage,
          currentValue: current0Stage),
      StageModel(
          stage: '1Stage',
          previousValue: previous1Stage,
          currentValue: current1Stage),
      StageModel(
          stage: '2Stage',
          previousValue: previous2Stage,
          currentValue: current2Stage),
      StageModel(
          stage: '3Stage',
          previousValue: previous3Stage,
          currentValue: current3Stage),
      StageModel(
          stage: '4Stage',
          previousValue: previous4Stage,
          currentValue: current4Stage),
      StageModel(
          stage: '5Stage',
          previousValue: previous5Stage,
          currentValue: current5Stage),
      StageModel(
          stage: '6Stage',
          previousValue: previous6Stage,
          currentValue: current6Stage),
      StageModel(
          stage: '7Stage',
          previousValue: previous7Stage,
          currentValue: current7Stage),
    ];
    final List<StageModel> chartData = [];
    for (int i = 0; i <= 7; i++) {
      int previousValue = list[i].previousValue;
      int currentValue = list[i].currentValue;
      String stage = list[i].stage;
      if (previousValue != 0 || currentValue != 0) {
        chartData.add(StageModel(
            stage: stage,
            previousValue: previousValue,
            currentValue: currentValue));
      }
    }

    return SizedBox(
      width: 690,
      height: 200,
      child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          palette: <Color>[
            Colors.teal,
            Colors.orange,
          ],
          legend: Legend(
              isVisible: true,
              alignment: ChartAlignment.center,
              position: LegendPosition.bottom),
          series: <CartesianSeries>[
            ColumnSeries<StageModel, String>(
              name: '비교 ${selectedReferenceMeasurementState.testDate}',
              dataSource: chartData,
              xValueMapper: (StageModel data, _) => data.stage,
              yValueMapper: (StageModel data, _) => data.previousValue,
            ),
            ColumnSeries<StageModel, String>(
              name: '기준 ${selectedMeasurementState.testDate}',
              dataSource: chartData,
              xValueMapper: (StageModel data, _) => data.stage,
              yValueMapper: (StageModel data, _) => data.currentValue,
            ),
          ]),
    );
  }

  Widget multipleBarChart() {
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    final selectedReferenceMeasurementState =
        ref.watch(selectedReferenceMeasurementProvider);
    int currentMax = selectedMeasurementState.bpmMax ?? 0;
    int currentBpm1m = selectedMeasurementState.bpm1m ?? 0;
    int currentBpm2m = selectedMeasurementState.bpm2m ?? 0;
    int currentBpm3m = selectedMeasurementState.bpm3m ?? 0;
    int previousMax = selectedReferenceMeasurementState.bpmMax ?? 0;
    int previousBpm1m = selectedReferenceMeasurementState.bpm1m ?? 0;
    int previousBpm2m = selectedReferenceMeasurementState.bpm2m ?? 0;
    int previousBpm3m = selectedReferenceMeasurementState.bpm3m ?? 0;

    final List<HrrModel> chartData = [
      HrrModel(
          hrr: 'HRR1',
          previousValue: previousMax - previousBpm1m,
          currentValue: currentMax - currentBpm1m),
      HrrModel(
          hrr: 'HRR2',
          previousValue: previousMax - previousBpm2m,
          currentValue: currentMax - currentBpm2m),
      HrrModel(
          hrr: 'HRR3',
          previousValue: previousMax - previousBpm3m,
          currentValue: currentMax - currentBpm3m),
      HrrModel(
          hrr: '최고심박수', previousValue: previousMax, currentValue: currentMax),
    ];
    return SizedBox(
      width: 490,
      height: 200,
      child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: Legend(isVisible: true),
          primaryXAxis: CategoryAxis(),
          palette: <Color>[
            Colors.teal,
            Colors.orange,
          ],
          series: <CartesianSeries>[
            BarSeries<HrrModel, String>(
              name: '기준 ${selectedMeasurementState.testDate}',
              dataSource: chartData,
              xValueMapper: (HrrModel data, _) => data.hrr,
              yValueMapper: (HrrModel data, _) => data.previousValue,
            ),
            BarSeries<HrrModel, String>(
              name: '비교 ${selectedReferenceMeasurementState.testDate}',
              dataSource: chartData,
              xValueMapper: (HrrModel data, _) => data.hrr,
              yValueMapper: (HrrModel data, _) => data.currentValue,
            ),
          ]),
    );
  }

  Widget customContainer(
      Color? color, String text, double? width, double? height) {
    return Container(
      width: width ?? 120,
      height: height ?? 25,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        border: Border.all(width: 0.5, color: CUSTOM_BLACK.withOpacity(0.3)),
      ),
      child: Center(child: Text(text)),
    );
  }

  Widget noticeText() {
    // final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    // final selectedMemberState = ref.watch(selectedMemberProvider);
    final measurementCalculatedState = ref
        .watch(measurementCalculatedStateProvider)
        .measurementCalculatedState;
    // double genderFactor = (selectedMemberState.gender == "남성") ? 2 : (selectedMemberState.gender == "여성") ? 1 : 0;
    // int? exhaustionSeconds = selectedMeasurementState.exhaustionSeconds ?? 0;
    double vo2Max = measurementCalculatedState.Vo2Max;
    int percentage = measurementCalculatedState.percentage;
    String healthStatus = measurementCalculatedState.healthStatus;
    String grade = percentage > 50 ? '상위' : '하위';
    int convertedPercentage = percentage > 50 ? 100 - percentage : percentage;

    // String bmi = measurementCalculatedState.bmi.toString();
    // String tanMax = measurementCalculatedState.tanMax.toString();

    return Container(
      width: 385,
      child: Column(
        children: [
          RichText(
              text: TextSpan(children: [
            const TextSpan(
              text: '테스트님의 최대산소섭취량은 ',
              style: TextStyle(fontFamily: 'SebangGothic'),
            ),
            TextSpan(
              text: '$vo2Max ml/kg/min ',
              style: const TextStyle(
                  fontFamily: 'SebangGothic', fontWeight: FontWeight.bold),
            ),
            const TextSpan(
                text: '이며 같은 나이대에서 ',
                style: TextStyle(fontFamily: 'SebangGothic')),
            TextSpan(
              text: '$grade $convertedPercentage%',
              style: TextStyle(
                  color: grade == '상위' ? CUSTOM_BLUE : CUSTOM_RED,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SebangGothic'),
            ),
            const TextSpan(
              text:
                  '에 해당됩니다. 유산소성 운동능력의 중요한 지표로써 신체가 소모한 산소량을 의미하며 더 많은 산소를 들이 마실수록 몸에서 더 많은 에너지를 사용할 수 있습니다.',
              style: TextStyle(fontFamily: 'SebangGothic'),
            ),
          ])),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '건강상태 : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                color: getColorForHealthStatus(healthStatus),
                child: Text(healthStatus,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget noticeText2() {
    return Container(
      width: 650,
      child: Text(
        '심박수 회복은 당뇨병, 대사증후군, 심혈관 사망 위험 증가와 관련이 있습니다. 일반적으로 운동 중단 후 부교감 신경 활성 증가와 교감 신경 활성의 감소로 심박수는 빠르게 감소합니다. 그러나 자율신경계의 기능장애는 심박수 회복을 지연합니다. HRR1 자연 회복은 인슐린 분비 기능장애와 당불내증을 반영합니다. 이러한 기능장애는 결국 대사증후군으로 이어질 수 있습니다.',
        softWrap: true,
        style: TextStyle(
          height: 2, // 줄 간격을 조절합니다. 1.5는 기본 높이의 1.5배입니다.
        ),
      ),
    );
  }

  Widget animatedPointRanges() {
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    int bpmMax = selectedMeasurementState.bpmMax ?? 0;
    int bpm3m = selectedMeasurementState.bpm3m ?? 0;
    int indicator = bpmMax - bpm3m;
    return SfLinearGauge(
      maximum: 90,
      interval: 45,
      // showLabels: true,
      barPointers: [
        LinearBarPointer(
          value: indicator.toDouble(),
          color: CUSTOM_BLUE,
        ),
        LinearBarPointer(
          value: 45,
          color: CUSTOM_RED,
        ),
      ],
      markerPointers: [
        LinearWidgetPointer(
            position: LinearElementPosition.outside,
            value: indicator.toDouble(),
            animationDuration: 2000,
            animationType: LinearAnimationType.bounceOut,
            child: Icon(
              indicator >= 45 ? Icons.thumb_up_alt : Icons.thumb_down_alt,
              color: indicator >= 45 ? CUSTOM_BLUE : CUSTOM_RED,
            ))
      ],
    );
  }

  Widget _buildMultipleRanges(BuildContext context) {
    final measurementCalculateState = ref
        .watch(measurementCalculatedStateProvider)
        .measurementCalculatedState;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 7,
        ),
        SizedBox(
            height: 120,
            width: 665,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: CUSTOM_RED.withOpacity(0.3),
                      height: 15,
                      width: 665 / 3,
                      child: Text('Pre-mature Death'),
                    ),
                    Container(
                      color: CUSTOM_YELLOW.withOpacity(0.3),
                      height: 15,
                      width: 665 / 3,
                      child: Center(child: Text('Comfort Zone')),
                    ),
                    Container(
                      color: CUSTOM_GREEN.withOpacity(0.3),
                      height: 15,
                      width: 665 / 3,
                      child: Text(
                        'High-level Wellness',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(measurementCalculateState.diseaseGauge.toString()),
                    Text(measurementCalculateState.poorHealthGauge.toString()),
                    Text(measurementCalculateState.neutralGauge.toString()),
                    Text(measurementCalculateState.goodHealthGauge.toString()),
                    Text(measurementCalculateState.optimalHealthGauge
                        .toString()),
                  ],
                )
              ],
            )
            // SfLinearGauge(
            //   // animateAxis: true,
            //   // animateRange: true,
            //   // animationDuration: 3000,
            //   orientation: LinearGaugeOrientation.horizontal,
            //   interval: measurementCalculateState.optimalHealthGauge == 0 ? 10 : (measurementCalculateState.optimalHealthGauge - measurementCalculateState.diseaseGauge)/5,
            //   minimum: measurementCalculateState.diseaseGauge == 0 ? 0 : measurementCalculateState.diseaseGauge ,
            //   maximum: measurementCalculateState.optimalHealthGauge == 0 ? 100 : measurementCalculateState.optimalHealthGauge,
            //   ranges: <LinearGaugeRange>[
            //     LinearGaugeRange(
            //         startValue: measurementCalculateState.diseaseGauge,
            //         endValue: measurementCalculateState.poorHealthGauge,
            //         // midWidth: 40,
            //         // endWidth: 40,
            //         child: Container(
            //           color: CUSTOM_RED,
            //         )),
            //     LinearGaugeRange(
            //         startValue: measurementCalculateState.poorHealthGauge,
            //         endValue: measurementCalculateState.neutralGauge,
            //         // startWidth: 40,
            //         // midWidth: 40,
            //         // endWidth: 40,
            //         child: Container(color: CUSTOM_YELLOW)),
            //     LinearGaugeRange(
            //         startValue: measurementCalculateState.neutralGauge,
            //         endValue: measurementCalculateState.goodHealthGauge,
            //         // startWidth: 40,
            //         // midWidth: 40,
            //         // endWidth: 40,
            //         child: Container(color: CUSTOM_GREEN)),
            //     // LinearGaugeRange(
            //     //     startValue: measurementCalculateState.diseaseGauge,
            //     //     endValue: (measurementCalculateState.optimalHealthGauge -
            //     //             measurementCalculateState.diseaseGauge) /
            //     //         5 *
            //     //         1,
            //     //     // startWidth: 40,
            //     //     // endWidth: 40,
            //     //     color: Colors.transparent,
            //     //     child: const Center(
            //     //         child: Text(
            //     //       'Pre-mature Death',
            //     //       style: TextStyle(
            //     //           fontWeight: FontWeight.w500,
            //     //           color: Color(0xff191A1B)),
            //     //     ))),
            //     // LinearGaugeRange(
            //     //   startValue: (measurementCalculateState.optimalHealthGauge -
            //     //           measurementCalculateState.diseaseGauge) /
            //     //       5 *
            //     //       1,
            //     //   endValue: measurementCalculateState.optimalHealthGauge -
            //     //       ((measurementCalculateState.optimalHealthGauge -
            //     //               measurementCalculateState.diseaseGauge) /
            //     //           5 *
            //     //           1),
            //     //   // startWidth: 40,
            //     //   // endWidth: 40,
            //     //   color: Colors.transparent,
            //     //   child: const SizedBox(
            //     //       height: 20,
            //     //       child: Center(
            //     //           child: Text(
            //     //         'Comfort Zone',
            //     //         style: TextStyle(
            //     //             fontWeight: FontWeight.w500,
            //     //             color: Color(0xff191A1B)),
            //     //       ))),
            //     // ),
            //     // LinearGaugeRange(
            //     //   startValue: measurementCalculateState.optimalHealthGauge -
            //     //       ((measurementCalculateState.optimalHealthGauge -
            //     //               measurementCalculateState.diseaseGauge) /
            //     //           5 *
            //     //           1),
            //     //   endValue: measurementCalculateState.optimalHealthGauge,
            //     //   // startWidth: 40,
            //     //   // endWidth: 40,
            //     //   color: Colors.transparent,
            //     //   child: const SizedBox(
            //     //       height: 20,
            //     //       child: Center(
            //     //           child: Text(
            //     //         'High-level Wellness',
            //     //         style: TextStyle(
            //     //             fontWeight: FontWeight.w500,
            //     //             color: Color(0xff191A1B)),
            //     //       ))),
            //     // )
            //   ],
            // ),
            ),
      ],
    );
  }

  Widget _buildThermometer(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 150,
            width: 180,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /// Linear gauge to display celsius scale.
                        SfLinearGauge(
                            minimum: 0,
                            maximum: 120,
                            interval: 40,
                            minorTicksPerInterval: 0,
                            axisTrackExtent: 23,
                            axisTrackStyle: LinearAxisTrackStyle(
                                color: CUSTOM_BLACK,
                                thickness: 12,
                                borderWidth: 1,
                                edgeStyle: LinearEdgeStyle.bothCurve),
                            tickPosition: LinearElementPosition.outside,
                            labelPosition: LinearLabelPosition.outside,
                            orientation: LinearGaugeOrientation.vertical,
                            markerPointers: <LinearMarkerPointer>[
                              LinearWidgetPointer(
                                  markerAlignment: LinearMarkerAlignment.end,
                                  value: 120,
                                  enableAnimation: false,
                                  position: LinearElementPosition.outside,
                                  offset: 8,
                                  child: SizedBox(
                                    height: 30,
                                    child: Text(
                                      '%',
                                    ),
                                  )),

                              LinearShapePointer(
                                value: -20,
                                markerAlignment: LinearMarkerAlignment.start,
                                shapeType: LinearShapePointerType.circle,
                                borderWidth: 3,
                                borderColor: CUSTOM_BLACK,
                                color: CUSTOM_BLUE,
                                position: LinearElementPosition.cross,
                                width: 30,
                                height: 30,
                              ),

                              LinearWidgetPointer(
                                value: -20,
                                markerAlignment: LinearMarkerAlignment.start,
                                child: Container(
                                  width: 10,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 2.0, color: CUSTOM_BLACK),
                                        right: BorderSide(
                                            width: 2.0, color: CUSTOM_BLACK),
                                      ),
                                      color: CUSTOM_BLUE),
                                ),
                              ),

                              LinearShapePointer(
                                value: 60,
                                width: 10,
                                height: 10,
                                enableAnimation: true,
                                color: CUSTOM_RED,
                                position: LinearElementPosition.outside,
                                onChanged: (dynamic value) {},
                              ) // 게이지바늘
                            ],
                            barPointers: <LinearBarPointer>[
                              LinearBarPointer(
                                value: 60,
                                enableAnimation: true,
                                thickness: 6,
                                edgeStyle: LinearEdgeStyle.endCurve,
                                color: CUSTOM_BLUE,
                              ) // 게이지
                            ]),
                      ],
                    )))));
  }
}

enum HealthStatus {
  OptimalHealth,
  GoodHealth,
  Neutral,
  PoorHealth,
  Disease,
}

Map<HealthStatus, Color> healthStatusColors = {
  HealthStatus.OptimalHealth: CUSTOM_GREEN.withOpacity(0.3),
  HealthStatus.GoodHealth: CUSTOM_BLUE.withOpacity(0.3),
  HealthStatus.Neutral: CUSTOM_YELLOW.withOpacity(0.3),
  HealthStatus.PoorHealth: CUSTOM_RED.withOpacity(0.3),
  HealthStatus.Disease: CUSTOM_RED,
};

Color getColorForHealthStatus(String status) {
  switch (status) {
    case 'Optimal Health':
      return healthStatusColors[HealthStatus.OptimalHealth]!;
    case 'Good Health':
      return healthStatusColors[HealthStatus.GoodHealth]!;
    case 'Neutral':
      return healthStatusColors[HealthStatus.Neutral]!;
    case 'Poor Health':
      return healthStatusColors[HealthStatus.PoorHealth]!;
    case 'Disease':
      return healthStatusColors[HealthStatus.Disease]!;
    default:
      // 기본값으로 회색 반환 또는 예외 처리
      return healthStatusColors[HealthStatus.Neutral]!;
  }
}

import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:web_test2/common/const/colors.dart';

class ReportForm extends ConsumerStatefulWidget {
  const ReportForm({super.key});

  @override
  ConsumerState<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends ConsumerState<ReportForm> {
  @override
  Widget build(BuildContext context) {
    final selectedMemberIdController =
        ref.watch(selectedMemberIdProvider.notifier);
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
                child: Text('선택 된 측정데이터가 없습니다.'),
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
    DateTime today = DateTime.now();
    final selectedMember = ref.watch(selectedMemberProvider);
    DateTime birthDate = selectedMember.id != 0
        ? DateFormat('yyyy-MM-dd').parse(selectedMember.birthDay)
        : DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
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
              Text(' ,${age}세'),
              const SizedBox(
                width: 10,
              ),
              const Text('키 변수cm,'),
              const Text(' 몸무게 변수kg : ,'),
              const Text(' BMI 변수'),
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
                      CUSTOM_RED.withOpacity(0.3), '145-161.1', null, null),
                  customContainer(
                      CUSTOM_YELLOW.withOpacity(0.3), '129-144', null, null),
                  customContainer(
                      CUSTOM_GREEN.withOpacity(0.3), '113-128', null, null),
                  customContainer(
                      CUSTOM_BLUE.withOpacity(0.3), '97-112', null, null),
                  customContainer(
                      CUSTOM_BLACK.withOpacity(0.3), '81-96', null, null),
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
                width: 45,
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
          const Center(
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
                      RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0,
                            endValue: 50,
                            color: CUSTOM_GREEN,
                            startWidth: 10,
                            endWidth: 10),
                        GaugeRange(
                            startValue: 50,
                            endValue: 100,
                            color: CUSTOM_YELLOW,
                            startWidth: 10,
                            endWidth: 10),
                        GaugeRange(
                            startValue: 100,
                            endValue: 150,
                            color: CUSTOM_RED,
                            startWidth: 10,
                            endWidth: 10)
                      ], pointers: <GaugePointer>[
                        NeedlePointer(
                          value: 90,
                        )
                      ], annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                                child: Text('90.0',
                                    style: TextStyle(
                                        fontSize: 25,
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
    return SizedBox(
      width: 690,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                barChart(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                            Icons.arrow_drop_up,
                            color: CUSTOM_RED,
                          ),
                          Text(
                            '20.69%',
                            style: TextStyle(color: CUSTOM_RED),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            columnChart(),
            Center(child: Text('대사증후군 발병률 지표',style: TextStyle(fontSize: 16),)),
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
            SizedBox(height: 30,),
            Center(child: noticeText2()),
          ],
        ),
      ),
    );
  }

  Widget barChart() {
    final List<ExhaustionModel> chartData = [
      ExhaustionModel(
          month: '최근 (2023-04-03)', seconds: 700, color: CUSTOM_BLUE),
      ExhaustionModel(
          month: '이전 (2023-03-31)', seconds: 500, color: CUSTOM_RED),
    ];
    return SizedBox(
      width: 400,
      height: 150,
      child: SfCartesianChart(
          title: ChartTitle(text: '탈진시간', alignment: ChartAlignment.near),
          primaryXAxis: CategoryAxis(),
          series: <CartesianSeries>[
            BarSeries<ExhaustionModel, String>(
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
    final List<StageModel> chartData = [
      StageModel(stage: '0Stage', previousValue: 100, currentValue: 100),
      StageModel(stage: '0.5Stage', previousValue: 200, currentValue: 120),
      StageModel(stage: '1Stage', previousValue: 300, currentValue: 130),
      StageModel(stage: '2Stage', previousValue: 400, currentValue: 140),
      StageModel(stage: '3Stage', previousValue: 500, currentValue: 150),
      StageModel(stage: '4Stage', previousValue: 600, currentValue: 0),
    ];
    return SizedBox(
      width: 690,
      height: 200,
      child: SfCartesianChart(primaryXAxis: CategoryAxis(), palette: <Color>[
        Colors.teal,
        Colors.orange,
      ], series: <CartesianSeries>[
        ColumnSeries<StageModel, String>(
          dataSource: chartData,
          xValueMapper: (StageModel data, _) => data.stage,
          yValueMapper: (StageModel data, _) => data.previousValue,
        ),
        ColumnSeries<StageModel, String>(
          dataSource: chartData,
          xValueMapper: (StageModel data, _) => data.stage,
          yValueMapper: (StageModel data, _) => data.currentValue,
        ),
      ]),
    );
  }

  Widget multipleBarChart() {
    final List<HrrModel> chartData = [
      HrrModel(hrr: 'HRR1', previousValue: 30, currentValue: 30),
      HrrModel(hrr: 'HRR2', previousValue: 40, currentValue: 30),
      HrrModel(hrr: 'HRR3', previousValue: 70, currentValue: 80),
      HrrModel(hrr: '최고심박수', previousValue: 180, currentValue: 180),
    ];
    return SizedBox(
      width: 490,
      height: 200,
      child: SfCartesianChart(primaryXAxis: CategoryAxis(), palette: <Color>[
        Colors.teal,
        Colors.orange,
      ], series: <CartesianSeries>[
        BarSeries<HrrModel, String>(
          dataSource: chartData,
          xValueMapper: (HrrModel data, _) => data.hrr,
          yValueMapper: (HrrModel data, _) => data.previousValue,
        ),
        BarSeries<HrrModel, String>(
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
    return Container(
      width: 385,
      child: Column(
        children: [
          Text(
            '테스트님의 최대산소섭취량은 43.08 ml/kg/min 이며 같은 나이대에서 상위 1%에 해당됩니다. 유산소성 운동능력의 중요한 지표로써 신체가 소모한 산소량을 의미하며 더 많은 산소를 들이 마실수록 몸에서 더 많은 에너지를 사용할 수 있습니다.',
            softWrap: true,
            style: TextStyle(
              height: 3, // 줄 간격을 조절합니다. 1.5는 기본 높이의 1.5배입니다.
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('건강상태 : '),
              Container(
                color: CUSTOM_GREEN,
                child: Text('Optimal Health'),
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
    return SfLinearGauge(
      maximum: 90,
      interval: 45,
      barPointers: [
        LinearBarPointer(value: 60,color: CUSTOM_BLUE,),
        LinearBarPointer(value: 45,color: CUSTOM_RED,),
      ],
      markerPointers: [
        LinearWidgetPointer(
          position: LinearElementPosition.outside,
            value: 60,
            animationDuration: 2000,
            animationType: LinearAnimationType.bounceOut,
            child: Icon(
              Icons.thumb_up_alt,
              color: CUSTOM_BLUE,
            ))
      ],
    );
  }

  Widget _buildMultipleRanges(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 7,
        ),
        SizedBox(
            height: 120,
            width: 636,
            child: SfLinearGauge(
              // animateAxis: true,
              // animateRange: true,
              // animationDuration: 3000,
              orientation: LinearGaugeOrientation.horizontal,
              ranges: <LinearGaugeRange>[
                LinearGaugeRange(
                    endValue: 30,
                    startWidth: 40,
                    midWidth: 40,
                    endWidth: 40,
                    child: Container(
                      color: CUSTOM_RED,
                    )),
                LinearGaugeRange(
                    startValue: 30.0,
                    endValue: 65,
                    startWidth: 40,
                    midWidth: 40,
                    endWidth: 40,
                    child: Container(color: CUSTOM_YELLOW)),
                LinearGaugeRange(
                    startValue: 65.0,
                    startWidth: 40,
                    midWidth: 40,
                    endWidth: 40,
                    child: Container(color: CUSTOM_GREEN)),
                LinearGaugeRange(
                    endValue: 30,
                    startWidth: 40,
                    endWidth: 40,
                    color: Colors.transparent,
                    child: const Center(
                        child: Text(
                      'Bad',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff191A1B)),
                    ))),
                LinearGaugeRange(
                  startValue: 30,
                  endValue: 65,
                  startWidth: 40,
                  endWidth: 40,
                  color: Colors.transparent,
                  child: const SizedBox(
                      height: 20,
                      child: Center(
                          child: Text(
                        'Good',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff191A1B)),
                      ))),
                ),
                LinearGaugeRange(
                  startValue: 65,
                  startWidth: 40,
                  endWidth: 40,
                  color: Colors.transparent,
                  child: const SizedBox(
                      height: 20,
                      child: Center(
                          child: Text(
                        'Excellent',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff191A1B)),
                      ))),
                )
              ],
            )),
      ],
    );
  }
  Widget _buildThermometer(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Brightness brightness = Theme.of(context).brightness;

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
                              // LinearShapePointer(
                              //   value: -20,
                              //   markerAlignment: LinearMarkerAlignment.start,
                              //   shapeType: LinearShapePointerType.circle,
                              //   // borderWidth: 0.5,
                              //   // borderColor:
                              //   // ,
                              //   color: CUSTOM_BLUE,
                              //   position: LinearElementPosition.cross,
                              //   width: 30,
                              //   height: 30,
                              // ),
                              LinearWidgetPointer(
                                  value: -20,
                                  markerAlignment: LinearMarkerAlignment.start,
                                  child: Container(
                                    width: 10,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 2.0,
                                            color: CUSTOM_BLACK),
                                        right: BorderSide(
                                            width: 2.0,
                                            color: CUSTOM_BLACK),
                                      ),
                                      color: CUSTOM_BLUE),
                                    ),
                                  ),
                              // LinearWidgetPointer(
                              //     value: 60,
                              //     enableAnimation: false,
                              //     position: LinearElementPosition.outside,
                              //     child: Container(
                              //         width: 16,
                              //         height: 12,
                              //         transform:
                              //         Matrix4.translationValues(4, 0, 0.0),
                              //         child: Image.asset(
                              //           'images/triangle_pointer.png',
                              //           color: CUSTOM_BLUE,
                              //         ))),
                              LinearShapePointer(
                                value: 60,
                                width: 10,
                                height: 10,
                                enableAnimation: true,
                                color: CUSTOM_RED,
                                position: LinearElementPosition.outside,
                                onChanged: (dynamic value) {
                                },
                              )// 게이지바늘
                            ],
                            barPointers: <LinearBarPointer>[
                              LinearBarPointer(
                                value: 60,
                                enableAnimation: true,
                                thickness: 6,
                                edgeStyle: LinearEdgeStyle.endCurve,
                                color: CUSTOM_BLUE,
                              )// 게이지
                            ]),

                        /// Linear gauge to display Fahrenheit  scale.
                        // Container(
                        //     transform: Matrix4.translationValues(-6, 0, 0.0),
                        //     child: SfLinearGauge(
                        //       maximum: 120,
                        //       showAxisTrack: false,
                        //       interval: 40,
                        //       minorTicksPerInterval: 0,
                        //       axisTrackExtent: 24,
                        //       axisTrackStyle:
                        //       const LinearAxisTrackStyle(thickness: 0),
                        //       orientation: LinearGaugeOrientation.vertical,
                        //           // barPointers: <LinearBarPointer>[
                        //           //   LinearBarPointer(
                        //           //     value: 60,
                        //           //     enableAnimation: false,
                        //           //     thickness: 6,
                        //           //     edgeStyle: LinearEdgeStyle.endCurve,
                        //           //     color: CUSTOM_BLUE,
                        //           //   ),
                        //           //
                        //           // ],
                        //       markerPointers: <LinearMarkerPointer>[
                        //
                        //         //       LinearShapePointer(
                        //         //         value: 60,
                        //         //         width: 10,
                        //         //         height: 10,
                        //         //         enableAnimation: false,
                        //         //         color: Colors.transparent,
                        //         //         position: LinearElementPosition.cross,
                        //         //         onChanged: (dynamic value) {
                        //         //         },
                        //         //       )
                        //         //     ],
                        //         //     barPointers: <LinearBarPointer>[
                        //         //       LinearBarPointer(
                        //         //         value: 60,
                        //         //         enableAnimation: false,
                        //         //         thickness: 6,
                        //         //         edgeStyle: LinearEdgeStyle.endCurve,
                        //         //         color: CUSTOM_BLUE,
                        //         //       )
                        //               // LinearWidgetPointer(
                        //               //     value: 60,
                        //               //     enableAnimation: false,
                        //               //     position: LinearElementPosition.outside,
                        //               //     child: Container(
                        //               //         width: 16,
                        //               //         height: 12,
                        //               //         // transform:
                        //               //         // Matrix4.translationValues(4, 0, 0.0),
                        //               //         child: Image.asset(
                        //               //           'images/triangle_pointer.png',
                        //               //           color: CUSTOM_BLUE,
                        //               //         ))),
                        //         LinearWidgetPointer(
                        //             markerAlignment: LinearMarkerAlignment.end,
                        //             value: 120,
                        //             position: LinearElementPosition.inside,
                        //             offset: 6,
                        //             enableAnimation: false,
                        //             child: SizedBox(
                        //               height: 30,
                        //               child: Text(
                        //                 '%',
                        //               ),
                        //             )),
                        //       ],
                        //     ))
                      ],
                    )))));
  }
}

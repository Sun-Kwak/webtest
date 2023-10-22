import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_test2/common/const/colors.dart';

class MemberSummaryCard extends ConsumerWidget {

  const MemberSummaryCard(
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersCount = ref.watch(membersCountProvider);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: TABLE_HEADER_COLOR,
      ),
      width: 230,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              '지점가입자',
              style: TextStyle(fontSize: 11),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
                width: 50,
                height: 40,
                child: Center(
                    child: Text(
                      membersCount.totalCount.toString(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey),
                ))),
            const Divider(),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(membersCount.newCount.toString()),
                      SizedBox(
                        height: 3,
                      ),
                      Text('신규',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w100,
                              color: BODY_TEXT_COLOR)),
                    ],
                  ),
                  Column(
                    children: [
                      Text(membersCount.contractCount.toString()),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '계약',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w100,
                            color: BODY_TEXT_COLOR),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        membersCount.expiredCount.toString(),
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '만료',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w100,
                            color: Colors.redAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VOCSummaryCard extends StatelessWidget {
  const VOCSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: TABLE_HEADER_COLOR,
      ),
      width: 230,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              '문의건수',
              style: TextStyle(fontSize: 11),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
                width: 50,
                height: 40,
                child: const Center(
                    child: Text(
                  '12',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey),
                ))),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('9'),
                      SizedBox(
                        height: 3,
                      ),
                      Text('진행',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w100,
                              color: BODY_TEXT_COLOR)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('1'),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '완료',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w100,
                            color: BODY_TEXT_COLOR),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '2',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '미결',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w100,
                            color: Colors.redAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthlyMemberChart extends ConsumerWidget {
  const MonthlyMemberChart({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final monthlyCount = ref.watch(monthlyCountProvider);
    final List<Color> startColor = <Color>[];
    startColor.add(Colors.amber[50]!);
    startColor.add(Colors.amber[100]!);
    startColor.add(Colors.amber);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);
    int maxCount = monthlyCount.isNotEmpty
        ? monthlyCount.map((monthlyMember) => monthlyMember.count).reduce((a, b) => a > b ? a : b)
        : 0;
    int minMonth = monthlyCount.isNotEmpty
        ? monthlyCount.map((monthlyMember) => monthlyMember.month).reduce((a, b) => a < b ? a : b)
        : 0;

    final LinearGradient gradientColors = LinearGradient(colors: startColor, stops: stops);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: TABLE_HEADER_COLOR,
      ),
      width: 510,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          // legend: Legend(isVisible: true),
          series: <ChartSeries>[
            AreaSeries<MonthlyMemberModel, int>(
              selectionBehavior: SelectionBehavior(
              ),
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              gradient: gradientColors,

                // name: '월별',
                // dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: monthlyCount,
                xValueMapper: (MonthlyMemberModel monthlyMemberModel, _) =>
                    monthlyMemberModel.month,
                yValueMapper: (MonthlyMemberModel monthlyMemberModel, _) =>
                    monthlyMemberModel.count),
          ],
          primaryXAxis: NumericAxis(
            minimum: minMonth.toDouble(),
            labelFormat: '{value}월',
            interval: 1,
          ),
          primaryYAxis: NumericAxis(
            maximum: maxCount + maxCount*0.1,
          ),
        ),
      ),
    );
  }
}

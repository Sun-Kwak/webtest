import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_test2/common/component/animated_Object.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/extensions/hover_extensions.dart';

class MemberSummaryCard extends ConsumerStatefulWidget {
  final double width;
  // final VoidCallback onTap;

  const MemberSummaryCard({
    required this.width,
    // required this.onTap,
    super.key});

  @override
  ConsumerState<MemberSummaryCard> createState() => _MemberSummaryCardState();
}

class _MemberSummaryCardState extends ConsumerState<MemberSummaryCard> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final membersCount = ref.watch(membersCountProvider);
    final selectedMemberIdController = ref.watch(selectedMemberIdProvider.notifier);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: TABLE_HEADER_COLOR,
      ),
      width: screenWidth <= 640 ? widget.width *0.47 : widget.width * 0.24,
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
            SizedBox(
              width: 50,
              height: 40,
              child: Center(
                child: Tooltip(
                  message: '검색',
                  child: AnimatedObject(
                    onTap: () {
                      selectedMemberIdController.setSelectedRow(0);
                      ref
                          .read(filterMember.notifier)
                          .update((state) => MembersFilterState.all);
                      // widget.onTap();
                    },
                    child: Text(
                      membersCount.totalCount.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey),
                    ),
                  ).showCursorOnHover,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: '검색',
                    child: AnimatedObject(
                      onTap: () {
                        selectedMemberIdController.setSelectedRow(0);
                        ref
                            .read(filterMember.notifier)
                            .update((state) => MembersFilterState.isNew);
                        // widget.onTap();
                      },
                      child: Column(
                        children: [
                          Text(membersCount.newCount.toString()),
                          const SizedBox(
                            height: 3,
                          ),
                          const Text('신규',
                              style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w100,
                                  color: BODY_TEXT_COLOR)),
                        ],
                      ),
                    ).showCursorOnHover,
                  ),
                  Tooltip(
                    message: '검색',
                    child: AnimatedObject(
                      onTap: () {
                        selectedMemberIdController.setSelectedRow(0);
                        ref
                            .read(filterMember.notifier)
                            .update((state) => MembersFilterState.activated);
                        // widget.onTap();
                      },
                      child: Column(
                        children: [
                          Text(membersCount.contractCount.toString()),
                          const SizedBox(
                            height: 3,
                          ),
                          const Text(
                            '계약',
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w100,
                                color: BODY_TEXT_COLOR),
                          ),
                        ],
                      ),
                    ).showCursorOnHover,
                  ),
                  Tooltip(
                    message: '검색',
                    child: AnimatedObject(
                      onTap: () {
                        selectedMemberIdController.setSelectedRow(0);
                        ref.read(filterMember.notifier).update((state) => MembersFilterState.expired);
                        // widget.onTap();
                      },
                      child: Column(
                        children: [
                          Text(
                            membersCount.expiredCount.toString(),
                            style: const TextStyle(color: CUSTOM_RED),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          const Text(
                            '만료',
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w100,
                                color: CUSTOM_RED),
                          ),
                        ],
                      ),
                    ).showCursorOnHover,
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
  final double width;
  const VOCSummaryCard({
    required this.width,
    super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: TABLE_HEADER_COLOR,
      ),
      width: screenWidth <= 640 ? width *0.47 : width * 0.24,
      height: 140,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              '문의건수',
              style: TextStyle(fontSize: 11),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
                width: 50,
                height: 40,
                child: Center(
                    child: Text(
                  '12',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey),
                ))),
            Divider(),
            Padding(
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
                        style: TextStyle(color: CUSTOM_RED),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '미결',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w100,
                            color: CUSTOM_RED),
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
  final double width;
  const MonthlyMemberChart({
    required this.width,
    super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        ? monthlyCount
            .map((monthlyMember) => monthlyMember.count)
            .reduce((a, b) => a > b ? a : b)
        : 0;
    int minMonth = monthlyCount.isNotEmpty
        ? monthlyCount
            .map((monthlyMember) => monthlyMember.month)
            .reduce((a, b) => a < b ? a : b)
        : 0;

    final LinearGradient gradientColors =
        LinearGradient(colors: startColor, stops: stops);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: TABLE_HEADER_COLOR,
      ),
      width: width * 0.485,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          // legend: Legend(isVisible: true),
          series: <ChartSeries>[
            AreaSeries<MonthlyMemberModel, int>(
              // enableTooltip: true,
                selectionBehavior: SelectionBehavior(),
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero),
                gradient: gradientColors,

                name: '월별',
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
            maximum: maxCount + maxCount * 0.1,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/aerobic_power.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/bmi.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/diabetes.dart';

class DiabetesTable extends StatelessWidget {
  const DiabetesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '#2. BMI'),
            SizedBox(
              height: 10,
            ),
            SelectionArea(
              child: DataTable(
                dividerThickness: 0,
                dataTextStyle:
                TextStyle(fontSize: 10, fontFamily: 'SebangGothic'),
                headingTextStyle:
                TextStyle(fontSize: 11, fontFamily: 'SebangGothic'),
                columnSpacing: 35,
                horizontalMargin: 0,
                dataRowMinHeight: 35,
                dataRowMaxHeight: 35,
                headingRowHeight: 35,

                // dataRowMaxHeight: 30,
                columns: [
                  DataColumn(label: Text('당뇨구간')),
                  DataColumn(label: Text('범위')),
                ],
                rows: diabetesData
                    .map((data) => DataRow(
                  cells: [
                    DataCell(Text(data.category)),
                    DataCell(Text(data.range.toString())),
                  ],
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<DiabetesModel> diabetesData = [
  DiabetesModel(
    category: 'T1',
    range: 0,
  ),
  DiabetesModel(
    category: 'T2',
    range: 19,
  ),
  DiabetesModel(
    category: 'T3',
    range: 26,
  ),
];



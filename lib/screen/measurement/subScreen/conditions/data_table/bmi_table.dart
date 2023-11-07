import 'package:flutter/material.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/aerobic_power.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/model/bmi.dart';

class BmiTable extends StatelessWidget {
  const BmiTable({super.key});

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
                  DataColumn(label: Text('BMI 범위')),
                  DataColumn(label: Text('카테고리')),
                  DataColumn(label: Text('건강위험')),
                ],
                rows: bmiData
                    .map((data) => DataRow(
                  cells: [
                    DataCell(Text(data.range.toString())),
                    DataCell(Text(data.category)),
                    DataCell(Text(data.status)),
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

List<BmiModel> bmiData = [
  BmiModel(
    range: 0,
    category: '저체중',
    status: '영양 실조 위험',
  ),
  BmiModel(
    range: 18.4,
    category: '정상 체중',
    status: '낮은 위험',
  ),
  BmiModel(
    range: 25,
    category: '초과 중량',
    status: '마법에 걸린 위험',
  ),
  BmiModel(
    range: 30,
    category: '보통 비만',
    status: '중간 위험',
  ),
  BmiModel(
    range: 35,
    category: '심한 비만',
    status: '위험',
  ),
  BmiModel(
    range: 40,
    category: '매우 심하게 비만',
    status: '매우 높은 위험',
  ),
];



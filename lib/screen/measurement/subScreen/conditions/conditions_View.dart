
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/data_table/HR_percentiles_table.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/data_table/aerobic_power_table.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/data_table/bmi_table.dart';
import 'package:web_test2/screen/measurement/subScreen/conditions/data_table/diabetes_table.dart';


class ConditionsView extends ConsumerStatefulWidget {


  const ConditionsView({ super.key});

  @override
  ConsumerState<ConditionsView> createState() =>
      _ConditionsViewState();
}

class _ConditionsViewState
    extends ConsumerState<ConditionsView> {

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AerobicPowerTable(),
        SizedBox(width: 10,),
        HrPercentilesTable(),
        SizedBox(width: 10,),
        BmiTable(),
        SizedBox(width: 10,),
        DiabetesTable(),


      ],
    );
  }
}

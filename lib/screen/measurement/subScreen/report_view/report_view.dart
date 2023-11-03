import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/appointment_input_form.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/measurement_input_form.dart';
import 'package:web_test2/screen/measurement/subScreen/report_view/widget/report_filter_form.dart';
import 'package:web_test2/screen/measurement/subScreen/report_view/widget/report_form.dart';

class ReportView extends ConsumerStatefulWidget {

  const ReportView({ super.key});

  @override
  ConsumerState<ReportView> createState() =>
      ReportViewState();
}

class ReportViewState
    extends ConsumerState<ReportView> {

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportForm(),
        SizedBox(
          width: 10,
        ),
        ReportFilterForm(),
      ],
    );
  }
}

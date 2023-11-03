import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/appointment_input_form.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/measurement_input_form.dart';

class MeasurementAndAppointmentView extends ConsumerStatefulWidget {
  final VoidCallback onPressed;

  const MeasurementAndAppointmentView({required this.onPressed, super.key});

  @override
  ConsumerState<MeasurementAndAppointmentView> createState() =>
      _MeasurementAndAppointmentViewState();
}

class _MeasurementAndAppointmentViewState
    extends ConsumerState<MeasurementAndAppointmentView> {
  UniqueKey _key = UniqueKey();

  void _onPressed() {
    setState(() {
      _key = UniqueKey(); // 키를 변경하여 하위 위젯을 재빌드합니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedMeasurementController =
        ref.watch(selectedMeasurementIdProvider.notifier);
    final measurement = ref.watch(selectedMeasurementProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MeasurementInputForm(
          key: _key,
          measurement: measurement,
          onSavePressed: () {
            selectedMeasurementController.setSelectedRow(null);
            _onPressed();
            widget.onPressed();
          },
          onRefreshPressed: () {
            selectedMeasurementController.setSelectedRow(null);
            _onPressed();
          },
        ),
        SizedBox(
          width: 10,
        ),
        AppointmentInputForm(),
      ],
    );
  }
}

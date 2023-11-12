import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/appointment_input_form.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/measurement_input_form.dart';

class MeasurementAndAppointmentView extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final Measurement selectedMeasurement;

  const MeasurementAndAppointmentView({
    required this.selectedMeasurement,
    required this.onPressed, super.key});

  @override
  ConsumerState<MeasurementAndAppointmentView> createState() =>
      _MeasurementAndAppointmentViewState();
}

class _MeasurementAndAppointmentViewState
    extends ConsumerState<MeasurementAndAppointmentView> {
  UniqueKey _key = UniqueKey();
  late Measurement _selectedMeasurement;


  void _onPressed() {
    final measurementController = ref.watch(selectedScheduleMeasurementIdProvider.notifier);


    final selectedPICState = ref.watch(selectedPICProvider);
    measurementController.setSelectedRow(null);
    final measurement = ref.watch(selectedScheduleMeasurementProvider);
    setState(() {
      _selectedMeasurement = measurement;
      _selectedMeasurement = _selectedMeasurement.copyWith(
        PICId: selectedPICState.id,
        PICName: selectedPICState.displayName,
      );
    });


    setState(() {
      _key = UniqueKey(); // 키를 변경하여 하위 위젯을 재빌드합니다.
    });
  }

  void _onRecallPressed() {

    final measurement = ref.watch(selectedScheduleMeasurementProvider);

    _selectedMeasurement = measurement;
    setState(() {
      _key = UniqueKey(); // 키를 변경하여 하위 위젯을 재빌드합니다.
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedMeasurement = widget.selectedMeasurement;


  }

  @override
  Widget build(BuildContext context) {
    final measurement = ref.watch(selectedScheduleMeasurementProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    final selectedPICState = ref.watch(selectedPICProvider);
    // final measurement = ref.watch(selectedMeasurementProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MeasurementInputForm(
          key: _key,
          measurement: _selectedMeasurement,
          onCancelPressed: (){
            _onPressed();
          },
          onSavePressed: () {
            _onPressed();
            widget.onPressed();
          },
          onRefreshPressed: () {
            _onPressed();
          },
        ),
        SizedBox(
          width: 10,
        ),
        AppointmentInputForm(
          onPressed: (){

            _onRecallPressed();
          },
        ),
      ],
    );
  }
}

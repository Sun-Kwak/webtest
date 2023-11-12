
import 'package:form_validator/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/controller/measurement_input_state.dart';
import 'package:web_test2/screen/member/controller/member_input_state.dart';
import 'package:authentication_repository/src/members_repository.dart';

final measurementInputProvider =
StateNotifierProvider<MeasurementInputController, MeasurementInputState>(
      (ref) => MeasurementInputController(ref.watch(measurementRepositoryProvider), ref.watch(measurementEditingProvider)),
);

class MeasurementInputController extends StateNotifier<MeasurementInputState> {
  final MeasurementRepository _measurementRepository;
  final MeasurementEditingProvider _measurementEditingProvider;


  MeasurementInputController(this._measurementRepository, this._measurementEditingProvider)
      : super(const MeasurementInputState());

  void onNameChange(String? value) {
    final name = value == null ? const Name.pure() : Name.dirty(value);

    state = state.copyWith(
      name: name,
      status: Formz.validate([
        name,
      ]),
    );
  }


  void resetAll() {
    const name = Name.pure();
    state = state.copyWith(
      name: name,
      status: Formz.validate([
        name,
      ]),
    );
  }

  void recall(String memberName) {
    var name = Name.dirty(memberName);
    state = state.copyWith(
      name: name,
      status: Formz.validate([
        name,
      ]),
    );

  }

  void addMeasurement(Measurement measurement,int memberId, String PICId, String PICName, DateTime startDate, DateTime endDate, MeasurementProvider measurementProvider) async {
    if (!state.status.isValidated) return;
    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      Measurement newMeasurement = measurement.copyWith(
        memberName: state.name.value,
        memberId: memberId,
        PICId: PICId,
        PICName: PICName,
        startDate: startDate,
        endDate: endDate,
      );
      state = state.copyWith(status: FormzStatus.submissionSuccess);
      resetAll();


      if (_measurementEditingProvider.isEditing == true) {
        await _measurementRepository.updateMeasurement(newMeasurement);
      } else {
        newMeasurement = newMeasurement.copyWith(
            createdAt: DateTime.now()
        );
        await _measurementRepository.addMeasurement(newMeasurement);
      }
      measurementProvider.getMeasurements();

    } on MeasurementAddFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:form_validator/form_validators.dart';

class MeasurementInputState extends Equatable {
  final Name name;
  final FormzStatus status;
  final String? errorMessage;

  const MeasurementInputState({
    this.name = const Name.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  MeasurementInputState copyWith({
    Name? name,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return MeasurementInputState(
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    status,
  ];
}
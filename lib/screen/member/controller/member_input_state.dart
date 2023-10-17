import 'package:equatable/equatable.dart';
import 'package:form_validator/form_validators.dart';

class MemberInputState extends Equatable {
  final Name name;
  final Date date;
  final Phone phone;
  final FormzStatus status;
  final String? errorMessage;

  const MemberInputState({
    this.name = const Name.pure(),
    this.date = const Date.pure(),
    this.phone = const Phone.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  MemberInputState copyWith({
    Name? name,
    Date? date,
    Phone? phone,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return MemberInputState(
      name: name ?? this.name,
      date: date ?? this.date,
      phone:  phone ?? this.phone,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    date,
    phone,
    status,
  ];
}
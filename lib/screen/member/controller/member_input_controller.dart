import 'package:form_validator/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:web_test2/screen/member/controller/member_input_state.dart';
import 'package:web_test2/screen/member/data/member_data_table.dart';
import 'package:authentication_repository/src/members_repository.dart';
import 'package:web_test2/screen/member/widget/member_search_form.dart';

final memberInputProvider =
    StateNotifierProvider.autoDispose<MemberInputController, MemberInputState>(
  (ref) => MemberInputController(ref.watch(memberRepositoryProvider), ref.watch(memberSearchFormStateProvider)),
);

class MemberInputController extends StateNotifier<MemberInputState> {
  final MemberRepository _memberRepository;
  final MemberSearchFormState memberSearchFormState;

  // final MembersTableState membersTableState;
  

  MemberInputController(this._memberRepository, this.memberSearchFormState)
      : super(const MemberInputState());

  void onNameChange(String value) {
    final name = Name.dirty(value);

    state = state.copyWith(
        name: name,
        status: Formz.validate([
          name,
          state.date,
          state.phone,
        ]),
    );
  }

  void onDateChange(String value) {
    final date = Date.dirty(value);
    state = state.copyWith(
      date: date,
      status: Formz.validate([
        date,
        state.name,
        state.phone,
      ]),
    );
  }

  void onPhoneChange(String value) async {
    final phone = Phone.dirty(value);
    state = state.copyWith(
      phone: phone,
      status: Formz.validate([
        phone,
        state.name,
        state.date,
      ]),
    );
    // if (value.length == 13) {
    //   bool isPhoneNumberDuplicate = await _memberRepository.checkPhoneNumber(value);
    //   if (isPhoneNumberDuplicate) {
    //     state = state.copyWith(
    //       status: FormzStatus.submissionFailure,
    //       errorMessage: '이미 등록된 전화번호입니다.',
    //     );
    //   }
    // }
  }

  void resetAll() {
    const name = Name.pure();
    const date = Date.pure();
    const phone = Phone.pure();
    state = state.copyWith(
      name: name,
      date: date,
      phone: phone,
      status: Formz.validate([
        phone,
        date,
        name,
      ]),
    );
  }

  void addMember(Member member) async {
 
    if (!state.status.isValidated) return;
    state = state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      // Member member = Member.empty();
      Member newMember = member.copyWith(
        displayName: state.name.value,
        gender: member.gender,
        birthDay: state.date.value,
        phoneNumber: state.phone.value,
        address: member.address,
        signUpPath: member.signUpPath,
        referralID: member.referralID,
        accountLinkID: member.accountLinkID,
        memo: member.memo,
        // status: member.status,
        // referralCount: member.referralCount,
        // firstDate: member.firstDate,
        // expiryDate: member.expiryDate,
        // totalFee: member.totalFee,
        // totalAttendanceDays: member.totalAttendanceDays,
      );
      state = state.copyWith(status: FormzStatus.submissionSuccess);
      await _memberRepository.addMember(newMember);
      // await memberSearchFormState.fetchMembersData();
      // await membersTableState.addMember(newMember);
    } on MemberAddFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }
}

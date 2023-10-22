import 'package:authentication_repository/authentication_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter/material.dart';

final membersProvider =
    StateNotifierProvider<MembersProvider, List<Member>>((ref) {
  final repository = ref.watch(memberRepositoryProvider);
  return MembersProvider(repository: repository);
});

class MembersProvider extends StateNotifier<List<Member>> {
  final MemberRepository repository;

  MembersProvider({
    required this.repository,
  }) : super([]) {
    getMembers(); // 생성자에서 getMembers() 호출
  }

  Future<void> getMembers() async {
    try {
      List<Member> members = await repository.getMembersData();
      state = members;
    } catch (e) {
      print('Error: $e');
    }
  }
}



class SelectedRowProvider extends StateNotifier<int> {
  SelectedRowProvider(int initialValue) : super(initialValue);

  void setSelectedRow(int newValue) {
    state = newValue;
  }
}

final selectedRowProvider = StateNotifierProvider<SelectedRowProvider, int>((ref) {
  return SelectedRowProvider(0);
});
//------------------------------------------------------------------------------
final selectedMemberProvider = Provider<Member>(
    (ref) {
      final membersState = ref.watch(membersProvider);
      final selectedRow = ref.watch(selectedRowProvider);
      Member selectedMember;
      if(selectedRow == 0 || membersState.isEmpty) {
        selectedMember = Member.empty();
      } else {
      selectedMember = membersState.firstWhere((element) => element.id == selectedRow);}
      return selectedMember;
    }
);
//---------------------------------------------------------------------------------
final membersCountProvider = Provider<MemberCountModel>(
  (ref) {
    final membersState = ref.watch(membersProvider);
    int totalCount = membersState.length;
    int newCount = membersState.where((member) => member.contractStatus == '신규').length;
    int contractCount =
        membersState.where((member) => member.contractStatus == '계약').length;
    int expiredCount =
        membersState.where((member) => member.contractStatus == '만료').length;

    return MemberCountModel(
        totalCount: totalCount,
        newCount: newCount,
        contractCount: contractCount,
        expiredCount: expiredCount);
  },
);

final monthlyCountProvider = Provider<List<MonthlyMemberModel>>(
  (ref) {
    List<MonthlyMemberModel> monthlyMember = [];
    final membersState = ref.watch(membersProvider);
    Map<int, int> newMonthlyMembers = {};
    for (var newMember in membersState) {
      int month = newMember.createdAt.month;
      // Check if the month is already in the map
      if (newMonthlyMembers.containsKey(month)) {
        // If yes, increment the count
        newMonthlyMembers[month] = newMonthlyMembers[month]! + 1;
      } else {
        // If not, add the month to the map with count 1
        newMonthlyMembers[month] = 1;
      }
    }
    List<MapEntry<int, int>> monthlyMembersList =
        newMonthlyMembers.entries.toList();
    monthlyMembersList.sort((a, b) => a.key.compareTo(b.key));
    monthlyMember = monthlyMembersList
        .map(
            (entry) => MonthlyMemberModel(month: entry.key, count: entry.value))
        .toList();

    return monthlyMember;
  },
);

//---------------------------------------------------------------------------

class SelectedReferralIDProvider extends ChangeNotifier {
  int? selectedReferralId;
  String? selectedReferralName;
  SelectedReferralIDProvider({required  this.selectedReferralId, required this.selectedReferralName});

  void setSelectedReferralID(int? newId, String? newValue) {
    selectedReferralId = newId;
    selectedReferralName = newValue;
  }

}

final selectedReferralIDProvider =
ChangeNotifierProvider<SelectedReferralIDProvider>((ref) {
  return SelectedReferralIDProvider(selectedReferralId: null, selectedReferralName: null);
});


import 'package:authentication_repository/authentication_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    getMembers();
  }

  Future<void> getMembers() async {
    try {
      List<Member> members = await repository.readMembers();
      state = members;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getDisabledMembers() async {
    try {
      List<Member> members = await repository.readDisabledMembers();
      state = members;
    } catch (e) {

    }
  }
}

enum MembersFilterState {
  all,
  isNew,
  activated,
  expired,
}

final filterMember =
    StateProvider<MembersFilterState>((ref) => MembersFilterState.all);

final filteredMembersProvider = Provider<List<Member>>(
  (ref) {
    final filterState = ref.watch(filterMember);
    final members = ref.watch(membersProvider);

    // if(selectedID == 0){
    //   return members;
    // }
    if (filterState == MembersFilterState.all) {
      return members;
    }
    return members
        .where(
          (element) => filterState == MembersFilterState.isNew
              ? element.contractStatus == '신규'
              : filterState == MembersFilterState.activated
                  ? element.contractStatus == '계약'
                  : element.contractStatus == '만료',
        )
        .toList();
  },
);

class SelectedMemberIDProvider extends StateNotifier<int> {
  SelectedMemberIDProvider(int initialValue) : super(initialValue);

  void setSelectedRow(int newValue) {
    state = newValue;
  }
  notifyListeners() {
    // TODO: implement notifyListeners
    throw UnimplementedError();
  }
}

final selectedMemberIdProvider =
    StateNotifierProvider<SelectedMemberIDProvider, int>((ref) {
  return SelectedMemberIDProvider(0);
});
//------------------------------------------------------------------------------
final selectedMemberProvider = Provider<Member>((ref) {
  final membersState = ref.watch(filteredMembersProvider);
  final selectedID = ref.watch(selectedMemberIdProvider);
  Member selectedMember;
  if (selectedID == 0 || membersState.isEmpty) {
    selectedMember = Member.empty();
  } else {
    selectedMember =
        membersState.firstWhere((element) => element.id == selectedID);
  }
  return selectedMember;
});

// class UpdatingMemberProvider extends StateNotifier<Member> {
//   UpdatingMemberProvider(Member initialValue) : super(initialValue);
//
//   void setNewState(Member newValue) {
//     state = newValue;
//   }
//   notifyListeners() {
//     // TODO: implement notifyListeners
//     throw UnimplementedError();
//   }
// }
//
// final updatingMemberProvider =
// StateNotifierProvider<UpdatingMemberProvider, Member>((ref) {
//   return UpdatingMemberProvider(Member.empty());
// });
//---------------------------------------------------------------------------------
final membersCountProvider = Provider<MemberCountModel>(
  (ref) {
    final membersState = ref.watch(membersProvider);
    int totalCount = membersState.length;
    int newCount =
        membersState.where((member) => member.contractStatus == '신규').length;
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




import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/screen/member/widget/member_infor_form.dart';
import 'package:web_test2/screen/member/widget/member_input_form.dart';
import 'package:web_test2/screen/member/widget/member_search_form.dart';
import 'package:web_test2/screen/member/widget/member_voc_form.dart';

class MembersView extends ConsumerStatefulWidget {
  const MembersView({super.key});

  @override
  ConsumerState<MembersView> createState() => MembersViewState();
}

class MembersViewState extends ConsumerState<MembersView> {
  UniqueKey _key = UniqueKey();
  UniqueKey _key2 = UniqueKey();
  late Member selectedMember;

  void _onPressed() {
    final member = ref.watch(selectedMemberProvider);
    setState(() {
      selectedMember = member;
      _key = UniqueKey(); // 키를 변경하여 하위 위젯을 재빌드합니다.
      _key2 = UniqueKey(); // 키를 변경하여 하위 위젯을 재빌드합니다.
    });
  }
  final ScrollController controller = ScrollController();

  // bool isEditing = false;
  // Member member = Member.empty();
  // late List<Member> members;

  //
  // void onEditButtonClicked() {
  //   final isEditingControl = ref.watch(memberEditingProvider);
  //   final selectedMember = ref.watch(selectedMemberProvider);
  //   setState(() {
  //     if (isEditingControl.isEditing == true) {
  //       member = selectedMember;
  //     }
  //   });
  // }
  // //
  // void inputButtonsClicked() async {
  //   setState(() {
  //     final selectedMember = ref.watch(selectedMemberProvider);
  //
  //     member = selectedMember;
  //
  //   });
  // }

//   void filterMember() {
//     final filteredMembers = ref.watch(filteredMembersProvider);
//     setState(() {
//       members = filteredMembers;
//     });
// }


  @override
  void initState() {
    super.initState();
    selectedMember = Member.empty();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(filteredMembersProvider);
    final isEditingControl = ref.watch(memberEditingProvider);
    final selectedMemberController =
    ref.watch(selectedMemberIdProvider.notifier);
    selectedMember = ref.watch(selectedMemberProvider);
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scrollbar(
      thumbVisibility: true,
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Column(
                      children: [

                        MemberInputForm(
                          key: _key,
                          onRefreshPressed: (){
                            _onPressed();
                            selectedMemberController.setSelectedRow(0);
                          } ,
                          onSavePressed: (){
                            _onPressed();
                            selectedMemberController.setSelectedRow(0);
                          },
                          isEditing: isEditingControl.isEditing,
                          member: selectedMember,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MemberInforForm(
                          key: _key2,
                          member: selectedMember,
                        ),
                        if (screenWidth < 640) ...[
                          const SizedBox(
                            height: 20,
                          ),
                          MemberSearchForm(
                            // onTap: (){
                            //   filterMember();
                            // },
                            members: members,
                            onPressed: () {
                              _onPressed();
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const MemberVOCForm(),
                        ],
                      ],
                    ),
                  ],
                ),
                if (screenWidth >= 640) ...[
                  const SizedBox(
                    width: 10,
                  ),
                  MemberSearchForm(
                    // onTap: (){
                    //   filterMember();
                    // },
                    members: members,
                    onPressed: () {
                      _onPressed();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // const MemberVOCForm(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

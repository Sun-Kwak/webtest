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
  final ScrollController controller = ScrollController();

  bool isRefresh = false;
  bool isEditing = false;
  Member member = Member.empty();
  void onSaveButtonClicked() {
    final memberUpdateProviderValue = ref.watch(memberUpdateProvider);
    if (memberUpdateProviderValue.status == MemberUpdateStatus.on) {
      isRefresh = false;
    } else {
      isRefresh = true;
    }
  }
  void onEditButtonClicked() {
    final isEditingControl = ref.watch(memberEditingProvider);
    setState(() {
      if (isEditingControl.isEditing == true) {
        final selectedMember = ref.watch(selectedMemberProvider);
        member = selectedMember;
        isEditing = true;
      } else {
        isEditing = false;
      }
    });
  }

  @override
  void initState() {

    print('view 시작 $isEditing');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final selectedMember = ref.watch(selectedMemberProvider);
    final isEditingControl = ref.watch(memberEditingProvider);

    final double screenWidth = MediaQuery.of(context).size.width;
    return Scrollbar(
      // trackVisibility: true,
      thumbVisibility: true,
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child:  SingleChildScrollView(
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Column(
                  children: [
                    Column(
                      children: [
                        MemberInputForm(
                          isEditing: isEditingControl.isEditing,
                          member: member,
                          onPressed: (){
                            onSaveButtonClicked();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MemberInforForm(),
                        if (screenWidth < 640) ...[
                          const SizedBox(
                            height: 20,
                          ),
                          MemberSearchForm(
                            onPressed: (){
                              onEditButtonClicked();
                            },
                            isRefresh: isRefresh,
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
                    onPressed: (){
                      onEditButtonClicked();
                    },
                    isRefresh: isRefresh,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const MemberVOCForm(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
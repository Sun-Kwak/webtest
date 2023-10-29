import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/animated_Icon.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/custom_switcher_loading_widget.dart';
import 'package:web_test2/common/component/output_widget/custom_summary_card.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/provider/selected_screen_index_provider.dart';
import 'package:authentication_repository/src/authentication_controller.dart';
import 'package:web_test2/screen/member/controller/member_input_controller.dart';
import 'package:web_test2/screen/member/data/member_data_table.dart';

// final memberSearchFormStateProvider =
//     StateProvider<MemberSearchFormState>((ref) {
//   return MemberSearchFormState();
// });

class MemberSearchForm extends ConsumerStatefulWidget {
  // final VoidCallback onTap;
  final List<Member> members;
  final VoidCallback onPressed;

  const MemberSearchForm({
    // required this.onTap,
    required this.members,
    required this.onPressed,
    super.key,
  });

  @override
  ConsumerState<MemberSearchForm> createState() => MemberSearchFormState();
}

class MemberSearchFormState extends ConsumerState<MemberSearchForm> {
  // bool isRotated = false;
  bool showMore = false;

  @override
  void didUpdateWidget(MemberSearchForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.members != oldWidget.members) {
      setState(() {
        widget.members;
      });
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    final memberRepository = ref.watch(memberRepositoryProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    final selectedRow = ref.watch(selectedMemberIdProvider.notifier);
    final controller = ref.watch(membersProvider.notifier);
    final Member member = selectedMember;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(
            Icons.info_outline,
            color: Colors.amber,
            size: 50,
          ),
          content: const Text(
            '선택 회원 사용중단 하시겠습니까?',
            style: TextStyle(color: PRIMARY_COLOR),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '취소',
                style: TextStyle(color: CUSTOM_RED),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(color: PRIMARY_COLOR),
              ),
              onPressed: () {
                selectedRow.setSelectedRow(0);
                memberRepository.disableMember(member, controller);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final filteredMembers = ref.watch(filteredMembersProvider);

    final double screenWidth = MediaQuery.of(context).size.width;
    // final double formWidth = screenWidth < 650
    //     ? screenWidth - 20
    //     : showMore
    //         ? 2000
    //         : screenWidth - 710;
    final double formWidth = showMore ? 2000 : screenWidth <= 640 ? screenWidth - 20 : screenWidth < 1487 ? 777 : screenWidth -710;


    return CustomBoxRadiusForm(
      width: formWidth,
      title: '회원검색',
      height: screenWidth <= 640 ? 880 : 820,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          renderTopCard(formWidth),
          const Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Divider(
              height: 2,
            ),
          ),
          renderMiddleTap(formWidth),
          const Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Divider(
              height: 2,
            ),
          ),
          filteredMembers.isEmpty
              ? const Expanded(child: CustomSwitcherLoadingWidget())
              : Expanded(
                  child: MembersTable(
                    width: formWidth,
                    showMore: showMore,
                    // members: widget.members,
                    height: 530,
                  ),
                ),
        ],
      ),
    );
  }

  Widget renderMiddleTap(double formWidth) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final selectedScreenIndexController = ref.watch(selectedScreenIndexProvider.notifier);
    final editing = ref.watch(memberEditingProvider.notifier);
    final selectedMember = ref.watch(selectedMemberProvider);
    final selectedRow = ref.watch(selectedMemberIdProvider);
    final memberInputController = ref.read(memberInputProvider.notifier);
    final userme = ref.watch(userMeProvider);

    return SizedBox(
      width: formWidth,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (selectedRow != 0) {
                    _showConfirmationDialog(
                      context,
                    );
                  }
                },
                icon: const Icon(Icons.delete),
                tooltip: '중단/재사용',
                color: CUSTOM_RED,
              ),
              CustomTextOutputWidget(
                border: false,
                textColor: Colors.white,
                color: CUSTOM_BLACK,
                label: '선택회원',
                height: 28,
                textBoxWidth: 130,
                labelBoxWidth: 50,
                outputText: selectedMember.displayName,
              ),
              IconButton(
                onPressed: () {
                  if (selectedMember.id != 0) {
                    editing.toggleStatus(true);
                    memberInputController.recall(selectedMember);
                    widget.onPressed();
                  }
                },
                icon: const Icon(Icons.edit),
                tooltip: '수정',
                color: PRIMARY_COLOR,
              ),
              IconButton(
                onPressed: () {
                  selectedScreenIndexController.setSelectedIndex(1);
                },
                icon: const Icon(Icons.edit_calendar_outlined),
                tooltip: '계약',
                color: PRIMARY_COLOR,
              ),
              IconButton(
                onPressed: () {

                  selectedScreenIndexController.setSelectedIndex(3);

                },
                icon: const Icon(Icons.monitor_heart),
                tooltip: '건강',
                color: PRIMARY_COLOR,
              ),
              IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.fact_check),
                tooltip: '출석',
                color: PRIMARY_COLOR,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // AlertDialog를 반환합니다.
                      return AlertDialog(
                        title: Text('제목'),
                        content: Text('${userme.status}'),
                        actions: <Widget>[
                          // AlertDialog 안에 버튼을 추가할 수 있습니다.
                          TextButton(
                            child: Text('닫기'),
                            onPressed: () {
                              // AlertDialog를 닫습니다.
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add_comment),
                tooltip: '상담',
                color: PRIMARY_COLOR,
              ),
              Spacer(),
              if(screenWidth > 640)
                renderMiddleTapRight(formWidth),
            ],
          ),
          if(screenWidth <=640)
            renderMiddleTapRight(formWidth),
        ],
      ),
    );
  }

  Widget renderMiddleTapRight(double formWidth) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final controller = ref.watch(membersProvider.notifier);
    return Container(
      width: screenWidth <= 640 ? screenWidth : formWidth * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          screenWidth <= 640  ? Spacer() : SizedBox(),
          IconButton(
            onPressed: () {
              controller.getDisabledMembers();
            },
            icon: const Icon(Icons.search_off),
            tooltip: '중단검색',
            color: CUSTOM_RED,
          ),
           SizedBox(
              width: screenWidth <= 640 ? screenWidth * 0.5 : formWidth * 0.2,
              height: 28,
              child: CupertinoSearchTextField(
                itemSize: 20,
                style: TextStyle(fontSize: 12, fontFamily: 'SebangGothic'),
              )),
          CustomRefreshIcon(
            onPressed: () {
              ref
                  .read(filterMember.notifier)
                  .update((state) => MembersFilterState.all);
              controller.getMembers();
              ref.read(selectedMemberIdProvider.notifier).setSelectedRow(0);
            },
          ),
          const SizedBox(),
          Tooltip(
            message: showMore ? '숨기기' : '확장',
            child: CustomAnimatedIcon(
              iconData: AnimatedIcons.menu_arrow,
              onTap: () {
                setState(() {
                  showMore = !showMore;
                });
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
}

  Widget renderTopCard(double formWidth) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: SizedBox(
        width: formWidth,
        height: 161,
        child: Row(
          children: [
            MemberSummaryCard(
              width: formWidth,
              // onTap: () {
              //   widget.onTap();
              // },
            ),
            const Spacer(),
            VOCSummaryCard(
              width: formWidth,
            ),
            const Spacer(),
            screenWidth > 640 ?
            MonthlyMemberChart(
              width: formWidth,
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }
}

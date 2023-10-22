import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/animated_Icon.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/custom_switcher_loading_widget.dart';
import 'package:web_test2/common/component/output_widget/custom_summary_card.dart';
import 'package:web_test2/common/component/output_widget/custom_text_output_widget.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/screen/member/data/member_data_table.dart';
import 'package:authentication_repository/src/members_repository.dart';

final memberSearchFormStateProvider =
    StateProvider<MemberSearchFormState>((ref) {
  return MemberSearchFormState();
});

class MemberSearchForm extends ConsumerStatefulWidget {
  final bool isRefresh;
  final VoidCallback onPressed;

  const MemberSearchForm(
      {required this.onPressed, required this.isRefresh, super.key});

  @override
  ConsumerState<MemberSearchForm> createState() => MemberSearchFormState();
}

class MemberSearchFormState extends ConsumerState<MemberSearchForm> {
  bool isRotated = false;
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double formWidth = screenWidth < 650
        ? screenWidth - 20
        : showMore
            ? 2000
            : 1020;

    return CustomBoxRadiusForm(
      width: formWidth,
      title: '회원검색',
      height: 820,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          renderTopCard(),
          const Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Divider(
              height: 2,
            ),
          ),
          renderMiddleTap(),
          const Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Divider(
              height: 2,
            ),
          ),
          members.isEmpty
              ? const Expanded(child: CustomSwitcherLoadingWidget())
              : Expanded(
                  child: MembersTable(
                    showMore: showMore,
                    members: members,
                    height: 530,
                  ),
                ),
        ],
      ),
    );
  }

  Widget renderMiddleTap() {
    final controller = ref.watch(membersProvider.notifier);
    final editing = ref.watch(memberEditingProvider.notifier);
    final selectedMember = ref.watch(selectedMemberProvider);

    return SizedBox(
      width: 1020,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const SizedBox(width: 20,),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
            tooltip: '중단/재사용',
            color: Colors.redAccent,
          ),
          CustomTextOutputWidget(
            textColor: Colors.white,
            color: Colors.black54,
            label: '선택고객',
            height: 28,
            textBoxWidth: 130,
            labelBoxWidth: 60,
            outputText: selectedMember.displayName,
          ),
          IconButton(
            onPressed: () {
              editing.toggleStatus(true);
              widget.onPressed();
              print(editing.isEditing);
            },
            icon: const Icon(Icons.edit),
            tooltip: '수정',
            color: PRIMARY_COLOR,
          ),
          IconButton(
            onPressed: () {
              editing.toggleStatus(false);
              print(editing.isEditing);
            },
            icon: const Icon(Icons.edit_calendar_outlined),
            tooltip: '계약',
            color: PRIMARY_COLOR,
          ),
          IconButton(
            onPressed: () {
              print(editing.isEditing);
            },
            icon: const Icon(Icons.monitor_heart),
            tooltip: '건강',
            color: PRIMARY_COLOR,
          ),
          IconButton(
            onPressed: () {
              print(
                  '${selectedMember.birthDay}  ${selectedMember.birthDay.runtimeType}');
            },
            icon: const Icon(Icons.fact_check),
            tooltip: '출석',
            color: PRIMARY_COLOR,
          ),
          const Expanded(child: SizedBox()),
          const SizedBox(
              width: 250,
              height: 28,
              child: CupertinoSearchTextField(
                itemSize: 20,
                style: TextStyle(fontSize: 12, fontFamily: 'SebangGothic'),
              )),
          CustomRefreshIcon(
            onPressed: () {
              controller.getMembers();
              ref.read(selectedRowProvider.notifier).setSelectedRow(0);
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

  Widget renderTopCard() {
    return const SizedBox(
      width: 1000,
      height: 161,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          MemberSummaryCard(),
          SizedBox(
            width: 10,
          ),
          VOCSummaryCard(),
          SizedBox(
            width: 10,
          ),
          MonthlyMemberChart(),
        ],
      ),
    );
  }
}

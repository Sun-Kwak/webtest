import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/animated_Icon.dart';
import 'package:web_test2/common/component/custom_boxRadius_form.dart';
import 'package:web_test2/common/component/custom_refresh_icon.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';
import 'package:web_test2/screen/member/data/member_data_table.dart';


final memberSearchFormStateProvider = StateProvider<MemberSearchFormState>((ref) {
  return MemberSearchFormState();
});

class MemberSearchForm extends ConsumerStatefulWidget {
  const MemberSearchForm({super.key});


  @override
  ConsumerState<MemberSearchForm> createState() => MemberSearchFormState();
}

class MemberSearchFormState extends ConsumerState<MemberSearchForm> {

  bool isRotated = false;

  bool showMore = false;
  late List<Member> members;

  @override
  void initState() {
    members =[];
    super.initState();
    fetchMembersData();
  }

  Future<void> fetchMembersData() async {
    final memberController = ref.read(memberRepositoryProvider);
    List<Member> newMembers = await memberController.getMembersData();
    setState(() {
      members = newMembers;
    });

  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double formWidth = screenWidth < 650 ? screenWidth - 20 : showMore
        ? 2000
        : 1020;

    return CustomBoxRadiusForm(
      width: formWidth,
      title: '회원검색',
      height: 820,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 2,
          ),
          SizedBox(
            width: 1020,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomRefreshIcon(
                  onPressed: () {

                    fetchMembersData();
                  },
                ),
                const SizedBox(),
                Tooltip(
                  message: showMore ? '숨기기' : '확장',
                  child: CustomAnimatedIcon(
                    iconData: AnimatedIcons.menu_arrow, onTap: () {
                    setState(() {
                      showMore = !showMore;
                    });
                  },),
                ),
                SizedBox(width: 10,),
              ],
            ),
          ),
          Divider(
            height: 2,
          ),
          members.isEmpty ? Center(child: CircularProgressIndicator()):
          Expanded(
            child: MembersTable(showMore: showMore, members: members),
          ),
        ],
      ),
    );

  }
}



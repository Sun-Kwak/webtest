import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/const/colors.dart';
import 'package:web_test2/common/provider/selected_screen_index_provider.dart';
import 'package:web_test2/screen/attendance_check_view.dart';
import 'package:authentication_repository/src/authentication_controller.dart';
import 'package:authentication_repository/src/signedIn_user_provider.dart';
import 'package:web_test2/screen/contract_view.dart';
import 'package:web_test2/screen/course_view.dart';
import 'package:web_test2/screen/measurement/measurement_view.dart';
import 'package:web_test2/screen/member/member_view.dart';
import 'package:web_test2/screen/settings_view.dart';

import '../../screen/measurement/subScreen/measurement&appointment_view/controller/appointment_provider.dart';

class RootTab extends ConsumerStatefulWidget {
  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  double zoomLevel = 1.0;
  String dropdownValue = '동천역';
  late TabController controller;
  int _selectedIndex = 0;
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 6, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    // final selectedScreenIndex = ref.watch(selectedScreenIndexProvider);
    // // if (this.mounted) {
    setState(() {
      _selectedIndex = controller.index;
    });
  }

  // }
  final List<Widget> mainContents = [
    const MembersView(),
    // const MeasurementView(),
    const ContractView(),
    const CourseView(),
    const MeasurementView(),
    const AttendanceCheckView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final authController = ref.read(userMeProvider.notifier);
    final signInUserState = ref.watch(signedInUserProvider);
    final selectedIDController = ref.watch(selectedMemberIdProvider.notifier);
    final memberController = ref.watch(membersProvider.notifier);
    final double screenWidth = MediaQuery.of(context).size.width;
    final selectedScreenIndexController =
        ref.watch(selectedScreenIndexProvider.notifier);
    final selectedIndex = ref.watch(selectedScreenIndexProvider);
    final EdgeInsets appBarMargin = screenWidth <= 640
        ? const EdgeInsets.only(left: 20, top: 12)
        : screenWidth < 1200 || isSwitched == false
            ? const EdgeInsets.only(left: 100, top: 12)
            : const EdgeInsets.only(left: 170, top: 12);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 35,
        leadingWidth: 300,
        leading: Container(
          margin: appBarMargin,
          child: Align(
            alignment: Alignment.centerLeft,
            child: DropdownButton<String>(
                underline: const SizedBox(),
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                      value: '동천역',
                      child: Text(
                        '동천역',
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                          fontSize: 17,
                        ),
                      )),
                ]),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_outlined),
                color: BODY_TEXT_COLOR,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_outlined),
                color: BODY_TEXT_COLOR,
              ),
              FractionalTranslation(
                translation: Offset(0,0.3),
                child: Text(
                  '${signInUserState.value?.displayName} 님',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          authController.onSignOut();
        },
        isExtended: true,
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
        child:
            const Tooltip(message: '로그아웃', child: Icon(Icons.logout_outlined)),
      ),
      bottomNavigationBar: screenWidth < 640
          ? BottomNavigationBar(
              backgroundColor: PRIMARY_COLOR,
              selectedItemColor: Colors.white,
              // unselectedItemColor: CONSTRAINT_PRIMARY_COLOR,
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                final selectedMeasurementController =
                    ref.watch(selectedMeasurementProvider.notifier);
                selectedMeasurementController.removeState();
                selectedScreenIndexController.setSelectedIndex(index);
                controller.animateTo(index);
              },
              currentIndex: _selectedIndex,
              unselectedIconTheme:
                  const IconThemeData(color: INPUT_BORDER_COLOR),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                    tooltip: '회원등록', icon: Icon(Icons.people), label: '회원등록'),
                BottomNavigationBarItem(
                    tooltip: '계약관리',
                    icon: Icon(Icons.edit_calendar_outlined),
                    label: '계약관리'),
                BottomNavigationBarItem(
                    tooltip: '강의등록',
                    icon: Icon(Icons.calendar_month),
                    label: '강의등록'),
                BottomNavigationBarItem(
                    tooltip: '건강측정',
                    icon: Icon(Icons.monitor_heart),
                    label: '건강측정'),
                BottomNavigationBarItem(
                    tooltip: '출결관리',
                    icon: Icon(Icons.fact_check),
                    label: '출결관리'),
                BottomNavigationBarItem(
                    tooltip: '기본설정', icon: Icon(Icons.settings), label: '기본설정'),
              ],
            )
          : null,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (screenWidth >= 640)
            NavigationRail(

              useIndicator: true,
              indicatorColor: CONSTRAINT_PRIMARY_COLOR,
              minExtendedWidth: 150,
              minWidth: 80,
              trailing: Expanded(
                child: screenWidth >= 1200
                    ? Switch(
                        value: isSwitched,
                        activeColor: Colors.white,
                        inactiveTrackColor: PRIMARY_COLOR,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                      )
                    : const SizedBox(),
              ),
              extended: !isSwitched
                  ? false
                  : screenWidth >= 1200
                      ? true
                      : false,
              selectedIndex: selectedIndex,
              onDestinationSelected: (int index) {
                final selectedMeasurementController =
                    ref.watch(selectedMeasurementProvider.notifier);
                selectedMeasurementController.removeState();
                selectedScreenIndexController.setSelectedIndex(index);
                setState(() {
                  _selectedIndex = index;
                });
                if (_selectedIndex == 0) {
                  memberController.getMembers();
                  selectedIDController.setSelectedRow(0);
                }
              },
              elevation: 5,
              backgroundColor: PRIMARY_COLOR,
              selectedIconTheme: const IconThemeData(color: Colors.white),
              selectedLabelTextStyle: const TextStyle(

                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SebangGothic'),
              unselectedLabelTextStyle: const TextStyle(
                  color: INPUT_BORDER_COLOR,
                  fontWeight: FontWeight.w100,
                  fontFamily: 'SebangGothic'),
              unselectedIconTheme:
                  const IconThemeData(color: INPUT_BORDER_COLOR),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.people), label: Text('회원관리 ')),

                NavigationRailDestination(
                    icon: Icon(Icons.edit_calendar_outlined),
                    label: Text(
                      '계약관리 ',
                    )),
                NavigationRailDestination(
                    icon: Icon(Icons.calendar_month), label: Text('강의등록 ')),
                NavigationRailDestination(
                    icon: Icon(Icons.monitor_heart), label: Text('건강측정 ')),
                NavigationRailDestination(
                    icon: Icon(Icons.fact_check), label: Text('출결관리 ')),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text('기본설정 ')),
              ],
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                    child: Padding(
                  padding: screenWidth > 640
                      ? const EdgeInsets.only(left: 10, top: 13, right: 10)
                      : const EdgeInsets.only(left: 10, top: 3, right: 10),
                  child: mainContents[selectedIndex],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

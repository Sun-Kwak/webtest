import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/input_widget/custom_seachable_dropdown_input_widget.dart';
import 'package:web_test2/common/const/colors.dart';

import '../../measurement&appointment_view/widget/intensity_setting.dart';

class ReportFilterForm extends ConsumerStatefulWidget {
  const ReportFilterForm({super.key});

  @override
  ConsumerState<ReportFilterForm> createState() => _ReportFilterFormState();
}

class _ReportFilterFormState extends ConsumerState<ReportFilterForm> {
  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        width: 350,
        height: 800,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.filter_alt_outlined,
                color: PRIMARY_COLOR,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  IntensitySettingInputWidget(
                    onChanged: (v) {},
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  CustomSearchDropdownWidget(
                    idSelector: (member) => member.id,
                    labelBoxWidth: 50,
                    selectedValue: selectedMember.displayName,
                    label: '회원선택',
                    textBoxWidth: 150,
                    list: members,
                    titleSelector: (member) => member.displayName,
                    subtitleSelector: (member) => member.phoneNumber,
                    onTap: () {},
                    color: CUSTOM_BLUE.withOpacity(0.1),
                    errorText: null,
                    // exclusiveId: 0,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 25,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: CUSTOM_BLACK.withOpacity(0.3)),
                        ),
                        child: Center(child: Text('기준측정')),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 5),
                    child: Container(
                      width: 0.5,
                      height: 620,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: CUSTOM_BLACK.withOpacity(0.3)),
                    ),
                    child: Center(child: Text('비교측정')),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

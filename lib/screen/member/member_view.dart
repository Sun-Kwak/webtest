import 'package:flutter/material.dart';
import 'package:web_test2/screen/member/widget/member_infor_form.dart';
import 'package:web_test2/screen/member/widget/member_input_form.dart';
import 'package:web_test2/screen/member/widget/member_search_form.dart';
import 'package:web_test2/screen/member/widget/member_voc_form.dart';

class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => MembersViewState();
}

class MembersViewState extends State<MembersView> {
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
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
                        MemberInputForm(),
                        SizedBox(
                          height: 20,
                        ),
                        MemberInforForm(),
                        if (screenWidth < 640) ...[
                          const SizedBox(
                            height: 20,
                          ),
                          const MemberSearchForm(),
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
                  const MemberSearchForm(),
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
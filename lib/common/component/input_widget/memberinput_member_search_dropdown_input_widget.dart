import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/const/colors.dart';

class MemberInputMemberSearchDropdownWidget extends StatelessWidget {
  final String? selectedValue;
  // final ValueChanged<String?>? onChanged;

  final double? height;
  final bool? isRequired;
  final String label;
  final String? hintText;
  final double? labelBoxWidth;
  final double? textBoxWidth;

  const MemberInputMemberSearchDropdownWidget({

    this.labelBoxWidth = 50,
    this.textBoxWidth = 170,
    // required this.onChanged,
    required this.selectedValue,
    this.hintText,
    required this.label,
    this.isRequired = false,
    this.height = 37,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: labelBoxWidth,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  // style: TextStyle(fontSize: height! * 0.35),
                ),
              ],
            )),
        SizedBox(
          width: 10,
          height: height,
          child: Center(
            child: isRequired == true
                ? const Text('*', style: TextStyle(color: CUSTOM_RED))
                : null,
          ),
        ),
        SizedBox(
          width: textBoxWidth,
          height: height,
          child: CustomSearchDropdownFormField(
            selectedValue: selectedValue,

            hintText: '검색',
            // onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class CustomSearchDropdownFormField extends ConsumerStatefulWidget {
  final String hintText;
  final String? errorText;
  // final ValueChanged<String?>? onChanged;
  final FocusNode? focusNode;
  final FocusNode? onFieldSubmitted;
  final double? height;
  final double? textBoxWidth;
  final String? selectedValue;

  const CustomSearchDropdownFormField({
    this.selectedValue,
    this.textBoxWidth,
    this.height = 40,
    this.focusNode,
    this.onFieldSubmitted,
    // required this.onChanged,
    required this.hintText,
    this.errorText,
    super.key,
  });

  @override
  ConsumerState<CustomSearchDropdownFormField> createState() =>
      _CustomSearchDropdownFormFieldState();
}

class _CustomSearchDropdownFormFieldState
    extends ConsumerState<CustomSearchDropdownFormField> {

  late GlobalKey actionKey;
  late double boxHeight, boxWidth, xPosition, yPosition;
  bool isDropdownOpened = false;
  String? selectedValue;
  late OverlayEntry floatingDropdown;
  final layerLink = LayerLink();
  late List<Member> members;
  late List<Member> displayedMembers;
  late List<Member> filteredMembers;


  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.hintText);
   members = [];
    displayedMembers = [];
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomSearchDropdownFormField oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.selectedValue != oldWidget.selectedValue || selectedValue != widget.selectedValue){
      setState(() {

        selectedValue = widget.selectedValue;
      });
    }
  }

  void findDropdownData(){
    RenderBox renderBox = actionKey.currentContext?.findRenderObject() as RenderBox;
    boxHeight = renderBox.size.height;
    boxWidth = renderBox.size.width;

  }

  OverlayEntry _showFloatingDropdown() {
    members = ref.watch(membersProvider);
    final selectedMember = ref.watch(selectedMemberProvider);
    final selectedMemberId = selectedMember.id;
    // final selectedReferralId = ref.watch(selectedReferralIDProvider.notifier);
    displayedMembers = members.where((member) => member.id != selectedMemberId).toList();;
    filteredMembers = displayedMembers;

    return OverlayEntry(builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          floatingDropdown.remove();
          isDropdownOpened = false;
        },
        child: CompositedTransformFollower(
          link: layerLink,
          offset: Offset(0,boxHeight +10),
          showWhenUnlinked: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                child: SizedBox(
                  width: boxWidth,
                  child: TextField(
                    autofocus: true,
                    onChanged: searchMember,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search,color: CONSTRAINT_PRIMARY_COLOR,),
                      hintText: '이름 또는 전화번호',
                      hintStyle: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  height: 380,
                  width: boxWidth,
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index){
                      return const Divider();
                    },
                    itemCount: filteredMembers.length,
                      itemBuilder: (BuildContext context, int index){
                        Member member = filteredMembers[index];
                    return Material(
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          child: Column(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: TABLE_SELECTION_COLOR,
                                ),
                                child: const Icon(Icons.person),
                              ),
                              Center(child: Text(member.id.toString(),style: const TextStyle(color: PRIMARY_COLOR),)),
                            ],
                          ),
                        ),
                        title: Text(member.displayName),
                        subtitle: Text(member.phoneNumber,style: const TextStyle(fontSize: 9),),
                        onTap: (){
                          setState(() {
                            selectedValue = member.displayName;
                            // selectedReferralId.setSelectedReferralID(member.id, member.displayName);
                            floatingDropdown.remove();
                            isDropdownOpened = false;
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          )
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return CompositedTransformTarget(
      link: layerLink,
      child: SizedBox(
        width: widget.textBoxWidth,
        height: widget.height,
        child: GestureDetector(
          key: actionKey,
          onTap: () {
            setState(() {
              if(isDropdownOpened){
                floatingDropdown.remove();
              } else {
                findDropdownData();
                floatingDropdown = _showFloatingDropdown();
                Overlay.of(context).insert(floatingDropdown);
              }
              isDropdownOpened = !isDropdownOpened;
            });
          },
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(widget.height! * 0.1),
              border: baseBorder,
              enabledBorder: baseBorder,
              suffixIcon: const Icon(Icons.search_outlined,color: CONSTRAINT_PRIMARY_COLOR,),
              focusedBorder: baseBorder.copyWith(
                borderSide: const BorderSide(
                  color: PRIMARY_COLOR,
                ),
              ),
            ),
            child: selectedValue == null ? Text(widget.hintText,style: const TextStyle(color: CONSTRAINT_PRIMARY_COLOR),) : Text(selectedValue!.toString()),
          ),
        ),
      ),
    );
  }

  void searchMember(String query) {

      List<Member> filteringMembers = displayedMembers.where((member) {
        return member.phoneNumber.contains(query) ||
            member.displayName.contains(query);
      }).toList();

      setState(() {
        filteredMembers = filteringMembers;
        // displayedMembers = filteredMembers;
      });
  }
}

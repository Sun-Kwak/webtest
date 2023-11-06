import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/common/component/size_fade_switcher.dart';
import 'package:web_test2/common/const/colors.dart';

class CustomSearchDropdownWidget<T, U> extends StatelessWidget {
  final List<T> list;
  final String? selectedValue;
  final U? exclusiveId;
  final Color? color;
  final bool? showId;
  final String? errorText;
  // final ValueChanged<String?>? onChanged;

  final double? height;
  final bool? isRequired;
  final String label;
  final String? hintText;
  final double? labelBoxWidth;
  final double? textBoxWidth;
  final GestureTapCallback onTap;
  final U Function(T) idSelector;
  final String Function(T) titleSelector;
  final String Function(T) subtitleSelector;

  const CustomSearchDropdownWidget({
    required this.errorText,
    this.showId = false,
    this.color,
    required this.titleSelector,
    required this.subtitleSelector,
    required this.idSelector,
    required this.onTap,
    this.exclusiveId,
    required this.list,
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
        Column(
          children: [
            SizedBox(
              width: textBoxWidth,
              height: height,
              child: CustomSearchDropdownFormField(
                selectedValue: selectedValue,
                list: list,
                hintText: hintText,
                onTap: (){onTap();},
                idSelector: idSelector,
                titleSelector: titleSelector,
                subtitleSelector: subtitleSelector,
                color: color,
                showId: showId,
                exclusiveId: exclusiveId,
                // onChanged: onChanged,
              ),
            ),
            SizeFadeSwitcher(
              child: errorText != null ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ): const SizedBox.shrink(),
            )

          ],
        ),
      ],
    );
  }
}

class CustomSearchDropdownFormField<T, U> extends ConsumerStatefulWidget {
  final String? hintText;
  final Color? color;
  final bool? showId;

  // final ValueChanged<String?>? onChanged;
  final FocusNode? focusNode;
  final FocusNode? onFieldSubmitted;
  final double? height;
  final double? textBoxWidth;
  final String? selectedValue;
  final List<T> list;
  final GestureTapCallback onTap;
  final U Function(T) idSelector;
  final String Function(T) titleSelector;
  final String Function(T) subtitleSelector;
  final U? exclusiveId;

  const CustomSearchDropdownFormField({
    this.showId = false,
    this.color,
    this.exclusiveId,
    required this.titleSelector,
    required this.subtitleSelector,
    required this.idSelector,
    required this.onTap,
    required this.list,
    this.selectedValue,
    this.textBoxWidth,
    this.height = 40,
    this.focusNode,
    this.onFieldSubmitted,
    // required this.onChanged,
    this.hintText,
    super.key,
  });


  @override
  ConsumerState<CustomSearchDropdownFormField<T, U>> createState() =>
      CustomSearchDropdownFormFieldState<T, U>();
}

class CustomSearchDropdownFormFieldState<T, U>
    extends ConsumerState<CustomSearchDropdownFormField<T, U>> {

  late GlobalKey actionKey;
  late double boxHeight, boxWidth, xPosition, yPosition;
  bool isDropdownOpened = false;
  String? selectedValue;
  late OverlayEntry floatingDropdown;
  final layerLink = LayerLink();
  late List<T> _list;
  // late T? partId;
  late String partTitle;
  late List<T> _displayedList;
  late List<T> _filteredList;


  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.hintText);
    // partId = null;
    partTitle = '';
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomSearchDropdownFormField<T, U> oldWidget) {
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

    _list = widget.list;
    _displayedList = _list.where((e) => widget.idSelector(e) != widget.exclusiveId).toList();
    _filteredList = _displayedList;

    return OverlayEntry(builder: (context) {
      // var setProvider = SelectedDropdownIDProvider(
      //   initialId: widget.idSelector,
      //   initialTitle: partTitle,
      // );
      final selectedDropdownData = ref.watch(selectedDropdownIDProvider.notifier);
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
                    decoration:  InputDecoration(
                      prefixIcon: Icon(Icons.search,color: CONSTRAINT_PRIMARY_COLOR,),
                      hintText: widget.hintText,
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
                    itemCount: _filteredList.length,
                      itemBuilder: (BuildContext context, int index){
                       var part = _filteredList[index];
                    return Material(
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              widget.showId == false ? SizedBox() : Center(child: Text(widget.idSelector!(part).toString(),style: const TextStyle(color: PRIMARY_COLOR),)),
                            ],
                          ),
                        ),
                        title: Text(widget.titleSelector(part)),
                        subtitle: Text(widget.subtitleSelector(part),style: const TextStyle(fontSize: 9),),
                        onTap: (){
                          setState(() {
                            selectedValue = widget.titleSelector(part);
                            selectedDropdownData.setData(
                              widget.titleSelector(part), widget.idSelector(part)
                            );
                          });
                          widget.onTap();
                          floatingDropdown.remove();
                          isDropdownOpened = false;
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
    String hintText = widget.hintText ?? '';

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
              filled: widget.color == null ? false : true,
              fillColor: widget.color,
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
            child: selectedValue == null ? Text(hintText,style: const TextStyle(color: CONSTRAINT_PRIMARY_COLOR),) : Text(selectedValue!.toString()),
          ),
        ),
      ),
    );
  }

  void searchMember(String query) {

    List<T> filteringList = _displayedList.where((e) {
        return widget.titleSelector(e).contains(query) ||
            widget.subtitleSelector(e).contains(query);
      }).toList();

      setState(() {
        _filteredList = filteringList;
        // displayedMembers = filteredMembers;
      });
  }
}

// class DropdownData<T, U> {
//   final U? id;
//   final String title;
//
//   DropdownData({required this.id, required this.title});
// }

class SelectedDropdownIDProvider<U> extends ChangeNotifier {
  U selectedId;
 String? selectedTitle;

  SelectedDropdownIDProvider({required String? initialTitle, required U initialId})
      :
        selectedTitle = initialTitle,
        selectedId = initialId;

  void setData(String? title, U id) {
    selectedTitle = title;
    selectedId = id;
    notifyListeners(); // 상태가 변경됨을 알림
  }
}

final selectedDropdownIDProvider = ChangeNotifierProvider<SelectedDropdownIDProvider>((ref) {
  return SelectedDropdownIDProvider(
      initialTitle: null,
    initialId: (U) => null// 초기 ID 로직을 여기에 추가
  );
});

// class SelectedDropdownIDProvider<T, U> extends ChangeNotifier {
//   U? id;
//   String title;
//
//   SelectedDropdownIDProvider({U? initialId, required String initialTitle})
//       : id = initialId,
//         title = initialTitle;
//
//   DropdownData<T, U> getValues() {
//     return DropdownData<T, U>(
//       id: id,
//       title: title,
//     );
//   }
//
//   void setValues({U? newId, required String newTitle}) {
//     id = newId;
//     title = newTitle;
//     notifyListeners(); // 상태가 변경됨을 알림
//   }
// }
//
// final selectedDropdownIDProvider = ChangeNotifierProvider<SelectedDropdownIDProvider>((ref) {
//   return SelectedDropdownIDProvider(
//     initialId: (T) => null , // 초기 ID 로직을 여기에 추가
//     initialTitle: '',
//   );
// });



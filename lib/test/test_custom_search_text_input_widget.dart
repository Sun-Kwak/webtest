// import 'package:flutter/material.dart';
// import 'package:web_test2/common/const/colors.dart';
//
// class CustomSearchTextInputWidget extends StatefulWidget {
//   final double? height;
//   final double? labelBoxWidth;
//   final double? textBoxWidth;
//   final String label;
//   final bool? isRequired;
//
//   const CustomSearchTextInputWidget({
//     this.isRequired = false,
//     required this.label,
//     this.height = 37,
//     this.labelBoxWidth = 60,
//     this.textBoxWidth = 170,
//     super.key});
//
//   @override
//   CustomSearchTextInputWidgetState createState() => CustomSearchTextInputWidgetState();
// }
//
// class CustomSearchTextInputWidgetState extends State<CustomSearchTextInputWidget> {
//   String? _searchedDate;
//
//   Future<void> _searchDate(BuildContext context) async {
//     //파이어베이스 검색
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const baseBorder = OutlineInputBorder(
//         borderSide: BorderSide(
//           color: INPUT_BORDER_COLOR,
//           width: 1.0,
//         ));
//     return Row(
//       children: <Widget>[
//         SizedBox(
//             width: widget.labelBoxWidth,
//             height: widget.height,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   widget.label,
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               ],
//             )),
//         SizedBox(
//           width: 3,
//           height:widget.height,
//           child: Center(
//             child: widget.isRequired == true ? const Text('*',style: TextStyle(color: Colors.redAccent)) : null,
//           ),
//         ),
//         const SizedBox(width: 8),
//         InkWell(
//           onTap: () {
//             _searchDate(context);
//           },
//           child: Row(
//             children: [
//               SizedBox(
//                 width:  widget.textBoxWidth,
//                 height: 40,
//                 child: InputDecorator(
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(left: widget.height! * 0.1, top: widget.height! * 0.1),
//                     filled: true,
//                     fillColor: INPUT_BG_COLOR,
//                     //errorText: errorText,
//                     border: baseBorder,
//                     enabledBorder: baseBorder,
//                     focusedBorder: baseBorder.copyWith(
//                       borderSide: const BorderSide(
//                         color: PRIMARY_COLOR,
//                       ),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       _searchedDate != null
//                           ? Text(
//                         '$_searchedDate',
//                       )
//                           : const Text('검색',style: TextStyle(
//                         color: CONSTRAINT_PRIMARY_COLOR,
//                         fontSize: 12,
//                       ),),
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Icon(Icons.search_outlined,color: PRIMARY_COLOR,),
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

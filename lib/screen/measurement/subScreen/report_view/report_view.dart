import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/appointment_input_form.dart';
import 'package:web_test2/screen/measurement/subScreen/measurement&appointment_view/widget/measurement_input_form.dart';
import 'package:web_test2/screen/measurement/subScreen/report_view/widget/report_filter_form.dart';
import 'package:web_test2/screen/measurement/subScreen/report_view/widget/report_form.dart';
import 'package:screenshot/screenshot.dart';
import 'package:web_test2/screen/measurement/subScreen/report_view/widget/report_pdf.dart';

class ReportView extends ConsumerStatefulWidget {

  const ReportView({ super.key});

  @override
  ConsumerState<ReportView> createState() =>
      ReportViewState();
}

class ReportViewState
    extends ConsumerState<ReportView> {

  // ScreenshotController screenshotController = ScreenshotController();
  //
  //
  // void displayImage(Uint8List? imageBytes) {
  //
  //   if(imageBytes != null){
  //   // 이미지를 웹 페이지에 추가
  //   html.ImageElement imageElement = html.ImageElement(
  //       src: 'data:image/png;base64,${base64.encode(imageBytes)}');
  //   html.document.body?.children.add(imageElement);}
  // }
  void _openNewTab() {
    // 새로운 탭에서의 URL을 설정합니다.
    final newTabUrl = '/#/report';
    html.window.open('/#/report',"_self");

    Timer(Duration(seconds: 1), () {
      html.window.print();
    });
  }


  @override
  Widget build(BuildContext context) {
    final selectedMeasurementState = ref.watch(selectedMeasurementProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportForm(),
        SizedBox(
          width: 10,
        ),
        ReportFilterForm(
          onTap: ()  {
            print(selectedMeasurementState.docId);
            if(selectedMeasurementState.docId != ''){
            _openNewTab();}
              // 예: html.document.body.append(Element.div()..text = 'Hello, New Tab!');

              // Report 클래스의 다른 작업 수행

          },
        ),
      ],
    );
  }
}

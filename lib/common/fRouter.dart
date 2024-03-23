import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:web_test2/screen/measurement/subScreen/report_view/widget/report_url.dart';

class DetailsPage extends StatelessWidget {
  final List<String> documentIds;

  const DetailsPage({Key? key, required this.documentIds}) : super(key: key);

  Future<Map<String, dynamic>> fetchData(List<String> documentIds) async {
    final firstMeasurementSnapshot = await FirebaseFirestore.instance
        .collection('measurements')
        .doc(documentIds[0])
        .get();
    final Measurement firstMeasurement =
    Measurement.fromFirestore(firstMeasurementSnapshot);


    Measurement secondMeasurement = Measurement.empty();

    if (documentIds.length > 1 && documentIds[1].isNotEmpty) {
      final secondMeasurementSnapshot = await FirebaseFirestore.instance
          .collection('measurements')
          .doc(documentIds[1])
          .get();
      secondMeasurement = Measurement.fromFirestore(secondMeasurementSnapshot);
    }

    // Find the member document where 'id' field matches measurement.memberId
    final memberSnapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('id', isEqualTo: firstMeasurement.memberId)
        .limit(1)
        .get();
    // Assuming 'id' is a unique identifier in the 'members' collection
    final member = Member.fromFirestore(memberSnapshot.docs[0]);

    return {
      'firstMeasurement': firstMeasurement,
      'secondMeasurement': secondMeasurement,
      'member': member,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async => false,
          child: FutureBuilder<Map<String, dynamic>>(
      future: fetchData(documentIds),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('asset/lottie/initial.json',
                  height: 400, width: 400),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final Measurement baseline = snapshot.data!['firstMeasurement'];
            final Measurement compare = snapshot.data!['secondMeasurement'];
            final Member member = snapshot.data!['member'];

            return ReportUrlForm(
              baseline: baseline,
              compare: compare,
              member: member,
            );
          }
      },
    ),
        ));
  }
}

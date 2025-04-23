import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class OutputData {
  final String scientificName;
  final String ayurvedicName;
  final String healthBenefits;
  final String medicinalProperties;
  final String usageAndPreparation;
  final String dosageAndRecommendation;
  final String additionalInformation;

  OutputData({
    required this.scientificName,
    required this.ayurvedicName,
    required this.healthBenefits,
    required this.medicinalProperties,
    required this.usageAndPreparation,
    required this.dosageAndRecommendation,
    required this.additionalInformation,
  });
}

class OutputPage extends StatelessWidget {
  final dynamic responseData;
  OutputPage({Key? key, required this.responseData}) : super(key: key);

  FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    String predictedClass = responseData['predicted_class'];
    double probability = 0.0;
    final ref = database.ref();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction'),
      ),
      body: Center(
        child: FutureBuilder<OutputData>(
          future: getData(ref, predictedClass),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    'Predicted Class',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    predictedClass,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Divider(),
                  // const Text(
                  //   'Probability of Prediction',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18.0,
                  //   ),
                  // ),
                  // const SizedBox(height: 8.0),
                  // Text(
                  //   '${responseData['probability']}',
                  //   style: const TextStyle(
                  //     fontSize: 16.0,
                  //     fontStyle: FontStyle.italic,
                  //   ),
                  // ),
                  // const Divider(),
                  buildFieldRow('Scientific Name', data.scientificName),
                  buildFieldRow('Ayurvedic Name', data.ayurvedicName),
                  buildFieldRow('Health Benefits', data.healthBenefits),
                  buildFieldRow('Medicinal Properties', data.medicinalProperties),
                  buildFieldRow('Usage and Preparation', data.usageAndPreparation),
                  buildFieldRow('Dosage and Recommendation', data.dosageAndRecommendation),
                  buildFieldRow('Additional Information', data.additionalInformation),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Text('No data available.');
            }
          },
        ),
      ),
    );
  }


  Future<OutputData> getData(DatabaseReference ref, String predictedClass) async {
    String leafName = predictedClass;
    final snapshot = await ref.child(leafName).get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return OutputData(
        scientificName: data['Scientific Name'] ?? '',
        ayurvedicName: data['Ayurvedic Name'] ?? '',
        healthBenefits: data['Health Benefits'] ?? '',
        medicinalProperties: data['Medicinal Properties'] ?? '',
        usageAndPreparation: data['Usage and Preparation'] ?? '',
        dosageAndRecommendation: data['Dosage and Recommendation'] ?? '',
        additionalInformation: data['Additional Information'] ?? '',
      );
    } else {
      return OutputData(
        scientificName: '',
        ayurvedicName: '',
        healthBenefits: '',
        medicinalProperties: '',
        usageAndPreparation: '',
        dosageAndRecommendation: '',
        additionalInformation: '',
      );
    }
  }

  Widget buildFieldRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            value ?? 'N/A',
            textAlign: TextAlign.justify,  // Set the text alignment to justify
            style: GoogleFonts.openSans(fontSize: 16.0),
          ),
        ),
        const Divider(),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/widgets/header_part.dart';
import 'package:urinova/widgets/homepage/test_schedule_card.dart';
import 'package:urinova/widgets/homepage/risk_alert_card.dart';
import 'package:urinova/widgets/homepage/biomarker_card.dart';
import 'package:urinova/providers/profile_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final List<Map<String, dynamic>> biomarkers = [
      {"name": "Specific Gravity", "value": "1.015", "color": Colors.green},
      {"name": "pH", "value": "6.5", "color": Colors.green},
      {"name": "Nitrites", "value": "Neg.", "color": Colors.green},
      {
        "name": "Ketones",
        "value": "5 (0.5)",
        "color": Colors.orange
      }, // Slightly high
      {"name": "Bilirubin", "value": "Neg.", "color": Colors.green},
      {
        "name": "Urobilinogen",
        "value": "+",
        "color": Colors.orange
      }, // Slight elevation
      {"name": "Protein", "value": "7 (70)", "color": Colors.red}, // High
      {
        "name": "Glucose",
        "value": "30 (0.3)",
        "color": Colors.orange
      }, // Moderate risk
      {
        "name": "Blood/Hemoglobin",
        "value": "Neg.",
        "color": Colors.green
      }, // High concern
      {
        "name": "Leukocytes",
        "value": "ca. 50",
        "color": Colors.red
      }, // High concern
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 238),
      body: ListView(
        padding: EdgeInsets.only(top: 56, left: 25, right: 25),
        children: [
          HeaderPart(name: "Hello, ${profileProvider.name} 👋"),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TestScheduleCard(),
              SizedBox(width: 5),
              RiskAlertCard(),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 1095,
            child: OverflowBox(
              maxWidth: MediaQuery.of(context).size.width,
              child: Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(42))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 75,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      SizedBox(height: 28),
                      Text(
                        'Recent Biomarkers Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Work Sans',
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 22),
                      Column(
                        children: biomarkers
                            .map((b) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 12.0), // Add spacing
                                  child: BiomarkerCard(
                                    name: b["name"],
                                    value: b["value"],
                                    color: b["color"],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

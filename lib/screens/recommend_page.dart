import 'package:flutter/material.dart';
import 'package:urinova/widgets/header_part.dart';

class RecommendPage extends StatelessWidget {
  const RecommendPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.only(top: 56, left: 25, right: 25),
        child: Column(
          children: [
            HeaderPart(
              name: 'Your Personalized 👹\n Recommendations',
              fontSize: 18,
            ),
            SizedBox(
              height: 72,
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: 420,
                  height: 500,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(22)),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...biomarkers.map((b) => Text(
                            b["name"],
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Work Sans',
                                letterSpacing: -1,
                                color: b["color"]),
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 420,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 162, 82),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(22)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 6),
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Text(
                        'View Recommendation',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Work Sans',
                            letterSpacing: -1,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

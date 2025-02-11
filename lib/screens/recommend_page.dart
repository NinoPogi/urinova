import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/widgets/header_part.dart';

class RecommendPage extends StatelessWidget {
  const RecommendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final hasHistory = biomarkerProvider.history.isNotEmpty;

    Color getSeverityColor(int value) {
      if (value <= 1) return Colors.green;
      if (value <= 3) return Colors.orange;
      return Colors.red;
    }

    final List<Map<String, dynamic>> biomarkers = hasHistory
        ? biomarkerProvider.biomarkers.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            final color = getSeverityColor(value);
            return {
              "name": biomarkerNames[index],
              "value": biomarkerValues[index][value],
              "color": color,
            };
          }).toList()
        : [];

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
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough),
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

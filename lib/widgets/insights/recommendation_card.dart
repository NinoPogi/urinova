import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final Map<String, String> rec;

  RecommendationCard(this.rec);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rec['biomarker']!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              rec['text']!,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              "Trend: ${rec['trend']}",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 4),
            Text(
              "Dietary advice: ${rec['dietary']}",
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

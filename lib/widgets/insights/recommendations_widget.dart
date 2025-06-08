import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/biomarker_provider.dart';

class RecommendationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recommendations =
        Provider.of<BiomarkerProvider>(context).getRecommendations();
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalized Recommendations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (recommendations.isEmpty)
            Text("No recommendations at this time.")
          else
            ...recommendations
                .map((rec) => Text('- $rec', style: TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';

class RecommendationModal extends StatelessWidget {
  const RecommendationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final hasHistory = biomarkerProvider.history.isNotEmpty;
    final recommendations =
        hasHistory ? biomarkerProvider.getRecommendations() : [];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Personalized Recommendations',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          hasHistory
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recommendations
                      .map((rec) =>
                          Text('- $rec', style: TextStyle(fontSize: 18)))
                      .toList(),
                )
              : Text(
                  "No recommendation yet. Conduct a test first.",
                  style: TextStyle(fontSize: 18),
                ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}

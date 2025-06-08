import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';

class RecommendationsWidget extends StatefulWidget {
  @override
  _RecommendationsWidgetState createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> {
  bool showAll = false;
  final trendEmojis = {
    "increasing": "📈",
    "decreasing": "📉",
    "stable": "➖",
  };

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final recommendations = biomarkerProvider.getRecommendations();
    if (recommendations.isEmpty) {
      return Center(child: Text("No recommendations available"));
    }
    final latestValues = biomarkerProvider.biomarkers;
    List<int> importantIndices = latestValues
        .asMap()
        .entries
        .where((entry) => entry.value >= 2)
        .map((entry) => entry.key)
        .toList();
    List<Map<String, dynamic>> filteredRecommendations = showAll
        ? recommendations
        : recommendations
            .where((rec) => importantIndices
                .contains(biomarkerNames.indexOf(rec["biomarker"])))
            .toList();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalized Recommendations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (filteredRecommendations.isEmpty)
            Text("No concerning recommendations")
          else
            ...filteredRecommendations.map((rec) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rec["biomarker"],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text(trendEmojis[rec["trend"]] ?? "➖",
                            style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Expanded(child: Text(rec["trendReco"])),
                      ],
                    ),
                    Row(
                      children: [
                        Text("🍎", style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Expanded(child: Text(rec["dietaryReco"])),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                )),
          TextButton(
            onPressed: () => setState(() => showAll = !showAll),
            child: Text(showAll ? "Hide" : "Show all"),
          ),
        ],
      ),
    );
  }
}

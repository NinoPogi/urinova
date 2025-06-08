import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';

class RecommendationModal extends StatefulWidget {
  const RecommendationModal({super.key});

  @override
  _RecommendationModalState createState() => _RecommendationModalState();
}

class _RecommendationModalState extends State<RecommendationModal> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final hasHistory = biomarkerProvider.history.isNotEmpty;
    final recommendations =
        hasHistory ? biomarkerProvider.getRecommendations() : [];

    // Calculate severity for each recommendation
    List<Map> recommendationsWithSeverity = recommendations.map((rec) {
      int index = biomarkerNames.indexOf(rec['biomarker']);
      int level = rec['level'];
      String severity = (index != -1 &&
              level >= 0 &&
              level < biomarkerSeverities[index].length)
          ? biomarkerSeverities[index][level]
          : 'Unknown';
      return {...rec, 'severity': severity};
    }).toList();

    // Separate recommendations based on severity
    List<Map> importantRecos = recommendationsWithSeverity
        .where(
            (rec) => rec['severity'] != 'Green' && rec['severity'] != 'Unknown')
        .toList();

    List<Map> greenRecos = recommendationsWithSeverity
        .where((rec) => rec['severity'] == 'Green')
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalized Recommendations',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (!hasHistory)
              const Text(
                'No recommendation yet. Conduct a test first.',
                style: TextStyle(fontSize: 18),
              )
            else if (importantRecos.isEmpty && !showAll)
              const Text(
                'All biomarkers are normal.',
                style: TextStyle(fontSize: 18),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (importantRecos.isNotEmpty) ...[
                    ...importantRecos.map(
                      (rec) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '• ${rec['biomarker'] + ": " + rec['personalizedReco']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (showAll && greenRecos.isNotEmpty) ...[
                    const Text(
                      'Others:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...greenRecos.map(
                      (rec) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '• ${rec['biomarker'] + ": " + rec['personalizedReco']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            if (hasHistory && greenRecos.isNotEmpty) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                child: Text(showAll ? "Show less" : "Show more"),
              ),
            ],
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 162, 82),
              ),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

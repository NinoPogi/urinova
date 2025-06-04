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
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Personalized Recommendations',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          hasHistory
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recommendations
                      .map((rec) =>
                          Text('- $rec', style: const TextStyle(fontSize: 18)))
                      .toList(),
                )
              : const Text('No recommendation yet. Conduct a test first.',
                  style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 162, 82)),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

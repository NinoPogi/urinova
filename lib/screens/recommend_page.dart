import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/constants/biomarker_constant.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/widgets/header_part.dart';
import 'package:urinova/widgets/recommend/recommendation_modal.dart';

class RecommendPage extends StatelessWidget {
  final VoidCallback onNavigateToProfile;

  const RecommendPage({super.key, required this.onNavigateToProfile});

  void _showRecommendationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const RecommendationModal();
      },
    );
  }

  Color getSeverityColor(int biomarkerIndex, int valueIndex) {
    if (valueIndex < 0 ||
        valueIndex >= biomarkerSeverities[biomarkerIndex].length) {
      return Colors.grey;
    }
    String severity = biomarkerSeverities[biomarkerIndex][valueIndex];
    switch (severity) {
      case 'Green':
        return Colors.green;
      case 'Yellow':
        return Colors.yellow;
      case 'Orange':
        return Colors.orange;
      case 'Red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final hasHistory = biomarkerProvider.history.isNotEmpty;

    final List<Map<String, dynamic>> biomarkers = hasHistory
        ? biomarkerProvider.biomarkers.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final value =
                  entry.value.clamp(0, biomarkerValues[index].length - 1);
              final color = getSeverityColor(index, value);
              return {
                "name": biomarkerNames[index],
                "value": biomarkerValues[index][value],
                "color": color,
              };
            },
          ).toList()
        : [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 210, 206),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.07,
          left: MediaQuery.of(context).size.width * 0.06,
          right: MediaQuery.of(context).size.width * 0.06,
        ),
        child: Column(
          children: [
            HeaderPart(
                name: 'Your Personalized ⛑️\n Recommendations',
                fontSize: 18,
                onNavigateToProfile: onNavigateToProfile),
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  color: Colors.white,
                ),
                child: hasHistory
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: biomarkers
                            .map(
                              (b) => Text(
                                b["name"],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Work Sans',
                                  letterSpacing: -1,
                                  color: b["color"],
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : Center(
                        child: Text(
                          "Conduct test first",
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Work Sans',
                            letterSpacing: -1,
                          ),
                        ),
                      ),
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.08,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
              child: GestureDetector(
                onTap: () => _showRecommendationModal(context),
                child: Center(
                  child: Text(
                    'View Recommendation',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          ],
        ),
      ),
    );
  }
}

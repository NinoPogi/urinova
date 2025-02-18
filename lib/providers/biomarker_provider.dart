import 'package:flutter/material.dart';
import 'package:urinova/constants/biomarker_constant.dart';

class BiomarkerProvider with ChangeNotifier {
  List<int> _biomarkers = [];
  List<List<int>> _history = [];

  List<int> get biomarkers => _biomarkers;
  List<List<int>> get history => _history;

  void updateBiomarkers(List<int> newBiomarkers) {
    _biomarkers = newBiomarkers;
    _history.add(List.from(newBiomarkers));
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  int getRiskWeight(int biomarkerIndex, int valueIndex) {
    if (valueIndex == 0) return 1;
    if (valueIndex <= 2) return 2;
    return 3;
  }

  int getTrendWeight(int biomarkerIndex) {
    if (_history.length < 2) return 1;
    int latest = _biomarkers[biomarkerIndex];
    int previous = _history[_history.length - 2][biomarkerIndex];
    if (latest > previous) return 3;
    if (latest < previous) return 2;
    return 1;
  }

  List<String> getRecommendations() {
    if (_history.isEmpty) return [];

    Map<String, String> finalAdvice = {};
    for (int i = 0; i < _biomarkers.length; i++) {
      int riskWeight = getRiskWeight(i, _biomarkers[i]);
      int trendWeight = getTrendWeight(i);
      int urgencyScore = riskWeight * trendWeight;
      if (urgencyScore > 1) {
        String biomarker = biomarkerNames[i];
        String rec =
            recommendationTable[biomarker]?["$riskWeight"] ?? "Monitor";
        if (!finalAdvice.containsKey(biomarker) || urgencyScore > 3) {
          finalAdvice[biomarker] = rec;
        }
      }
    }

    return finalAdvice.entries.map((e) => "${e.key}: ${e.value}").toList();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urinova/constants/biomarker_constant.dart';

class BiomarkerProvider with ChangeNotifier {
  List<int> _biomarkers = List.filled(10, 0);
  List<List<int>> _history = [];
  String? _loadingProfileId;

  List<int> get biomarkers => _biomarkers;
  List<List<int>> get history => _history;
  String? get loadingProfileId => _loadingProfileId;

  Future<void> loadHistoryForProfile(String userId, String profileId) async {
    _loadingProfileId = profileId;
    notifyListeners();
    try {
      final testsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .collection('tests')
          .orderBy('date')
          .get();
      _history = testsSnapshot.docs.map((doc) {
        final data = doc.data();
        List<int> biomarkers = List<int>.from(data['biomarkers']);
        while (biomarkers.length < 10) {
          biomarkers.add(0);
        }
        return biomarkers.take(10).toList();
      }).toList();
      if (_history.isNotEmpty) {
        _biomarkers = _history.last;
      } else {
        _biomarkers = List.filled(10, 0);
      }
    } catch (e) {
      print('Error loading history: $e');
      _history = [];
      _biomarkers = List.filled(10, 0);
    } finally {
      _loadingProfileId = null;
      notifyListeners();
    }
  }

  void updateBiomarkers(List<int> newBiomarkers) {
    const int expectedLength = 10;
    _biomarkers = newBiomarkers.take(expectedLength).toList();
    while (_biomarkers.length < expectedLength) {
      _biomarkers.add(0);
    }
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
    return finalAdvice.isEmpty
        ? [
            "All your biomarkers are within normal ranges. Continue maintaining a healthy lifestyle!"
          ]
        : finalAdvice.entries.map((e) => "${e.key}: ${e.value}").toList();
  }
}

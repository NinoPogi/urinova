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

  String getTrend(int biomarkerIndex) {
    if (_history.length < 2) return "stable";
    int latest = _biomarkers[biomarkerIndex];
    int previous = _history[_history.length - 2][biomarkerIndex];
    if (latest > previous) return "increasing";
    if (latest < previous) return "decreasing";
    return "stable";
  }

  List<Map<String, dynamic>> getRecommendations() {
    if (_history.isEmpty) return [];
    List<Map<String, dynamic>> recommendations = [];
    for (int i = 0; i < _biomarkers.length; i++) {
      String biomarker = biomarkerNames[i];
      int level = _biomarkers[i];
      String trend = getTrend(i);
      String personalizedReco =
          personalizedRecos[biomarker]?[level] ?? "Monitor";
      String trendReco = trendRecos[biomarker]?[trend] ?? "Continue monitoring";
      String dietaryReco =
          dietaryRecos[biomarker]?[trend] ?? "Maintain current diet";
      int weight = biomarkerWeights[biomarker] ?? 1;
      recommendations.add({
        "biomarker": biomarker,
        "level": level,
        "trend": trend,
        "personalizedReco": personalizedReco,
        "trendReco": trendReco,
        "dietaryReco": dietaryReco,
        "weight": weight,
        "text": "$personalizedReco. Trend: $trend. $trendReco",
      });
    }
    recommendations.sort((a, b) => b["weight"].compareTo(a["weight"]));
    return recommendations;
  }
}

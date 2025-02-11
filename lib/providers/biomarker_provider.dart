import 'package:flutter/material.dart';

class BiomarkerProvider with ChangeNotifier {
  List<int> _biomarkers = [];
  List<List<int>> _history = [];

  List<int> get biomarkers => _biomarkers;
  List<List<int>> get history => _history;

  void updateBiomarkers(List<int> newBiomarkers) {
    _biomarkers = newBiomarkers;
    _history.add(newBiomarkers);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}

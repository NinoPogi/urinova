import 'package:flutter/material.dart';

class BiomarkerProvider with ChangeNotifier {
  List<int> _biomarkers = [];

  List<int> get biomarkers => _biomarkers;

  void updateBiomarkers(List<int> newBiomarkers) {
    _biomarkers = newBiomarkers;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class BiomarkerProvider with ChangeNotifier {
  List<String> _biomarkers = [];

  List<String> get biomarkers => _biomarkers;

  void updateBiomarkers(List<String> newBiomarkers) {
    _biomarkers = newBiomarkers;
    notifyListeners();
  }
}

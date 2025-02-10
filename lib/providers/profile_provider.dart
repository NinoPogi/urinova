import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String _name = "User";

  String get name => _name;

  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }
}

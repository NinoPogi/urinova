import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  List<Map<String, dynamic>> _profiles = [];
  Map<String, dynamic>? _currentProfile;

  User? get user => _user;
  List<Map<String, dynamic>> get profiles => _profiles;
  Map<String, dynamic>? get currentProfile => _currentProfile;

  UserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      if (user != null) {
        _loadProfiles();
      } else {
        _profiles = [];
        _currentProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signup(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _loadProfiles() async {
    if (_user == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('profiles')
        .get();
    _profiles =
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    if (_profiles.isNotEmpty && _currentProfile == null) {
      _currentProfile = _profiles.first;
    }
    notifyListeners();
  }

  Future<void> addProfile(String name) async {
    if (_user == null) return;
    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('profiles')
        .add({'name': name, 'createdAt': Timestamp.now()});
    _profiles.add({'id': ref.id, 'name': name});
    _currentProfile ??= _profiles.last;
    notifyListeners();
  }

  void setCurrentProfile(Map<String, dynamic> profile) {
    _currentProfile = profile;
    notifyListeners();
  }
}

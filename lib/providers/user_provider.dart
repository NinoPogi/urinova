import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class UserProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.loading;
  User? _user;
  List<Map<String, dynamic>> _profiles = [];
  Map<String, dynamic>? _currentProfile;
  DateTime? _testSchedule;

  User? get user => _user;
  List<Map<String, dynamic>> get profiles => _profiles;
  Map<String, dynamic>? get currentProfile => _currentProfile;
  DateTime? get testSchedule => _testSchedule;
  AuthStatus get status => _status;

  UserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      _user = user;
      if (user != null) {
        await _loadProfiles();
        _status = AuthStatus.authenticated;
      } else {
        _profiles = [];
        _currentProfile = null;
        _status = AuthStatus.unauthenticated;
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
    final profilesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('profiles')
        .get();
    _profiles = profilesSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'],
        'testSchedule': data['testSchedule']?.toDate(),
        'createdAt': data['createdAt'],
      };
    }).toList();
    if (_profiles.isNotEmpty && _currentProfile == null) {
      _currentProfile = _profiles.first;
    }
    notifyListeners();
  }

  Future<void> addProfile(String name, {DateTime? schedule}) async {
    if (_user == null) return;
    final profileData = {
      'name': name,
      'createdAt': Timestamp.now(),
      'testSchedule': schedule,
    };
    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('profiles')
        .add(profileData);
    _profiles.add({'id': ref.id, ...profileData});
    _currentProfile ??= _profiles.last;
    notifyListeners();
  }

  Future<void> deleteProfile(String profileId) async {
    if (_user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('profiles')
        .doc(profileId)
        .delete();
    _profiles.removeWhere((profile) => profile['id'] == profileId);
    if (_currentProfile?['id'] == profileId) {
      _currentProfile = _profiles.isNotEmpty ? _profiles.first : null;
    }
    notifyListeners();
  }

  void setCurrentProfile(Map<String, dynamic> profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  Future<void> setTestSchedule(String profileId, DateTime? schedule) async {
    if (_user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('profiles')
        .doc(profileId)
        .update({'testSchedule': schedule});
    final profile = _profiles.firstWhere((p) => p['id'] == profileId);
    profile['testSchedule'] = schedule;
    if (_currentProfile?['id'] == profileId) {
      _currentProfile = profile;
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class UserProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.loading;
  User? _user;
  List<Map<String, dynamic>> _profiles = [];
  Map<String, dynamic>? _currentProfile;
  Map<String, dynamic>? _testSchedule;

  User? get user => _user;
  List<Map<String, dynamic>> get profiles => _profiles;
  Map<String, dynamic>? get currentProfile => _currentProfile;
  Map<String, dynamic>? get testSchedule => _testSchedule;
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

  Future<void> signup(String email, String password, {String? gender}) async {
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final uid = userCredential.user?.uid;
    if (uid == null) {
      throw FirebaseAuthException(
        code: 'MISSING-UID',
        message: 'Could not get UID after signup.',
      );
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email.trim(),
      'gender': gender ?? 'unspecified',
      'createdAt': FieldValue.serverTimestamp(),
    });
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
        'gender': data['gender'],
        'name': data['name'],
        'testSchedule': data['testSchedule'],
        'createdAt': data['createdAt'],
      };
    }).toList();
    if (_profiles.isNotEmpty && _currentProfile == null) {
      _currentProfile = _profiles.first;
    }
    notifyListeners();
  }

  Future<void> addProfile(String name,
      {Map<String, dynamic>? schedule, String? gender, required}) async {
    if (_user == null) return;
    final profileData = {
      'name': name,
      'gender': gender,
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

  Future<void> setTestSchedule(
      String profileId, Map<String, dynamic>? schedule) async {
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

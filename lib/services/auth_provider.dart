import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Dummy properties untuk ganti Firebase
  String? _currentUserId;
  bool _isSignedIn = false;

  String? get currentUserId => _currentUserId;
  bool get isSignedIn => _isSignedIn;

  Future<void> signIn(String email, String password) async {
    // Dummy sign in - langsung sukses
    _currentUserId = "dummy_user_id";
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    // Dummy sign out
    _currentUserId = null;
    _isSignedIn = false;
    notifyListeners();
  }
}

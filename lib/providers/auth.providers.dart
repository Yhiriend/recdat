import 'package:flutter/material.dart';
import 'package:recdat/modules/user/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isSignedIn = false;

  User? get user => _user;
  bool get isSignedIn => _isSignedIn;

  AuthProvider() {
    checkSign();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }
}

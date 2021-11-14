import 'package:flutter/material.dart';
import 'package:walltex_app/Services/user_class.dart';

class ControlProvider with ChangeNotifier {
  User? _mainUser;

  User getUser() {
    return _mainUser!;
  }

  void setUser({required User user}) {
    _mainUser = user;
    notifyListeners();
  }
}

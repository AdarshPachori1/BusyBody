import 'package:flutter/foundation.dart';

class MutableValues extends ChangeNotifier {
  bool _loggedIn = false;
  bool _signingUp = false;
  String _uuid = "";

  bool get loggedIn => _loggedIn;
  bool get signedUp => _signingUp;
  String get uuid => _uuid;

  void signUp(String uuid) {
    _uuid = uuid;
    _signingUp = true;
    notifyListeners();
  }

  void completedSignUp() {
    _signingUp = false;
    _loggedIn = true;
    notifyListeners();
  }

  void signIn(String? uuid) {
    if (uuid != null) {
      _uuid = uuid;
    }

    _loggedIn = true;
    notifyListeners();
  }

  void signOut() {
    _loggedIn = false;
    notifyListeners();
  }
}

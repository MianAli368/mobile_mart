import 'package:flutter/cupertino.dart';

class LocationMV with ChangeNotifier {
  String _address = "";
  String get address => _address;
  void setLocation(String address) {
    _address = address;
    notifyListeners();
  }
}

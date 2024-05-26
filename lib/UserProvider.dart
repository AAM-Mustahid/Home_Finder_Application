import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_finder_app/constants.dart'; // Add this line

class UserProvider with ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userInfo;

  User? get user => _user;
  Map<String, dynamic>? get userInfo => _userInfo;

  set user(User? value) {
    _user = value;
    notifyListeners(); // Notify listeners when user changes
  }

  Future<void> fetchUserInfo() async {
    if (_user != null) {
      var dio = Dio();
      final response = await dio
          .get('${Constants.server}/users/getUserById?uid=${user!.uid}');

      if (response.statusCode == 200) {
        // print('userInfo ${response.data}');
        _userInfo = response.data;
        notifyListeners(); // Notify listeners when user info changes
      } else {
        throw Exception('Failed to load user info');
      }
    }
  }
}

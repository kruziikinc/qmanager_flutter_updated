import 'dart:convert';

import 'package:qmanager_flutter_updated/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef stringCallback = void Function(String resultString);
typedef UerModelBlock = void Function(UserModel userModel);

class SessionManager {
  static const String User = "user";
  static const String DeviceToken = "DeviceToken";

  getUserModel(UerModelBlock callback) async {
    final prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(User);

    Map<String, dynamic> jsonMap =
        stringValue != null ? json.decode(stringValue) : null;
    callback(jsonMap != null ? UserModel.fromJson(jsonMap) : null);
  }

  setUserModel(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = json.encode(userModel);
    prefs.setString(User, encoded);
  }

  setUserModelNew(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(User, jsonString);
  }

  clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(User);
    prefs.remove(DeviceToken);
  }

  saveDeviceToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(DeviceToken, token);
  }

  getDeviceToken(stringCallback callback) async {
    final prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(DeviceToken);
    callback(stringValue);
  }

  /**
   * App version
   */

}

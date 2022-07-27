import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveUserId(String userId) async => prefs.setString("user_id", userId);

  static Future<String?> loadUserId() async => prefs.getString('user_id');

  static Future<bool> removeUserId() async => prefs.remove('user_id');
}

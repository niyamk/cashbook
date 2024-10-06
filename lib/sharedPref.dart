import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future setList(list) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.setStringList('list', list);
  }

  static Future getList() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getStringList('list');
  }

  static Future setNewUser() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.setString('isNewUser', 'False');
  }

  static Future getNewUser() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('isNewUser');
  }

  static Future setTheme({required theme}) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.setString('theme', theme);
  }


  static Future getTheme() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('theme');
  }


}

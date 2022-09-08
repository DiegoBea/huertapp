import 'package:huertapp/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;

  static bool _isDarkMode = false;
  static List<Province> _provinces = [];

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static bool get isDarkMode {
    return _preferences.getBool('isDarkMode') ?? false;
  }

  static List<Province> get provinces {
    List<String>? provincesJson = _preferences.getStringList('provinces');
    if (provincesJson == null) return [];
    List<Province> provinces = [];

    for (var provinceJson in provincesJson) {
      Province province = Province.fromJson(provinceJson);
      provinces.add(province);
    }

    _provinces = provinces;

    return _provinces;
  }

  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _preferences.setBool('isDarkMode', _isDarkMode);
  }

  static set provinces(List<Province> provinces) {
    _provinces = provinces;
    List<String> provincesJson = [];
    for (var province in provinces) {
      provincesJson.add(province.toJson());
    }
    _preferences.setStringList('provinces', provincesJson);
  }
}

import 'package:huertapp/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;

  static bool _isDarkMode = false;
  static List<Province> _provinces = [];
  static List<Township> _townships = [];
  static String _lang = 'es';

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

  static List<Township> get townships {
    List<String>? townshipsJson = _preferences.getStringList('townships');
    if (townshipsJson == null) return [];
    List<Township> townships = [];

    for (var townshipJson in townshipsJson) {
      Township township = Township.fromJson(townshipJson);
      townships.add(township);
    }

    _townships = townships;

    return _townships;
  }

  static String get lang {
    return _preferences.getString('lang') ?? _lang;
  }

  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _preferences.setBool('isDarkMode', _isDarkMode);
  }

  static set provinces(List<Province> provinces) {
    _provinces = provinces;
    List<String> provincesJson = [];
    for (Province province in provinces) {
      provincesJson.add(province.toJson());
    }
    _preferences.setStringList('provinces', provincesJson);
  }

  static set townships(List<Township> township) {
    _townships = township;
    List<String> townshipsJson = [];
    for (Township township in township) {
      townshipsJson.add(township.toJson());
    }
    _preferences.setStringList('townships', townshipsJson);
  }

  static set lang(String lang) {
    _lang = lang;
    _preferences.setString('lang', lang);
  }
}

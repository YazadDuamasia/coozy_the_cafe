import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  static const String _key = 'user_language';

  static Future<SharedPreferences> _getInstance() async {
    return SharedPreferences.getInstance();
  }

  static Future<String> getLanguageCode() async {
    final prefs = await _getInstance();
    return prefs.getString(_key) ?? 'en';
  }

  static Future<void> setLanguageCode(String languageCode) async {
    final prefs = await _getInstance();
    await prefs.setString(_key, languageCode);
  }
}

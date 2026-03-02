import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static const String _keyApiKey = 'gemini_api_key';
  static const String _keyMasterPrompt = 'master_prompt';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveApiKey(String key) async {
    await _prefs?.setString(_keyApiKey, key);
  }

  static String? getApiKey() {
    return _prefs?.getString(_keyApiKey);
  }

  static Future<void> saveMasterPrompt(String prompt) async {
    await _prefs?.setString(_keyMasterPrompt, prompt);
  }

  static String? getMasterPrompt() {
    return _prefs?.getString(_keyMasterPrompt);
  }
  
  static bool isApiKeySet() {
    return getApiKey() != null && getApiKey()!.isNotEmpty;
  }
}

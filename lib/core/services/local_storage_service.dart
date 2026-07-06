import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();

  SharedPreferences? _preferences;
  final Map<String, Object?> _fallbackStorage = <String, Object?>{};

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  bool? getBool(String key) {
    final preferences = _preferences;
    if (preferences != null) {
      return preferences.getBool(key);
    }
    final value = _fallbackStorage[key];
    return value is bool ? value : null;
  }

  String? getString(String key) {
    final preferences = _preferences;
    final value = preferences != null
        ? preferences.getString(key)
        : _fallbackStorage[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  Future<void> setBool(String key, bool value) async {
    final preferences = _preferences;
    if (preferences != null) {
      await preferences.setBool(key, value);
      return;
    }
    _fallbackStorage[key] = value;
  }

  Future<void> saveBool(String key, bool value) => setBool(key, value);

  Future<void> setString(String key, String value) async {
    final preferences = _preferences;
    if (preferences != null) {
      await preferences.setString(key, value);
      return;
    }
    _fallbackStorage[key] = value;
  }

  Future<void> saveString(String key, String value) => setString(key, value);

  Future<void> remove(String key) async {
    final preferences = _preferences;
    if (preferences != null) {
      await preferences.remove(key);
      return;
    }
    _fallbackStorage.remove(key);
  }

  Future<void> clear() async {
    final preferences = _preferences;
    if (preferences != null) {
      await preferences.clear();
      return;
    }
    _fallbackStorage.clear();
  }
}

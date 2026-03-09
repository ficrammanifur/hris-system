import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late final SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Theme
  static Future<void> setThemeMode(String mode) async {
    await _prefs.setString('theme_mode', mode);
  }
  
  static String getThemeMode() {
    return _prefs.getString('theme_mode') ?? 'system';
  }
  
  // First Launch
  static Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool('is_first_launch', value);
  }
  
  static bool isFirstLaunch() {
    return _prefs.getBool('is_first_launch') ?? true;
  }
  
  // Notifications
  static Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
  }
  
  static bool areNotificationsEnabled() {
    return _prefs.getBool('notifications_enabled') ?? true;
  }
  
  // Biometric
  static Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs.setBool('biometric_enabled', enabled);
  }
  
  static bool isBiometricEnabled() {
    return _prefs.getBool('biometric_enabled') ?? false;
  }
  
  // Last Sync
  static Future<void> setLastSyncTime(DateTime time) async {
    await _prefs.setString('last_sync_time', time.toIso8601String());
  }
  
  static DateTime? getLastSyncTime() {
    final timeStr = _prefs.getString('last_sync_time');
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }
  
  // Clear all
  static Future<void> clear() async {
    await _prefs.clear();
  }
}
import 'package:flutter/material.dart';
import 'package:mobile_flutter/data/datasources/local/shared_prefs.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeProvider() {
    _loadThemeMode();
  }
  
  ThemeMode get themeMode => _themeMode;
  
  void _loadThemeMode() {
    final savedMode = SharedPrefs.getThemeMode();
    switch (savedMode) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
  }
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    
    String modeStr = 'system';
    if (mode == ThemeMode.light) modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    
    SharedPrefs.setThemeMode(modeStr);
    notifyListeners();
  }
  
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      // If system, check current brightness
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.light) {
        setThemeMode(ThemeMode.dark);
      } else {
        setThemeMode(ThemeMode.light);
      }
    }
  }
  
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
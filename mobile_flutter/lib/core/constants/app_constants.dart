class AppConstants {
  static const String appName = 'HRIS Mobile';
  static const String appVersion = '1.0.0';
  
  // Shared Preferences Keys
  static const String themeMode = 'theme_mode';
  static const String isFirstLaunch = 'is_first_launch';
  
  // Secure Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  
  // Pagination
  static const int pageSize = 20;
  
  // Location
  static const double officeLatitude = -6.2088; // Example: Jakarta
  static const double officeLongitude = 106.8456;
  static const double maxDistance = 100; // meters
}
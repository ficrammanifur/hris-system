import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_flutter/providers/auth_provider.dart';
import 'package:mobile_flutter/providers/attendance_provider.dart';
import 'package:mobile_flutter/providers/leave_provider.dart';
import 'package:mobile_flutter/providers/theme_provider.dart';
import 'package:mobile_flutter/routes/app_routes.dart';
import 'package:mobile_flutter/theme/app_theme.dart';
import 'package:mobile_flutter/core/utils/notification_service.dart';
import 'package:mobile_flutter/data/datasources/local/shared_prefs.dart';
import 'package:mobile_flutter/data/datasources/local/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await SharedPrefs.init();
  await SecureStorage.init();
  await NotificationService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'HRIS Mobile',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            navigatorKey: NavigationService.navigatorKey,
          );
        },
      ),
    );
  }
}

// Navigation Service untuk navigasi dari luar widget tree
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }
  
  static Future<dynamic> navigateToReplacement(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
  
  static void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
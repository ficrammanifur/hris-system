import 'package:flutter/material.dart';
import 'package:mobile_flutter/screens/splash/splash_screen.dart';
import 'package:mobile_flutter/screens/auth/login_screen.dart';
import 'package:mobile_flutter/screens/home/home_screen.dart';
import 'package:mobile_flutter/screens/attendance/check_in_screen.dart';
import 'package:mobile_flutter/screens/profile/profile_screen.dart';
import 'package:mobile_flutter/screens/leave/leave_request_screen.dart';
// Hapus import yang bermasalah
// import 'package:mobile_flutter/screens/attendance/history_screen.dart';
// import 'package:mobile_flutter/screens/attendance/summary_screen.dart';
// import 'package:mobile_flutter/screens/leave/leave_request_screen.dart';
// import 'package:mobile_flutter/screens/leave/leave_history_screen.dart';
// import 'package:mobile_flutter/screens/leave/leave_balance_screen.dart';
// import 'package:mobile_flutter/screens/profile/edit_profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String checkIn = '/check-in';
  static const String profile = '/profile';
  static const String leaveRequest = '/leave/request';
  // static const String attendanceHistory = '/attendance/history';
  // static const String attendanceSummary = '/attendance/summary';
  // static const String leaveRequest = '/leave/request';
  // static const String leaveHistory = '/leave/history';
  // static const String leaveBalance = '/leave/balance';
  // static const String editProfile = '/profile/edit';
  
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
        
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
        
      case checkIn:
        return MaterialPageRoute(builder: (_) => const CheckInScreen());
        
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
        
      case leaveRequest:
        return MaterialPageRoute(builder: (_) => const LeaveRequestScreen());
        
      // case attendanceHistory:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   return MaterialPageRoute(
      //     builder: (_) => AttendanceHistoryScreen(
      //       userId: args?['userId'] as int?,
      //     ),
      //   );
        
      // case attendanceSummary:
      //   final args = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => AttendanceSummaryScreen(
      //       userId: args['userId'] as int,
      //     ),
      //   );
        
      // case leaveRequest:
      //   return MaterialPageRoute(builder: (_) => const LeaveRequestScreen());
        
      // case leaveHistory:
      //   return MaterialPageRoute(builder: (_) => const LeaveHistoryScreen());
        
      // case leaveBalance:
      //   return MaterialPageRoute(builder: (_) => const LeaveBalanceScreen());
        
      // case editProfile:
      //   return MaterialPageRoute(builder: (_) => const EditProfileScreen());
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
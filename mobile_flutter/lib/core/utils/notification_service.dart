import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }
  
  static void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }
  
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
      'hris_channel',
      'HRIS Notifications',
      channelDescription: 'Notifications for HRIS app',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const DarwinNotificationDetails iosDetails = 
        DarwinNotificationDetails();
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details, payload: payload);
  }
  
  static Future<void> showAttendanceReminder() async {
    await showNotification(
      id: 1,
      title: 'Check-in Reminder',
      body: 'Don\'t forget to check in for today!',
    );
  }
  
  static Future<void> showLeaveStatusUpdate({
    required String status,
    required String reason,
  }) async {
    await showNotification(
      id: 2,
      title: 'Leave Request $status',
      body: 'Your leave request has been $status. $reason',
    );
  }
  
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
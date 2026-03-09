import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }
  
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }
  
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
  
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
  
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
}